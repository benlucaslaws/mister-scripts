param (
    [string]$path
)

$categoryFolders = @(
    "1. Games - Licensed",
    "2. Games - Translation",
    "3. Games - ROM Hacks",
    "4. Games - Unlicensed",
    "5. Games - Prototype",
    "6. Games - Beta",
    "7. Games - Demo"
)

foreach ($categoryFolder in $categoryFolders)
{
    $categoryFolderPath = Join-Path -Path $path -ChildPath $categoryFolder
    .\create-folder.ps1 $categoryFolderPath
}
