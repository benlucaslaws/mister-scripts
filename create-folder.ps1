param (
    [string]$path
)

if (-not(Test-Path $path))
{
    New-Item $path -ItemType Directory -Force | Out-Null
}