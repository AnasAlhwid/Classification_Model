$ErrorActionPreference = 'Stop'

# Define variables
$moduleName = 'Classification_Model'

$zipUrl = 'https://github.com/AnasAlhwid/Classification_Model/archive/refs/heads/main.zip'

$modulePath = Join-Path -Path $env:USERPROFILE -ChildPath "Documents\PowerShell\Modules"

# Check if the Modules directory exists
if (-not (Test-Path -Path $modulePath)) {

    # Create the PowerShell\Modules directory
    New-Item -Path $modulePath -ItemType Directory -Force
    Write-Host "Created directory: $modulePath"
}

$tempZipPath = Join-Path -Path $env:TEMP -ChildPath "$moduleName.zip"
$extractPath = Join-Path -Path $env:TEMP -ChildPath "$moduleName-extracted"

try {
    # Download the repository as a ZIP file
    Invoke-WebRequest -Uri $zipUrl -OutFile $tempZipPath

    # Extract the ZIP file (Just in case for older PowerShell versions)
    Add-Type -AssemblyName 'System.IO.Compression.FileSystem'
    [System.IO.Compression.ZipFile]::ExtractToDirectory($tempZipPath, $extractPath)

    Write-Host "$moduleName module EXTRACTED!!."

    # Move the extracted folder to the PowerShell modules path
    Move-Item -Path (Join-Path -Path $extractPath -ChildPath "$moduleName-main") -Destination $modulePath

    # Clean up temporary files
    Remove-Item $tempZipPath
    Remove-Item $extractPath -Recurse

    Write-Host "$moduleName module installed successfully from ZIP."
}
catch {
    Write-Host "Failed to download or extract the ZIP file from GitHub. Exiting..."
}

# Define the target installation path for the qatam module
$installPath = Join-Path -Path $modulePath -ChildPath "$moduleName-main\test"

Write-Host $installPath

# Import the module
Import-Module $installPath -Force

# Confirm installation
if (Get-Module -Name $moduleName -ListAvailable) {
    Write-Host "$moduleName is ready to use. Run '$moduleName help' to see available commands."
}
else {
    Write-Host "Failed to import the $moduleName module." -ForegroundColor Red
}

# Invoke-WebRequest -Uri "https://github.com/AnasAlhwid/Classification_Model/archive/refs/heads/main.zip" -OutFile "$env:TEMP\test.zip"
