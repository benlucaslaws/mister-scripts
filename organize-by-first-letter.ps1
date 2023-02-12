param (
    [string]$path
)

function GetNewChildPath ($file) {
    $childPath = $file.Name.Substring(0, 1)
    if ($childPath -notmatch "[a-zA-Z]")
    {
        $childPath = "#"
    }

    return $childPath
}

$files = Get-ChildItem $path -Recurse -File
$count = $files.Count
$processedCount = 0

foreach ($file in $files)
{
    $childPath = GetNewChildPath($file)

    $outputPath = Join-Path -Path $path -ChildPath $childPath
    $global:ProgressPreference = 'SilentlyContinue'

    .\copy-to-new-folder.ps1 $file $outputPath

    $processedCount += 1
    $processedPercent = [Math]::Floor($processedCount / $count * 100)

    $global:ProgressPreference = 'Continue'
    Write-Progress -Activity "Copying $processedPercent%" -Status $file.Name -PercentComplete $processedPercent
}

.\remove-empty-folders.ps1 $path