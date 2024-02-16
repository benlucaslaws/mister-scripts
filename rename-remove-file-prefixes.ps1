param (
    [string]$path,
    [string]$prefixFormat = "^[zx\d]\d{3} - "
)

$files = Get-ChildItem -LiteralPath $path -Recurse -File
$count = $files.Count
$processedCount = 0

foreach ($file in $files)
{
    $newName = $file.Name -replace $prefixFormat, ""
    
    Rename-Item -LiteralPath $file.FullName -NewName $newName

    $processedCount += 1
    $processedPercent = [Math]::Floor($processedCount / $count * 100)

    $global:ProgressPreference = 'Continue'
    Write-Progress -Activity "Renaming files in $($path): $processedCount/$count ($processedPercent%)" -Status $file.Name -PercentComplete $processedPercent
}