#TODO - Return the test location if a star was found
#TODO - Recursively search the chain if a star is found using FULL check
#TODO - Cleanup nonsense


#Look for a STAR
function Test-Symbol {
    param(
        [string]$char
    )
    $symbolHunt = [regex]'\*'
    if($symbolHunt.IsMatch($char)){
        return $true
    }
}

#Is it a number?
function Test-Number {
    param(
        [string]$value
    )
    return $value -match '^\d+$'
}

#Get all the number groups
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
#Look above for something
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
#Look below for something
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
#Look left and right for something
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
            return 
        }
    }
}

function Full-Check{
    [cmdletbinding()]
    param(
        [int]$index,
        [int]$line,
        [array]$fullData
    )
    if(Check-Above -index $index -line $line -fulldata $fullData){
        if(Check-Below -index $index -line $line -fulldata $fullData){
            if(Check-LeftRight -index $index -line $line -fulldata $fullData){
                return $true
            } 
        }
    }
    else{
        return $false
    }
}

$fullData = Get-Content .\sample.txt
$workingGroups = New-Object System.collections.Generic.list[string]
For($line = 0; $line -lt $fullData.length; $line++){
    $numberGroups = Get-NumberGroup -line $fullData[$line]
    foreach($numberGroup in $numberGroups){
        $i = $numberGroup.Location
        foreach($char in $numberGroup.fullnumber.ToCharArray()){    
        $size = $workingGroups.count
            if(Full-Check  -index $i -line $line -fulldata $fullData){
                $workingGroups.Add($numberGroup.fullnumber)
            }
        $i++
        if($workingGroups.count -gt $size){
            break
        }
        }
    }
}