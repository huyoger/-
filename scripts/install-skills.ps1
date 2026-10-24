param([string]$Destination)
$ErrorActionPreference = 'Stop'
if (-not $Destination) {
    $skillHome = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $env:USERPROFILE '.codex' }
    $Destination = Join-Path $skillHome 'skills'
}
$gitCommand = Get-Command git -ErrorAction SilentlyContinue
if (-not $gitCommand) {
    $bundledGit = Join-Path $env:USERPROFILE '.cache\codex-runtimes\codex-primary-runtime\dependencies\native\git\cmd\git.exe'
    if (Test-Path -LiteralPath $bundledGit) { $gitExe = $bundledGit }
    else { throw 'Git is required. Install Git for Windows, then run this script again.' }
} else { $gitExe = $gitCommand.Source }

$specs = @(
    @{ Name='ppt-master'; Repository='https://github.com/hugohe3/ppt-master.git'; Subdirectory='skills\ppt-master' },
    @{ Name='guizang-ppt-skill'; Repository='https://github.com/op7418/guizang-ppt-skill.git'; Subdirectory='' },
    @{ Name='frontend-slides'; Repository='https://github.com/zarazhangrui/frontend-slides.git'; Subdirectory='' },
    @{ Name='humanize-ppt'; Repository='https://github.com/LearnPrompt/humanize-ppt.git'; Subdirectory='' }
)
$stagingRoot = Join-Path $env:TEMP ('lighting-skills-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $Destination,$stagingRoot -Force | Out-Null
$results = @()
foreach ($spec in $specs) {
    $target = Join-Path $Destination $spec.Name
    if (Test-Path -LiteralPath $target) {
        Write-Warning ($spec.Name + ' already exists and will not be overwritten.')
        $results += @{ name=$spec.Name; status='skipped_existing'; path=$target }
        continue
    }
    $checkout = Join-Path $stagingRoot $spec.Name
    & $gitExe clone --depth 1 $spec.Repository $checkout
    if ($LASTEXITCODE -ne 0) { throw ('Download failed: ' + $spec.Name) }
    $source = if ($spec.Subdirectory) { Join-Path $checkout $spec.Subdirectory } else { $checkout }
    if (-not (Test-Path -LiteralPath (Join-Path $source 'SKILL.md'))) {
        throw ('SKILL.md is missing: ' + $spec.Name)
    }
    New-Item -ItemType Directory -Path $target | Out-Null
    Get-ChildItem -LiteralPath $source -Force |
        Where-Object { $_.Name -ne '.git' } |
        ForEach-Object { Copy-Item -LiteralPath $_.FullName -Destination $target -Recurse }
    if (-not (Test-Path -LiteralPath (Join-Path $target 'SKILL.md'))) {
        throw ('Installed files failed verification: ' + $spec.Name)
    }
    $commit = & $gitExe -C $checkout rev-parse HEAD
    $results += @{ name=$spec.Name; status='installed_files'; path=$target; repository=$spec.Repository; commit=$commit }
    Write-Host ('Installed files: ' + $spec.Name)
}
$results | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath (Join-Path $Destination 'lighting-skills-installation.json') -Encoding utf8
Write-Host 'Skill files are ready. Check availability in the next Codex turn.'
Write-Host 'Runtime dependencies must be checked separately against each upstream README.'
Write-Host ('Temporary checkouts retained at: ' + $stagingRoot)
