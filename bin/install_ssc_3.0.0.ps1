$ErrorActionPreference = 'Stop'
$Version = '3.0.0'
$Root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$Project = Join-Path $Root 'src\ssc.lpi'
$Exe = Join-Path $Root 'src\ssc.exe'
$InstallDir = Join-Path $env:LOCALAPPDATA 'Programs\SSC3'

function Find-LazBuild {
  $cmd = Get-Command lazbuild.exe -ErrorAction SilentlyContinue
  if ($cmd) { return $cmd.Source }
  foreach ($p in @('C:\lazarus\lazbuild.exe','C:\Program Files\Lazarus\lazbuild.exe','C:\Program Files (x86)\Lazarus\lazbuild.exe')) {
    if (Test-Path $p) { return $p }
  }
  throw 'lazbuild.exe not found. Install Lazarus/FPC and CHATGPT packages first.'
}

$LazBuild = Find-LazBuild
Write-Host "[SSC] Building version $Version"
& $LazBuild $Project
if ($LASTEXITCODE -ne 0) { throw 'Lazarus build failed.' }
if (!(Test-Path $Exe)) { throw 'src\ssc.exe was not generated.' }

New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null
Copy-Item $Exe (Join-Path $InstallDir 'ssc.exe') -Force
$WshShell = New-Object -ComObject WScript.Shell
$StartMenu = Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs\SSC Serial Analyzer.lnk'
$Shortcut = $WshShell.CreateShortcut($StartMenu)
$Shortcut.TargetPath = Join-Path $InstallDir 'ssc.exe'
$Shortcut.WorkingDirectory = $InstallDir
$Shortcut.Save()
$Desktop = [Environment]::GetFolderPath('Desktop')
$DesktopLink = Join-Path $Desktop 'SSC Serial Analyzer.lnk'
$Shortcut2 = $WshShell.CreateShortcut($DesktopLink)
$Shortcut2.TargetPath = Join-Path $InstallDir 'ssc.exe'
$Shortcut2.WorkingDirectory = $InstallDir
$Shortcut2.Save()
Write-Host "SSC $Version installed at $InstallDir"
