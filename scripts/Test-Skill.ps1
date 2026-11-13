#requires -Version 7.0
[CmdletBinding()]
param([string]$SkillPath = (Join-Path $PSScriptRoot '..\skills\meeting-notes'))
$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'Tooling.ps1')
& (Get-WorkspaceNode) (Join-Path $PSScriptRoot 'validate-skill.mjs') $SkillPath
if ($LASTEXITCODE -ne 0) { throw 'Skill validation failed. Run npm ci if dependencies are missing.' }
