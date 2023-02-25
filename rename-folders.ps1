param (
    [string]$path,
    [string]$folderName,
    [string]$newFolderName
)

$folders = Get-ChildItem $path -Filter $folderName -Directory -Recurse
$count = $folders.Count
$processedCount = 0

foreach ($folder in $folders)
{
    Rename-Item -Path $folder.FullName -NewName $newFolderName

    $processedCount += 1
    $processedPercent = [Math]::Floor($processedCount / $count * 100)

    $global:ProgressPreference = 'Continue'
    Write-Progress -Activity "Renaming $processedPercent%" -Status $folder.Name -PercentComplete $processedPercent
}