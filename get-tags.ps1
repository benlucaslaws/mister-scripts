param (
    [object]$file
)

$pattern = "(?<=\()[^\)]+(?=\))"
$tags = @()
$tagMatches = (Select-String -InputObject $file.Name -Pattern $pattern -AllMatches).Matches

foreach ($tagMatch in $tagMatches)
{
    $tags += $tagMatch.Value.Replace(", ", ",").Split(",")
}

return $tags
