param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Url
)

# Create a temporary file for the downloaded script
$TempScript = [System.IO.Path]::GetTempFileName() + ".ps1"

try {
    Write-Host "Downloading script from $Url ..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri $Url -OutFile $TempScript -UseBasicParsing

    Write-Host "Executing downloaded script..." -ForegroundColor Cyan
    powershell -ExecutionPolicy Bypass -File $TempScript
}
finally {
    # Always clean up — even on errors
    if (Test-Path $TempScript) {
        Remove-Item $TempScript -Force
        Write-Host "Temporary script deleted." -ForegroundColor DarkGreen
    }
}
