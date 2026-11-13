#requires -Version 7.0
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][ValidatePattern('^https://[a-z0-9-]+\.services\.ai\.azure\.com/api/projects/[a-zA-Z0-9_-]+/?$')][string]$ProjectEndpoint,
    [Parameter(Mandatory)][ValidateSet('CreateVersion', 'Inspect', 'SetDefault', 'Export')][string]$Operation,
    [ValidatePattern('^[a-z0-9]+(-[a-z0-9]+)*$')][string]$SkillName = 'meeting-notes',
    [ValidatePattern('^[1-9][0-9]*$')][string]$SkillVersion,
    [string]$OutputPath
)
$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'Tooling.ps1')
if ($Operation -in @('SetDefault', 'Export') -and -not $SkillVersion) { throw 'An immutable SkillVersion is required.' }
if ($Operation -eq 'Export' -and (-not $OutputPath -or (Test-Path -LiteralPath $OutputPath))) {
    throw 'Export requires a new OutputPath; existing files are never overwritten.'
}
$endpoint = $ProjectEndpoint.TrimEnd('/')
$url = "$endpoint/skills/$SkillName`?api-version=v1"
$method = 'GET'
$body = $null
switch ($Operation) {
    'CreateVersion' {
        $skill = (& (Get-WorkspaceNode) (Join-Path $PSScriptRoot 'validate-skill.mjs') (Join-Path $PSScriptRoot "..\skills\$SkillName")) | ConvertFrom-Json
        if ($LASTEXITCODE -ne 0 -or -not $skill.instructions) { throw 'Canonical skill validation failed.' }
        $url = "$endpoint/skills/$SkillName/versions?api-version=v1"
        $method = 'POST'
        $body = @{ inline_content = @{ description = $skill.description; instructions = $skill.instructions } }
    }
    'SetDefault' {
        $method = 'POST'
        $body = @{ default_version = $SkillVersion }
    }
    'Export' { $url = "$endpoint/skills/$SkillName/versions/$SkillVersion/content?api-version=v1" }
}
if (-not $PSCmdlet.ShouldProcess($url, $Operation)) { return }
$token = (& az account get-access-token --scope 'https://ai.azure.com/.default' --query accessToken -o tsv)
if ($LASTEXITCODE -ne 0 -or -not $token) { throw 'Azure token acquisition failed. Sign in to the intended lab tenant.' }
$headers = @{ Authorization = "Bearer $token"; 'Foundry-Features' = 'Skills=V1Preview' }
$request = @{ Uri = $url; Method = $method; Headers = $headers; MaximumRedirection = 0; ErrorAction = 'Stop' }
try {
    if ($Operation -eq 'Export') {
        $path = [IO.Path]::GetFullPath($OutputPath)
        New-Item (Split-Path $path -Parent) -ItemType Directory -Force | Out-Null
        Invoke-WebRequest @request -OutFile $path
        $archive = [IO.Compression.ZipFile]::OpenRead($path)
        try {
            if (-not $archive.GetEntry('SKILL.md')) { throw 'Export archive has no root SKILL.md; review the service response.' }
            if (@($archive.Entries | Where-Object { $_.FullName -match '(^/|\\|(^|/)\.\.(/|$))' }).Count) {
                throw 'Export contains unsafe archive paths; do not extract it.'
            }
        } finally { $archive.Dispose() }
        $result = @{
            name = $SkillName; version = $SkillVersion
            projectEndpoint = $endpoint
            sha256 = (Get-FileHash $path).Hash.ToLowerInvariant()
        }
        $result | ConvertTo-Json | Set-Content "$path.provenance.json" -Encoding utf8NoBOM
        $result
    } else {
        if ($body) {
            $request.ContentType = 'application/json'
            $request.Body = [Text.Encoding]::UTF8.GetBytes(($body | ConvertTo-Json -Depth 10))
        }
        $result = Invoke-RestMethod @request
        if ($Operation -eq 'CreateVersion' -and -not $result.version) { throw 'Foundry did not return an immutable version.' }
        if ($Operation -eq 'SetDefault' -and $result.default_version -ne $SkillVersion) { throw 'Foundry did not confirm the requested default version.' }
        $result
    }
} finally {
    $headers.Clear()
    $token = $null
}
