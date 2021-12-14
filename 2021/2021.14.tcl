# --------------------------------------------------------------------------------
# Input
# --------------------------------------------------------------------------------
set puzzleNr    [file rootname [file tail [info script]]]
set input       [split [read [open $puzzleNr\_input.txt r]] \n]
# set input       [split [read [open $puzzleNr\_example.txt r]] \n]
set len         [llength $input]



# --------------------------------------------------------------------------------
# Question A
# --------------------------------------------------------------------------------
puts $puzzleNr:a

set polymerTemplate [lindex $input 0]
set rules {}
foreach i $input {
    if {[regexp {(\w)(\w) -> (\w)} $i all e1 e2 e3]} {
        lappend rules "$e1$e2"
        lappend rules "$e1$e3$e2"
    }
}


proc getRule {pair} {
    foreach {x y} $::rules {
        if {$pair == $x} {return $y}
    }
    return $pair
}

proc analyzeTemplate {template {nrOfSteps 1}} {
    for {set s 0} {$s < $nrOfSteps} {incr s} {
        puts $s
        set newTemplate [string range $template 0 0]
        for {set i 0; set j 1} {$j < [string length $template]} {incr i; incr j} {
            append newTemplate [string range [getRule [string range $template $i $j]] end-1 end]
        }
        set template $newTemplate
    }
    return $template
}

proc quantifyTemplate {template} {
    set elements [lsort -unique [split $template ""]]
    set max 0
    set min 1000000000000
    foreach e $elements {
        set cnt [regexp -all $e $template]
        if {$cnt < $min} { set min $cnt }
        if {$cnt > $max} { set max $cnt }
    }
    return [expr $max - $min]
}


puts [quantifyTemplate [analyzeTemplate $polymerTemplate 10]]



# --------------------------------------------------------------------------------
# Question B
# --------------------------------------------------------------------------------
puts $puzzleNr:b

# puts [time {puts [quantifyTemplate [analyzeTemplate $polymerTemplate 40]]}] ;# Optimize, takes ages



# --------------------------------------------------------------------------------
# Solution
# --------------------------------------------------------------------------------

# 2021.14:a
# 2408



# --------------------------------------------------------------------------------
# Notes
# --------------------------------------------------------------------------------


