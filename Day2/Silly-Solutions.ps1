
$rules = @(
    @{color = 'red'; max = 12},
    @{color = 'green'; max = 13},
    @{color = 'blue'; max = 14}
)



$gameList = Get-Content .\input.txt
$brokenGames = New-Object -typename System.Collections.generic.List[PSobject]
Foreach($game in $gameList){
    $gameInfo = $game.split(':')[0]
    $gameID = $gameInfo.split(' ')[1]
    $ruleBroken = $false
    foreach($rule in $rules){
        $regex = [regex]"\b(\d+)\s* $($rule.color)"
        $matches = $regex.Matches($game)
        foreach($match in $matches){
            $number = $match.Groups[1].Value
            if([int]$number -gt $rule.max){
                Write-Host "Rule violated: $number is greater than $($rule.max) for $($rule.color)"
                $ruleBroken = $true
            }
        }
    
    }
    if(!($ruleBroken)){
        $brokenGames.Add($gameID)
    }
}

($brokenGames | Measure-Object -Sum).sum


# Section 2

$gameList = Get-Content .\input.txt
#$gameList = Get-Content .\sample.txt
$total = 0
Foreach($game in $gameList){
    $gameInfo = $game.split(':')[0]
    $gameID = $gameInfo.split(' ')[1]
    $gameResults = New-Object -typename System.Collections.generic.List[PSobject]
    $colors = @('red', 'green', 'blue')
    foreach($color in $colors){
        $regex = [regex]"\b(\d+)\s* $($color)"
        $matches = $regex.Matches($game)
        $value = @{
            gameID = $gameID;
            color = $color;
            value = $($matches | ForEach-Object{[int]$_.Groups[1].Value} | Sort-Object -Descending)[0]
        }
        $minRecord = New-Object -TypeName PSObject -Property $value
        $gameResults.Add($minRecord)
    }
    [int]$powerLevel = 1
    $gameResults | foreach-Object{$powerLevel *= $_.value}
    Write-Host "Game ID: $gameID Power Level: $powerLevel"
    $total = $total + $powerLevel
}
$total