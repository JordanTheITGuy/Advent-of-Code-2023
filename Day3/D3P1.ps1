function Test-Symbol {
    param(
        [string]$char
    )
    $symbolHunt = [regex]'[^a-zA-Z0-9.\s]'
    if($symbolHunt.IsMatch($char)){
        return $true
    }
}

function Get-NumberGroup{
    param(
        [string]$line
    )
    $regex = [regex]'\d+'
    $matches = $regex.Matches($line)
    return $matches | ForEach-Object {
        [PSCustomObject]@{
            FullNumber = $_.value;
            Location = $_.Index
        }
    }
}

function Check-Above{
    [cmdletbinding()]
    param(
        [int]$index,
        [int]$line,
        [array]$fullData
    )
    $testLocations = @(($index - 1), $index, ($index + 1))
    if(($line-1) -ge 0){
        $testLine = $fullData[$line - 1]
        foreach($testLocation in $testLocations){
            if(Test-Symbol -char $testLine[$testLocation]){
                Write-verbose -message "Found a touching symbol no need for tests"
                return $true
            }

        }
    }    
    else{
        Write-verbose "Above is out of bounds"
    }
}

function Check-Below{
    [cmdletbinding()]
    param(
        [int]$index,
        [int]$line,
        [array]$fullData
    )
    if(($line+1) -lt $fullData.Length){
        $testLocations = @(($index - 1), $index, ($index + 1))
        $testLine = $fullData[$line + 1]
        foreach($testLocation in $testLocations){
            if(Test-Symbol -char $testLine[$testLocation]){
                Write-verbose -message "Found a touching symbol no need for tests"
                return $true
            }

        }
    }    
    else{
        Write-verbose "Below is out of bounds"
    }
}

function Check-LeftRight{
    [cmdletbinding()]
    param(
        [int]$index,
        [int]$line,
        [array]$fullData
    )
    $testLocations = @(($index - 1), ($index + 1))
    foreach($testLocation in $testLocations){
        if(Test-Symbol -char $fullData[$line][$testLocation]){
            Write-verbose -message "Found a touching symbol no need for tests"
            return $true
        }
    }
}

#part 1
$fullData = Get-Content .\input.txt 
$workingGroups = New-Object System.collections.Generic.list[string]
For($line = 0; $line -lt $fullData.length; $line++){
    $numberGroups = Get-NumberGroup -line $fullData[$line]
    foreach($numberGroup in $numberGroups){
        $i = $numberGroup.Location
        foreach($char in $numberGroup.fullnumber.ToCharArray()){    
        $size = $workingGroups.count
            if(Check-Above -index $i -line $line -fulldata $fullData){
                $workingGroups.Add($numberGroup.fullnumber)
            }
            elseif (Check-Below -index $i -line $line -fulldata $fullData) {
                $workingGroups.Add($numberGroup.fullnumber)
            }
            elseif(Check-LeftRight -index $i -line $line -fulldata $fullData){
                $workingGroups.Add($numberGroup.fullnumber)
            } 
        $i++
        if($workingGroups.count -gt $size){
            break
        }
        }
    }
}
$workingGroups | measure-object -sum | select -expandproperty sum
