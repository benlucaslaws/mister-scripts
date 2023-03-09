param (
    [string]$path
)

class Tag {
    [string]$Tag
    [string]$ChildPath

    Tag(
        [string]$tag,
        [string]$childPath
    )
    {
        $this.Tag = $tag
        $this.ChildPath = $childPath
    }
}

$tagPriority = @(
    [Tag]::new("World", "USA"),
    [Tag]::new("USA", "USA"),
    [Tag]::new("Europe", "Europe"),
    [Tag]::new("Japan", "Japan"),
    [Tag]::new("Australia", "Australia"),
    [Tag]::new("Canada", "Canada"),
    [Tag]::new("France", "France"),
    [Tag]::new("Italy", "Italy"),
    [Tag]::new("Germany", "Germany"),
    [Tag]::new("Spain", "Spain"),
    [Tag]::new("Sweden", "Sweden"),
    [Tag]::new("Netherlands", "Netherlands"),
    [Tag]::new("Denmark", "Denmark"),
    [Tag]::new("Korea", "Korea"),
    [Tag]::new("Taiwan", "Taiwan"),
    [Tag]::new("Hong Kong", "Hong Kong"),
    [Tag]::new("China", "China"),
    [Tag]::new("Asia", "Asia"),
    [Tag]::new("Brazil", "Brazil"),
    [Tag]::new("Russia", "Russia"),
    [Tag]::new("Unknown", "Unknown Region")
)

function GetNewChildPath ($tags) {
    $childPath = ""

    foreach ($regionTag in $tagPriority)
    {
        if ($tags.Contains($regionTag.Tag))
        {
            return $regionTag.ChildPath
        }
    }

    return ""
}

$files = Get-ChildItem $path -Recurse -File
$count = $files.Count
$processedCount = 0

foreach ($file in $files)
{
    $tags = .\get-tags.ps1 $file
    $childPath = GetNewChildPath($tags)

    $outputPath = Join-Path -Path $path -ChildPath $childPath
    $global:ProgressPreference = 'SilentlyContinue'

    .\move-to-new-folder.ps1 $file $outputPath

    $processedCount += 1
    $processedPercent = [Math]::Floor($processedCount / $count * 100)

    $global:ProgressPreference = 'Continue'
    Write-Progress -Activity "Copying $processedPercent%" -Status $file.Name -PercentComplete $processedPercent
}

.\remove-empty-folders.ps1 $path