function Search-NumberGroups{
    [cmdletbinding()]
    param(
        [string]$sample
    )
        $doomCircle = @(
        -11
        -10
        -9
        -1
        1
        9
        10
        11
    )
    $numberHunter = New-Object -typename System.Collections.Generic.list[psobject]
    $regex = [regex]'\d+'
    $symbolHunt = [regex]'[^a-zA-Z0-9.\s]'
    $matches = $regex.Matches($sample)
        foreach($match in $matches){
            $location = $match.index
            $touched = $false
            foreach($item in $match.value.ToCharArray()){
                foreach($circle in $doomCircle){
                    if(($location + $circle -lt 0) -or ($location + $circle -gt $sample.Length)){
                        #Write-verbose "Out of bounds" -verbose
                    }
                    else{
                        $testResult = $sample[$($location + $circle)]
                        $checkSymbol = $symbolHunt.Matches($testResult)
                        if($checkSymbol){
                            Write-verbose -message "The Symbol: $($checkSymbol.groups.value) was touching the character: $($item) from group: $($match.value)"
                            $numberHunter.add($match.value)
                            $touched = $true
                        }
                    }
            }
            if($touched){
                break
            }
            $location++
        }
    }
    return $numberHunter
}

$sample = (Get-Content .\input.txt -Raw).Replace("`r`n",'')
(Search-NumberGroups -sample $sample | measure-object -sum).sum
