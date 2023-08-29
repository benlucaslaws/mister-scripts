param (
    [object]$file,
    [string]$outputPath
)

try {

    $fullName = $file.FullName -replace "\[", "``[" `
        -replace "\]", "``]"

    .\create-folder.ps1 $outputPath

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