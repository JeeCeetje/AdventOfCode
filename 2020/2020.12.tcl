# --------------------------------------------------------------------------------
# Input
# --------------------------------------------------------------------------------
set puzzleNr    [file rootname [file tail [info script]]]
set input       [split [read [open $puzzleNr\_input.txt r]] \n]


# --------------------------------------------------------------------------------
# Question 1
# --------------------------------------------------------------------------------
puts $puzzleNr:a

set x           0                                           ;# Starting location of the ship
set y           0
set dirs        {"N" "E" "S" "W"}
set facingDir   [lsearch $dirs "E"]                         ;# Starting facing direction of the ship, keep the direction as a number rather than letter (easier to manipulate)

foreach i $input {
    regexp {(\w)(\d+)} $i all action value
    if {$action == "F"} {
        set action [lindex $dirs $facingDir]                ;# Translate the facing direction to the action
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

set x           0                                           ;# Starting location of the ship
set y           0
set Wx          10                                          ;# Starting location of the waypoint
set Wy          1
set rotate      0

foreach i $input {
    regexp {(\w)(\d+)} $i all action value                  ;# Actions:
                                                            ;#  "NESW" : change the waypoint location
                                                            ;#  "RL"   : rotate the waypoint (L rotation is translated in R rotation)
                                                            ;#  "F"    : change the ship location
    switch $action {
        "N" {set Wy [expr $Wy + $value]}
        "S" {set Wy [expr $Wy - $value]}
        "E" {set Wx [expr $Wx + $value]}
        "W" {set Wx [expr $Wx - $value]}
        "R" {set rotate [expr    $value/90 ]}
        "L" {set rotate [expr 4-($value/90)]}
        "F" {
            set x [expr $x + $value*$Wx]
            set y [expr $y + $value*$Wy]
        }
        default {puts "Parsing error: $i $action $value"}
    }
    switch $rotate {
        1 {
            set tmp $Wx
            set Wx $Wy
            set Wy [expr -1*$tmp]
        }
        2 {
            set Wx [expr -1*$Wx]
            set Wy [expr -1*$Wy]
        }
        3 {
            set tmp $Wx
            set Wx [expr -1*$Wy]
            set Wy $tmp
        }
        default {}
    }
    set rotate 0
}

puts [expr abs($x) + abs($y)] 


# --------------------------------------------------------------------------------
# Solution
# --------------------------------------------------------------------------------

# 2020.12:a
# 562
# 2020.12:b
# 101860


# --------------------------------------------------------------------------------
# Notes
# --------------------------------------------------------------------------------
