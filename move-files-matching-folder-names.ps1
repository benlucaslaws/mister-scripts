param (
    [string]$filesPath,
    [string]$foldersPath,
    [string]$outputPath
)

$folders = Get-ChildItem $foldersPath -Directory
$count = $folders.Count
$processedCount = 0

foreach ($folder in $folders)
{
    $global:ProgressPreference = 'SilentlyContinue'
    $filter = $folder.Name + ".*"

    $files = Get-ChildItem $filesPath -Filter $filter -Recurse

    # Try looking for files with full region names
    if ($files.Length -eq 0)
    {
        $fullFolderName = $folder.Name -replace "\(J\)", "(Japan)"
        $filter = $fullFolderName + "*"
        $files = Get-ChildItem $filesPath -Filter $filter -Recurse
    }

    # Try looking for files with abbreviated region names
    if ($files.Length -eq 0)
    {
        $abbreviatedFolderName = $folder.Name -replace "\(Japan\)", "(J)"
        $filter = $abbreviatedFolderName + "*"
        $files = Get-ChildItem $filesPath -Filter $filter -Recurse
    }

    # If all else fails, ignore all tags and get all files with matching game names
    if ($files.Length -eq 0)
    {
        $taglessFolderName = $folder.Name -replace " \(.*", ""
        $filter = $taglessFolderName + "*"
        $files = Get-ChildItem $filesPath -Filter $filter -Recurse
    }

    foreach ($file in $files)
    {
        .\move-to-new-folder.ps1  $file $outputPath
    }

    $processedCount += 1
    $processedPercent = [Math]::Floor($processedCount / $count * 100)

    $global:ProgressPreference = 'Continue'
    Write-Progress -Activity "Extracting $processedPercent%" -Status $folder.Name -PercentComplete $processedPercent
}