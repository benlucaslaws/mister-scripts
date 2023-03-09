param (
    [string]$path
)

$7zipPath = "C:\Program Files\7-Zip\7z.exe"
Set-Alias Start-SevenZip $7zipPath

$archives = @()
$archives += Get-ChildItem $path -Filter *.zip -Recurse
$archives += Get-ChildItem $path -Filter *.rar -Recurse
$archives += Get-ChildItem $path -Filter *.7z -Recurse


$count = $archives.Count
$processedCount = 0

foreach ($archive in $archives)
{
    $fullName = $archive.FullName

    $outputPath = $archive.Directory.FullName + "\" + $archive.Basename

    if (-not(Test-Path $outputPath))
    {
        New-Item $outputPath -ItemType Directory -Force | Out-Null
    }

    $global:ProgressPreference = 'SilentlyContinue'
    
    try {
        Start-SevenZip x -o"$outputPath" "$fullName" -r ;
        Remove-Item -Path $fullName
    }
    catch
    {
        Write-Output "Failed to process $fullName"
    }

    $processedCount += 1
    $processedPercent = [Math]::Floor($processedCount / $count * 100)

    $global:ProgressPreference = 'Continue'
    Write-Progress -Activity "Extracting $processedPercent%" -Status $archive.Name -PercentComplete $processedPercent
}