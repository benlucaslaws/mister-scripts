param (
    [string]$path
)

$zips = Get-ChildItem $path -Filter *.zip -Recurse
$count = $zips.Count
$processedCount = 0

foreach ($zip in $zips)
{
    $childPath = $zip.Name.Substring(0, 1)
    if ($childPath -notmatch "[a-zA-Z]")
    {
        $childPath = "#"
    }

    $fullName = $zip.FullName -replace "\[", "``[" `
        -replace "\]", "``]"

    $outputPath = Join-Path -Path $zip.Directory -ChildPath $childPath
    $global:ProgressPreference = 'SilentlyContinue'
    
    try {
        Expand-Archive -Path $fullName -DestinationPath $outputPath -Force
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