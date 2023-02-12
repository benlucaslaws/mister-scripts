param (
    [string]$path
)

$files = Get-ChildItem $path -Recurse -File
$count = $files.Count
$processedCount = 0

foreach ($file in $files)
{
    $fullName = $file.FullName -replace "\[", "``[" `
        -replace "\]", "``]"

    $global:ProgressPreference = 'SilentlyContinue'

    .\copy-to-new-folder.ps1 $file $path

    $processedCount += 1
    $processedPercent = [Math]::Floor($processedCount / $count * 100)

    $global:ProgressPreference = 'Continue'
    Write-Progress -Activity "Copying $processedPercent%" -Status $file.Name -PercentComplete $processedPercent
}

.\remove-empty-folders.ps1 $path