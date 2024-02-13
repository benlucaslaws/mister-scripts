param (
    [string]$path,
    [string]$childPathFormat
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
    [Tag]::new("United Kingdom", "United Kingdom"),
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
    [Tag]::new("Finland", "Finland"),
    [Tag]::new("Hungary", "Hungary"),
    [Tag]::new("Scandinavia", "Scandinavia"),
    [Tag]::new("Latin America", "Latin America"),
    [Tag]::new("Argentina", "Argentina"),
    [Tag]::new("New Zealand", "New Zealand"),
    [Tag]::new("Russia", "Russia"),
    [Tag]::new("Unknown", "Unknown")
)

$discExtensions = @(
    ".chd",
    ".bin",
    ".cue",
    ".iso"
)

function PerformSafetyCheck($path)
{
    $suspectFolders = Get-ChildItem -path $path -Filter "Nintendo - *" -Directory

    if ($suspectFolders.Length -gt 0)
    {
        throw "You're probably running this in your root ROM folder by accident."
    }
}

function GetTags($file)
{
    $pattern = "(?<=\()[^\)]+(?=\))"
    $tags = @()
    $tagMatches = (Select-String -InputObject $file.Name -Pattern $pattern -AllMatches).Matches

    foreach ($tagMatch in $tagMatches)
    {
        $tags += $tagMatch.Value.Replace(", ", ",").Split(",")
    }

    return $tags
}

function GetRegionPath($file)
{
    $tags = GetTags $file
    $childPath = ""

    foreach ($regionTag in $tagPriority)
    {
        if ($tags.Length -gt 0)
        {
            if ($tags.Contains($regionTag.Tag))
            {
                return $regionTag.ChildPath
            }
        }
    }

    Write-Warning "Failed to identify region from tags: $($file.FullName)"

    return "Unknown Region"
}

function GetFirstLetterPath($file)
{
    $childPath = $file.Name.Substring(0, 1)

    if ($childPath -notmatch "[a-zA-Z]")
    {
        $childPath = "#"
    }
    else
    {
        $childPath = $childPath.ToUpper()
    }

    return $childPath
}

function IsDisc($file)
{
    return $discExtensions.Contains($file.Extension.ToLower())
}

function GetDiscPath($file)
{
    $childPath = ""

    if (IsDisc $file)
    {
        $childPath = $file.BaseName -replace " \(Disc \d\)", ""
    }

    return $childPath
}

function FormatChildPath($file, $format)
{
    $regionPath = GetRegionPath $file
    $firstLetterPath = GetFirstLetterPath $file
    $discPath = GetDiscPath $file

    $childPath = $format -replace "##REGION##", $regionPath `
        -replace "##LETTER##", $firstLetterPath `
        -replace "##DISC##", $discPath

    return $childPath
}

function TryRemoveEmptyFolders($path)
{
    $removedFolders = $false
    $folders = Get-ChildItem $path -Directory -Recurse

    foreach ($folder in $folders)
    {
        if ((Get-ChildItem $folder.FullName | Measure-Object).Count -eq 0)
        {
            Remove-Item -LiteralPath $folder.FullName | Out-Null
            $removedFolders = $true
        }
    }

    return $removedFolders
}

function RemoveEmptyFolders($path) 
{
    $removedFolders = $false

    do
    {
        $removedFolders = TryRemoveEmptyFolders $path
    }
    while ($removedFolders -ne $false)
}

function SafeCreateFolder($path)
{
    if (-not(Test-Path -LiteralPath $path))
    {
        New-Item $path -ItemType Directory -Force | Out-Null
    }
}

function MoveToNewFolder($path, $outputPath)
{
    try {
        SafeCreateFolder $outputPath

        $destination = Join-Path -Path $outputPath -ChildPath $file.Name

        if ($destination -ne $file.FullName)
        {
            Move-Item -LiteralPath $file.FullName -Destination $outputPath -Force
        }
    }
    catch
    {
        Write-Output "Failed to copy $fullName"
    }
}

PerformSafetyCheck $path

$files = Get-ChildItem -LiteralPath $path -Recurse -File
$count = $files.Count
$processedCount = 0

foreach ($file in $files)
{
    $childPath = FormatChildPath $file $childPathFormat

    $outputPath = Join-Path -Path $path -ChildPath $childPath
    $global:ProgressPreference = 'SilentlyContinue'

    MoveToNewFolder $file $outputPath

    $processedCount += 1
    $processedPercent = [Math]::Floor($processedCount / $count * 100)

    $global:ProgressPreference = 'Continue'
    Write-Progress -Activity "Reorganizing files in $($path): $processedCount/$count ($processedPercent%)" -Status "$outputPath\$($file.Name)" -PercentComplete $processedPercent
}

RemoveEmptyFolders $path