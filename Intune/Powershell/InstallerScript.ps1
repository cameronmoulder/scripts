# Define paths
$msiPath = <PATH>
$configFileSource = <PATH>
$configFileDestination = <PATH> # Adjust as needed

# Install the MSI
Start-Process msiexec.exe -ArgumentList "/i `"$msiPath`" /quiet /norestart" -Wait

# Check if the MSI installed successfully by verifying an important file or folder (adjust as needed)
if (Test-Path "<PATH>") {  # Change this to a reliable path installed by the MSI
    # Check if the config file already exists at the destination
    if (Test-Path $configFileDestination) {
        # Remove the existing (possibly blank) config file
        Remove-Item -Path $configFileDestination -Force
        Write-Host "Removed existing config file: $configFileDestination"
    }
    
    # Copy the new config file from the package to the destination
    Copy-Item -Path $configFileSource -Destination $configFileDestination -Force
    Write-Host "Copied new config file to $configFileDestination"
} else {
    Write-Host "MSI installation failed or target path not found!"
    Exit 1
}
