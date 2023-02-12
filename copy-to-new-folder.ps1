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
        Copy-Item -Path $fullName -Destination $outputPath -Force
        Remove-Item -Path $fullName
    }
}
catch
{
    Write-Output "Failed to copy $fullName"
}