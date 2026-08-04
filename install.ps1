# Adds the graphify skill to the current project folder.
# Run from inside the project you want to add it to:
#   iwr -useb https://raw.githubusercontent.com/sergiogoqui-cpu/graphify-template/main/install.ps1 | iex

$ErrorActionPreference = "Stop"
$repo = "https://github.com/sergiogoqui-cpu/graphify-template.git"
$tmp = Join-Path $env:TEMP ("graphify-template-" + [guid]::NewGuid())

Write-Host "Fetching graphify skill files..."
git clone --depth 1 -q $repo $tmp

$targetSkills = ".\.claude\skills"
New-Item -ItemType Directory -Force -Path $targetSkills | Out-Null
Copy-Item -Path (Join-Path $tmp ".claude\skills\graphify") -Destination $targetSkills -Recurse -Force

if (-not (Test-Path ".\CLAUDE.md")) {
    Copy-Item -Path (Join-Path $tmp "CLAUDE.md") -Destination ".\CLAUDE.md"
} elseif (-not (Select-String -Path ".\CLAUDE.md" -Pattern "graphify" -Quiet)) {
    Add-Content -Path ".\CLAUDE.md" -Value "`n$(Get-Content (Join-Path $tmp 'CLAUDE.md') -Raw)"
}

Remove-Item -Recurse -Force $tmp

if (-not (Get-Command graphify -ErrorAction SilentlyContinue)) {
    Write-Host "Installing graphify CLI (uv tool install graphifyy)..."
    if (Get-Command uv -ErrorAction SilentlyContinue) {
        uv tool install graphifyy
    } else {
        pip install graphifyy
    }
}

Write-Host ""
Write-Host "Done. graphify is ready in this project - open Claude Code here and type: /graphify ."
