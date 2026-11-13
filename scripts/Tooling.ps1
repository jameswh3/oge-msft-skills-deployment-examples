#requires -Version 7.0
function Get-WorkspaceNode {
    $name = if ($IsWindows) { 'node.exe' } else { 'node' }
    $path = Join-Path $PSScriptRoot "..\node_modules\node\bin\$name"
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { throw 'Run npm ci to restore the pinned workspace Node runtime.' }
    return [IO.Path]::GetFullPath($path)
}
