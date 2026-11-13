#requires -Version 7.0
[CmdletBinding()]
param(
    [string]$OutputPath = (Join-Path $PSScriptRoot '..\out'),
    [string]$SkillPath = (Join-Path $PSScriptRoot '..\skills\meeting-notes')
)
$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'Tooling.ps1')
$root = Split-Path $PSScriptRoot -Parent
$skill = (& (Get-WorkspaceNode) (Join-Path $PSScriptRoot 'validate-skill.mjs') $SkillPath) | ConvertFrom-Json
if ($LASTEXITCODE -ne 0) { throw 'Skill validation failed.' }
if (-not $skill.name -or -not $skill.files.Count) { throw 'Skill validator returned no metadata or files.' }
$version = (Get-Content (Join-Path $root 'package.json') -Raw | ConvertFrom-Json).version
$output = [IO.Path]::GetFullPath($OutputPath)
New-Item $output -ItemType Directory -Force | Out-Null
$staging = Join-Path $output ([guid]::NewGuid().ToString('N'))
New-Item $staging -ItemType Directory | Out-Null
try {
    $trees = @{
        'skill' = ''
        'github-repository' = ".github\skills\$($skill.name)"
        'github-marketplace' = "skills\$($skill.name)"
    }
    $artifacts = @()
    foreach ($kind in $trees.Keys | Sort-Object) {
        $tree = Join-Path $staging $kind
        $destination = Join-Path $tree $trees[$kind]
        New-Item $destination -ItemType Directory -Force | Out-Null
        foreach ($file in $skill.files) {
            $relative = [IO.Path]::GetRelativePath([IO.Path]::GetFullPath($SkillPath), $file)
            $target = Join-Path $destination $relative
            New-Item (Split-Path $target -Parent) -ItemType Directory -Force | Out-Null
            Copy-Item -LiteralPath $file -Destination $target
            if ((Get-FileHash $file).Hash -ne (Get-FileHash $target).Hash) { throw "Copy drift: $relative" }
        }
        if ($kind -eq 'github-marketplace') {
            Copy-Item (Join-Path $root 'plugin.json') (Join-Path $tree 'plugin.json')
            New-Item (Join-Path $tree '.claude-plugin') -ItemType Directory | Out-Null
            Copy-Item (Join-Path $root '.claude-plugin\marketplace.json') (Join-Path $tree '.claude-plugin\marketplace.json')
        }
        $zip = Join-Path $output "$kind-$version.zip"
        $temporaryZip = Join-Path $staging "$kind.zip"
        [IO.Compression.ZipFile]::CreateFromDirectory($tree, $temporaryZip)
        $archive = [IO.Compression.ZipFile]::OpenRead($temporaryZip)
        try {
            foreach ($file in $skill.files) {
                $relative = [IO.Path]::GetRelativePath([IO.Path]::GetFullPath($SkillPath), $file)
                $entryPath = if ($trees[$kind]) { (Join-Path $trees[$kind] $relative).Replace('\', '/') } else { $relative.Replace('\', '/') }
                $entry = $archive.GetEntry($entryPath)
                if (-not $entry) { throw "Missing ZIP entry: $entryPath" }
                $stream = $entry.Open()
                try {
                    $hasher = [Security.Cryptography.SHA256]::Create()
                    try { $hash = [Convert]::ToHexString($hasher.ComputeHash($stream)) } finally { $hasher.Dispose() }
                    if ($hash -ne (Get-FileHash $file).Hash) { throw "ZIP content drift: $entryPath" }
                } finally { $stream.Dispose() }
            }
            if (@($archive.Entries | Where-Object { $_.FullName -match '(^/|\\|(^|/)\.\.(/|$))' }).Count) {
                throw 'Unsafe ZIP entry.'
            }
        } finally { $archive.Dispose() }
        Move-Item $temporaryZip $zip -Force
        $artifacts += [ordered]@{
            file = [IO.Path]::GetFileName($zip)
            sha256 = (Get-FileHash $zip).Hash.ToLowerInvariant()
        }
    }
    $record = [ordered]@{
        version = $version
        skill = $skill.name
        canonicalSha256 = (Get-FileHash (Join-Path $SkillPath 'SKILL.md')).Hash.ToLowerInvariant()
        verification = 'Offline structure and canonical-content parity only; no host execution.'
        artifacts = $artifacts
    }
    $record | ConvertTo-Json -Depth 5 | Set-Content (Join-Path $output 'artifacts.json') -Encoding utf8NoBOM
    $record
} finally {
    Remove-Item -LiteralPath $staging -Recurse -Force
}
