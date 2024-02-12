param (
    [string]$path,
    [switch]$flattenFirst = $false,
    [switch]$moveDiscGamesToFolders = $false,
    [switch]$removeEmptyFolders = $false
)

if ($flattenFirst)
{
    .\organize-flatten.ps1 $path
}

.\organize-by-region.ps1 $path
.\organize-by-first-letter.ps1 $path

if ($moveDiscGamesToFolders)
{
    .\move-disc-games-to-folders.ps1 $path
}

if ($removeEmptyFolders)
{
    .\remove-empty-folders.ps1
}
