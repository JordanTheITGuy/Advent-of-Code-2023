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
    #What if I did something stupid.
    $dataset = $dataset.replace('one',"o1e")
    $dataset = $dataset.replace('two',"t2o")
    $dataset = $dataset.replace('three',"t3e")
    $dataset = $dataset.replace('four',"f4r")
    $dataset = $dataset.replace('five',"f5e")
    $dataset = $dataset.replace('six',"s6x")
    $dataset = $dataset.replace('seven',"s7n")
    $dataset = $dataset.replace('eight',"e8t")
    $dataset = $dataset.replace('nine',"n9e")
    return $dataset
}

$content = Get-Content .\input.txt
$updatedContent = Update-DataSet -dataset $content
$answer = $updatedContent | foreach-Object {Get-FirstAndLastDigit -str $_}
$sum = ($answer | Measure-Object -Sum).Sum
$sum