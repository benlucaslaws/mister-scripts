param (
    [string]$path
)

function GetNewChildPath ($file) {
    $childPath = $file.BaseName -replace " \(Disc \d\)", ""
    return $childPath
}

function IsDisc($file) {
    return $file.Extension.ToLower() -eq ".chd" -or $file.Extension -eq ".bin" -or $file.Extension -eq ".cue" -or $file.Extension -eq ".iso"
}

$files = Get-ChildItem $path -Recurse -File
$count = $files.Count
$processedCount = 0

foreach ($file in $files)
{
    if (IsDisc($file))
    {
        $childPath = GetNewChildPath($file)

        $outputPath = Join-Path -Path $file.Directory.FullName -ChildPath $childPath
        $global:ProgressPreference = 'SilentlyContinue'

        .\copy-to-new-folder.ps1 $file $outputPath
    }

    $processedCount += 1
    $processedPercent = [Math]::Floor($processedCount / $count * 100)

    $global:ProgressPreference = 'Continue'
    Write-Progress -Activity "Copying $processedPercent%" -Status $file.Name -PercentComplete $processedPercent
}