# --------------------------------------------------------------------------------
# Input
# --------------------------------------------------------------------------------
set puzzleNr    [file rootname [file tail [info script]]]
set input       [split [read [open $puzzleNr\_input.txt r]] \n]


# --------------------------------------------------------------------------------
# Question 1
# --------------------------------------------------------------------------------
puts $puzzleNr:a

set x           0
set y           0
set dirs        {"N" "E" "S" "W"}
set facingDir   [lsearch $dirs "E"]

foreach i $input {
    regexp {(\w)(\d+)} $i all action value
    if {$action == "F"} {
        set action [lindex $dirs $facingDir]
    }
    switch $action {
        "N" {set y [expr $y + $value]}
        "S" {set y [expr $y - $value]}
        "E" {set x [expr $x + $value]}
        "W" {set x [expr $x - $value]}
        "R" {set facingDir [expr ($facingDir + ($value/90)) % 4]}
        "L" {set facingDir [expr ($facingDir - ($value/90)) % 4]}
        default {puts "Parsing error: $i $action $value"}
    }
}

puts [expr abs($x) + abs($y)]


# --------------------------------------------------------------------------------
# Question 2
# --------------------------------------------------------------------------------
puts $puzzleNr:b




# --------------------------------------------------------------------------------
# Solution
# --------------------------------------------------------------------------------

# 2020.12:a
# 562


# --------------------------------------------------------------------------------
# Notes
# --------------------------------------------------------------------------------
