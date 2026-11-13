#requires -Version 7.0
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
. (Join-Path $root 'scripts\Tooling.ps1')
Get-ChildItem (Join-Path $root 'scripts\*.ps1'), (Join-Path $PSScriptRoot '*.ps1') | ForEach-Object {
    $tokens = $null
    $parseErrors = $null
    [Management.Automation.Language.Parser]::ParseFile($_.FullName, [ref]$tokens, [ref]$parseErrors) | Out-Null
    if ($parseErrors.Count) { throw ($parseErrors | Out-String) }
}
& (Get-WorkspaceNode) --test (Join-Path $PSScriptRoot 'validate-skill.test.mjs')
if ($LASTEXITCODE -ne 0) { throw 'Skill validation tests failed.' }
$temporary = Join-Path ([IO.Path]::GetTempPath()) "skill-packaging-$([guid]::NewGuid().ToString('N'))"
New-Item $temporary -ItemType Directory | Out-Null
try {
    & (Join-Path $root 'scripts\Build-Packages.ps1') -OutputPath (Join-Path $temporary 'packages') | Out-Null
    $metadata = Get-Content (Join-Path $temporary 'packages\artifacts.json') -Raw | ConvertFrom-Json
    if ($metadata.skill -ne 'meeting-notes' -or $metadata.artifacts.Count -ne 3) { throw 'Incomplete artifact metadata.' }
    $expected = @{
        'skill' = 'SKILL.md'
        'github-repository' = '.github/skills/meeting-notes/SKILL.md'
        'github-marketplace' = 'skills/meeting-notes/SKILL.md'
    }
    foreach ($kind in $expected.Keys) {
        $zip = Join-Path $temporary "packages\$kind-$($metadata.version).zip"
        $archive = [IO.Compression.ZipFile]::OpenRead($zip)
        try {
            $entry = $archive.GetEntry($expected[$kind])
            if (-not $entry -or $entry.Length -eq 0) { throw "Incorrect archive root for $kind." }
            if ($kind -eq 'github-marketplace') {
                foreach ($path in @('.claude-plugin/marketplace.json', 'plugin.json')) {
                    if (-not $archive.GetEntry($path)) { throw "Missing $path" }
                }
            }
        } finally { $archive.Dispose() }
    }
    $mutated = Join-Path $temporary 'changed\meeting-notes'
    New-Item $mutated -ItemType Directory -Force | Out-Null
    $canonical = Join-Path $root 'skills\meeting-notes\SKILL.md'
    Copy-Item $canonical (Join-Path $mutated 'SKILL.md')
    Add-Content (Join-Path $mutated 'SKILL.md') "`nA changed instruction."
    & (Join-Path $root 'scripts\Build-Packages.ps1') -SkillPath $mutated -OutputPath (Join-Path $temporary 'changed-output') | Out-Null
    $changed = Get-Content (Join-Path $temporary 'changed-output\artifacts.json') -Raw | ConvertFrom-Json
    if ($changed.canonicalSha256 -eq $metadata.canonicalSha256) { throw 'Content drift was not reflected in provenance.' }
    $marketplace = Get-Content (Join-Path $root '.claude-plugin\marketplace.json') -Raw | ConvertFrom-Json
    $plugin = Get-Content (Join-Path $root 'plugin.json') -Raw | ConvertFrom-Json
    $package = Get-Content (Join-Path $root 'package.json') -Raw | ConvertFrom-Json
    if ($plugin.version -ne $package.version) { throw 'Plugin and package release versions disagree.' }
    $policy = Get-Content (Join-Path $root 'platforms\github-copilot\enterprise-policy\managed-settings.json') -Raw | ConvertFrom-Json
    $pluginPath = Join-Path $root $marketplace.plugins[0].source
    if (-not (Test-Path (Join-Path $pluginPath 'skills\meeting-notes\SKILL.md'))) { throw 'Marketplace source has no canonical skill.' }
    if ($marketplace.plugins[0].name -ne $plugin.name -or
        $policy.enabledPlugins."$($plugin.name)@$($marketplace.name)" -ne $true) {
        throw 'Marketplace, plugin and enterprise-policy identifiers disagree.'
    }
    & (Join-Path $root 'scripts\Invoke-FoundrySkill.ps1') -ProjectEndpoint 'https://example.services.ai.azure.com/api/projects/example' -Operation CreateVersion -WhatIf
    Write-Host 'PASS: metadata, archive roots, packaged content hashes, manifests, and changed-source provenance.'
} finally {
    Remove-Item -LiteralPath $temporary -Recurse -Force
}
