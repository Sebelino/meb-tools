# Location of your pip-installed binaries
$BinPath = "Z:\my_python_packages\bin"
$AzExe = Join-Path $BinPath "az"

Write-Host "Checking for existing Azure CLI installation..." -ForegroundColor Cyan

if (Test-Path $AzExe) {
    Write-Host "✓ Azure CLI already installed at $AzExe" -ForegroundColor Green
} else {
    Write-Host "Azure CLI not found. Installing via pip..." -ForegroundColor Yellow
    pip install azure-cli
}

# Add bin folder to USER PATH if missing
$CurrentPath = [Environment]::GetEnvironmentVariable("Path", "User")

if ($CurrentPath -notlike "*$BinPath*") {
    Write-Host "Adding $BinPath to USER PATH..." -ForegroundColor Yellow
    [Environment]::SetEnvironmentVariable("Path", "$CurrentPath;$BinPath", "User")
} else {
    Write-Host "✓ $BinPath already in PATH" -ForegroundColor Green
}

Write-Host "Done. Try: az version" -ForegroundColor Cyan
