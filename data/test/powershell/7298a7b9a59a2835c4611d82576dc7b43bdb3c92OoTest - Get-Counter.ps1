function Get-Exports($exported)
{
    $rv = new-object PSObject
    
    foreach($fnName in $exported) {
        $fn = gi "variable:$fnName"
        add-member -in $rv NoteProperty -name $fnName -value $fn.Value.GetNewClosure()
    }
    
    return $rv
}

function Get-Counter() {
    $this = new-object PSObject
    add-member -in $this NoteProperty "State" 0

    $Private = {
        $this.State += 10
    }.GetNewClosure()
    
    $Up = {
        & $Private
    }.GetNewClosure()
    
    $Show = {
        $this.State = $this.State + 1
        return $this.State
    }.GetNewClosure()
    
    return . Get-Exports @("Up", "Show")
}

function Run-TestsFor-Get-Counter() {
    $c = Get-Counter
    & $c.Show
    & $c.Show
    & $c.Show
    & $c.Up
    & $c.Show
    & $c.Show
    & $c.Show
}