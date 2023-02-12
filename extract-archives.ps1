param (
    [string]$path
)

$zips = Get-ChildItem $path -Filter *.zip -Recurse
$count = $zips.Count
$processedCount = 0

foreach ($zip in $zips)
{
    $fullName = $zip.FullName -replace "\[", "``[" `
        -replace "\]", "``]"

    $global:ProgressPreference = 'SilentlyContinue'
    
    try {
        Expand-Archive -Path $fullName -DestinationPath $zip.Directory -Force
        Remove-Item -Path $fullName
    }
    catch
    {
        Write-Output "Failed to process $fullName"
    }

    $processedCount += 1
    $processedPercent = [Math]::Floor($processedCount / $count * 100)

    $global:ProgressPreference = 'Continue'
    Write-Progress -Activity "Extracting $processedPercent%" -Status $zip.Name -PercentComplete $processedPercent
}