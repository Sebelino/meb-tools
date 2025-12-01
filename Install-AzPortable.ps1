# Version to install
$AzVersion = "2.66.0"
$ZipUrl = "https://azurecliprod.blob.core.windows.net/msi/azure-cli-$AzVersion.zip"

# Paths
$BaseDir = "$env:USERPROFILE\AzureCLI"
$ZipPath = "$BaseDir\azure-cli.zip"
$BinPath = "$BaseDir\bin"

Write-Host "Installing Azure CLI portable into: $BaseDir" -ForegroundColor Cyan

# Create base folder if missing
if (-not (Test-Path $BaseDir)) {
    New-Item -ItemType Directory -Path $BaseDir | Out-Null
}

# Download ZIP if not present or if forced refresh
if (-not (Test-Path $ZipPath)) {
    Write-Host "Downloading Azure CLI portable..." -ForegroundColor Yellow
    Invoke-WebRequest -Uri $ZipUrl -OutFile $ZipPath
} else {
    Write-Host "Portable AZ ZIP already exists → skipping download." -ForegroundColor DarkYellow
}

# Extract ZIP (always overwrite, stable across sessions)
Write-Host "Extracting ZIP..." -ForegroundColor Yellow
Expand-Archive -LiteralPath $ZipPath -DestinationPath $BaseDir -Force

# Ensure bin directory exists
if (-not (Test-Path $BinPath)) {
    throw "ERROR: Expected 'bin' directory not found after extraction."
}

# Add bin folder to user PATH (idempotent)
$CurrentPath = [Environment]::GetEnvironmentVariable("Path", "User")

if ($CurrentPath -notlike "*$BinPath*") {
    Write-Host "Adding AzureCLI\bin to USER PATH..." -ForegroundColor Yellow
    $NewPath = "$CurrentPath;$BinPath"
    [Environment]::SetEnvironmentVariable("Path", $NewPath, "User")
} else {
    Write-Host "AzureCLI\bin already in PATH → skipping." -ForegroundColor DarkYellow
}

Write-Host "`n✓ Portable Azure CLI installed."
Write-Host "✓ PATH updated (restart PowerShell if needed)."
Write-Host "`nTest with: az version" -ForegroundColor Green
