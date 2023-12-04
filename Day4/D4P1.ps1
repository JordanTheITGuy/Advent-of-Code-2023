$content = Get-Content -Path 'input.txt'
#Drop the Game info to avoid number contamincation
$totalPoints = 0
Foreach($line in $content){
    $dropped = $line -split '\:' 
    #Split on the pipe to create the two logical groups
    $parts = $dropped[1] -split '\|'

    #Build pattern to find number groups with a space on either side
    $pattern = '\b\d+\b'

    # Find matches in each part
    $group1 = [regex]::Matches($parts[0], $pattern) | ForEach-Object { $_.Value }
    $group2 = [regex]::Matches($parts[1], $pattern) | ForEach-Object { $_.Value }

    # Output the groups
    $commonCount = ($group2 | Where-Object { $group1 -contains $_ }).Count
    # Calculate the points
    $points = [math]::Floor([math]::Pow(2, $commonCount -1))
    # Add the points to the total
    $totalPoints = $totalPoints + $points
}



