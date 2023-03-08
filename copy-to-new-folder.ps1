param (
    [object]$file,
    [string]$outputPath
)

try {

    $fullName = $file.FullName -replace "\[", "``[" `
        -replace "\]", "``]"

    if (-not(Test-Path $outputPath))
    {
        New-Item $outputPath -ItemType Directory -Force | Out-Null
    }

    $destination = Join-Path -Path $outputPath -ChildPath $file.Name

    if ($destination -ne $file.FullName)
    {
        Move-Item -Path $fullName -Destination $outputPath -Force
    }
}
catch
{
    Write-Output "Failed to copy $fullName"
}