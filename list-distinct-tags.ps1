param (
    [string]$path
)

$files = Get-ChildItem $path -Recurse
$count = $files.Count
$processedCount = 0

$tags = @{}

foreach ($file in $files)
{
    $fileTags = .\get-tags.ps1 $file
    foreach ($tag in $fileTags)
    {
        $tags[$tag] = 0
    }

    $processedCount += 1
    $processedPercent = [Math]::Floor($processedCount / $count * 100)

    $global:ProgressPreference = 'Continue'
    Write-Progress -Activity "Processing $processedPercent%" -Status $file.Name -PercentComplete $processedPercent
}

foreach ($tag in $tags.GetEnumerator())
{
  Write-Host $($tag.Name)
}