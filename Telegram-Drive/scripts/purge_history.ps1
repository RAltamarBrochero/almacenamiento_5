<#
Purge repository history using BFG. This script performs a mirror clone,
downloads BFG, runs it with common filters (large blobs, .env, node_modules,
backups, certs), then forces the cleaned history back to origin.

WARNING: This rewrites history and will require all collaborators to re-clone.
Run only if you understand the consequences.

Usage (PowerShell from repo parent):
  .\Telegram-Drive\scripts\purge_history.ps1

Prerequisites:
- Java (java -version must work)
- Network access to GitHub and ability to force-push to the repo

The script will prompt before performing the force-push.
#>

param()

$mirrorDir = "repo-mirror.git"
$remoteUrl = "https://github.com/RAltamarBrochero/almacenamiento_5.git"
$bfgUrl = "https://repo1.maven.org/maven2/com/madgag/bfg/1.14.0/bfg-1.14.0.jar"
$bfgJar = "bfg.jar"

if (-not (Get-Command git -ErrorAction SilentlyContinue)) { Write-Error "git is required."; exit 1 }
if (-not (Get-Command java -ErrorAction SilentlyContinue)) { Write-Error "Java not found. Install Java 11+ and re-run."; exit 1 }

if (Test-Path $mirrorDir) { Write-Output "Removing existing $mirrorDir"; Remove-Item -Recurse -Force $mirrorDir }

Write-Output "Cloning mirror from $remoteUrl"
git clone --mirror $remoteUrl $mirrorDir
if ($LASTEXITCODE -ne 0) { Write-Error "Mirror clone failed"; exit 1 }

Set-Location $mirrorDir

Write-Output "Downloading BFG..."
Invoke-WebRequest -Uri $bfgUrl -OutFile $bfgJar
if (-not (Test-Path $bfgJar)) { Write-Error "Failed to download BFG"; exit 1 }

Write-Output "Running BFG to remove sensitive files and large blobs (>=100MB)"
java -jar $bfgJar --strip-blobs-bigger-than 100M --delete-files ".env" --delete-folders "node_modules" --delete-folders ".npm-cache" --delete-folders "certs" --delete-folders "backups" .
if ($LASTEXITCODE -ne 0) { Write-Error "BFG failed"; exit 1 }

Write-Output "Cleaning and compacting repository"
git reflog expire --expire=now --all
git gc --prune=now --aggressive

Write-Output "About to force-push cleaned history to origin. This is destructive."
$confirm = Read-Host "Type 'FORCE_PUSH' to proceed with force-push, anything else to cancel"
if ($confirm -ne 'FORCE_PUSH') { Write-Output "Cancelled by user."; exit 0 }

Write-Output "Force-pushing to origin..."
git push --force
if ($LASTEXITCODE -ne 0) { Write-Error "Force-push failed"; exit 1 }

Write-Output "Purge complete. Instruct collaborators to reclone the repository."
