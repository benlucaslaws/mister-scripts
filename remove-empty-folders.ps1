param (
    [string]$path
)

$folders = Get-ChildItem $path -Directory -Recurse

foreach ($folder in $folders)
{
    if ((Get-ChildItem $folder.FullName | Measure-Object).Count -eq 0)
    {
        Remove-Item $folder.FullName | Out-Null
    }
}