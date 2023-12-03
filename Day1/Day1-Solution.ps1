#Star 1 Solution
function Get-FirstAndLastDigit {
    [cmdletbinding()]
    param(
        [string]$str
    )
    #Use regex object to gake advantage of global flag
    $matches = [regex]::Matches($str, '\d')
    #combine the first and last digit, in the event of there only being one number -1 still returns the last one.
    return $matches[0].Value.tostring() + $matches[-1].Value.tostring() 
}

#Get the data into the result - slam it home.
$result = Get-Content .\input.txt | foreach-Object {Get-FirstAndLastDigit -str $_}
($result | Measure-Object -Sum).Sum


#Star 2 solution
Function Update-DataSet{
    [cmdletbinding()]
    param(
        [object]$dataset
    )    
    $dataset = $dataset.replace('one',1)
    $dataset = $dataset.replace('two',2)
    $dataset = $dataset.replace('three',3)
    $dataset = $dataset.replace('four',4)
    $dataset = $dataset.replace('five',5)
    $dataset = $dataset.replace('six',6)
    $dataset = $dataset.replace('seven',7)
    $dataset = $dataset.replace('eight',8)
    $dataset = $dataset.replace('nine',9)
    return $dataset
}

$content = Get-Content .\input.txt 

$content = @(
'two1nine'
'eightwothree'
'abcone2threexyz'
'xtwone3four'
'4nineeightseven2'
'zoneight234'
'7pqrstsixteen'
)


$content | foreach-Object {Convert-NumericWordToNumber -word $_}

$updatedContent = Update-DataSet -dataset $content
$answer = $updatedContent | foreach-Object {Get-FirstAndLastDigit -str $_}
$sum = ($answer | Measure-Object -Sum).Sum
$sum