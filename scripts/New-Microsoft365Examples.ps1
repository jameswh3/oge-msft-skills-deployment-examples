#requires -Version 7.0
[CmdletBinding()]
param(
    [ValidateSet('Plugin', 'DeclarativeAgent')][string]$Kind = 'Plugin',
    [string]$OutputPath = (Join-Path $PSScriptRoot '..\out\microsoft-365')
)
$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'Tooling.ps1')
$root = Split-Path $PSScriptRoot -Parent
& (Join-Path $PSScriptRoot 'Test-Skill.ps1') | Out-Null
$node = Get-WorkspaceNode
$name = if ($Kind -eq 'Plugin') { 'meeting-notes-plugin' } else { 'meeting-notes-agent' }
$project = Join-Path ([IO.Path]::GetFullPath($OutputPath)) $name
if (Test-Path -LiteralPath $project) { throw "Destination already exists; choose a fresh OutputPath: $project" }
New-Item $OutputPath -ItemType Directory -Force | Out-Null
if ($Kind -eq 'Plugin') {
    $cli = Join-Path $root 'node_modules\@microsoft\wiqd\bin\wiqd.js'
    & $node $cli plugin create --name $name --output $OutputPath
    if ($LASTEXITCODE -ne 0) { throw 'WIQD scaffold failed. Review its EULA/prerequisite message; no automatic acceptance is performed.' }
    & $node $cli plugin add skill --name 'Meeting Notes' --folder $project
    if ($LASTEXITCODE -ne 0) { throw 'WIQD skill registration failed.' }
} else {
    $atk = Get-Command atk -ErrorAction Stop
    $toolVersion = (& $atk.Source --version | Out-String).Trim()
    if ($toolVersion -ne '1.1.17') { throw "Expected Agents Toolkit 1.1.17; found $toolVersion." }
    $previousFlag = $env:TEAMSFX_AGENT_SKILLS
    try {
        $env:TEAMSFX_AGENT_SKILLS = 'true'
        & $atk.Source new --capability declarative-agent --app-name $name --folder $OutputPath --interactive false --telemetry false
        if ($LASTEXITCODE -ne 0) { throw 'Agents Toolkit scaffold failed.' }
        $destination = Join-Path $project 'appPackage\skills\meeting-notes'
        New-Item $destination -ItemType Directory -Force | Out-Null
        Copy-Item (Join-Path $root 'skills\meeting-notes\SKILL.md') (Join-Path $destination 'SKILL.md')
        & $atk.Source add skill --from $destination --folder $project --interactive false --telemetry false
        if ($LASTEXITCODE -ne 0) { throw 'Agents Toolkit skill import failed.' }
        $agentPath = Join-Path $project 'appPackage\declarativeAgent.json'
        $agent = Get-Content $agentPath -Raw | ConvertFrom-Json
        $agent.'$schema' = 'https://developer.microsoft.com/json-schemas/copilot/declarative-agent/v1.9/schema.json'
        $agent.version = 'v1.9'
        $agent.description = 'Draft summaries, decisions, action items, and unresolved questions from supplied notes.'
        $agent.instructions = 'Use the meeting-notes skill for supplied meeting notes. Return drafts only. Do not fetch data or perform external actions.'
        $agent | ConvertTo-Json -Depth 20 | Set-Content $agentPath -Encoding utf8NoBOM
    } finally { $env:TEAMSFX_AGENT_SKILLS = $previousFlag }
}
$target = Join-Path $project 'appPackage\skills\meeting-notes\SKILL.md'
Copy-Item (Join-Path $root 'skills\meeting-notes\SKILL.md') $target -Force
if ((Get-FileHash $target).Hash -ne (Get-FileHash (Join-Path $root 'skills\meeting-notes\SKILL.md')).Hash) {
    throw 'Scaffold skill content differs from the canonical source.'
}
Write-Host "Local scaffold ready: $project"
Write-Host 'No provisioning, tenant validation upload, publication, or sharing was performed.'
