<#
Untrack Telegram-Drive/.env safely and commit the change.
Run from repository root in PowerShell:
  .\Telegram-Drive\scripts\untrack_env.ps1
#>
$envPath = "Telegram-Drive/.env"
if (Test-Path $envPath) {
    $isTracked = git ls-files --error-unmatch $envPath 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Output "Removing $envPath from git index (will keep local file)..."
        git rm --cached $envPath
        git commit -m "chore: remove .env from index (use GitHub Secrets)" || Write-Output "No commit necessary"
        Write-Output "Pushing to origin..."
        git push || Write-Output "Push failed; please push manually"
    } else {
        Write-Output "$envPath is not tracked by git. No action needed."
    }
} else {
    Write-Output "$envPath not found on disk. Nothing to do."
}
