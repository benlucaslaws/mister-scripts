param (
    [string]$path,
    [string]$childPathFormat
)

$directories = Get-ChildItem $path -Directory

foreach ($directory in $directories)
{
    ./reorganize-folder.ps1 $directory.FullName -childPathFormat $childPathFormat
}