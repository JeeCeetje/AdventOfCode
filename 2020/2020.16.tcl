# --------------------------------------------------------------------------------
# Input
# --------------------------------------------------------------------------------
set puzzleNr    [file rootname [file tail [info script]]]
set input       [split [read [open $puzzleNr\_input.txt r]] \n]
# set input       [split [read [open $puzzleNr\_example.txt r]] \n]


# --------------------------------------------------------------------------------
# Question 1
# --------------------------------------------------------------------------------
puts $puzzleNr:a

set rulesRegex  {([\w\s]+):\s(\d+)-(\d+)\sor\s(\d+)-(\d+)}
set ticketRegex {([\d,]+)}


set nrOfRules           0
set myTicket            ""
set nrOfNearbyTickets   0
set nearbyTickets       ""

foreach i $input {
    if {[regexp $rulesRegex $i all field a1 a2 b1 b2]} {
        set rules($nrOfRules,field) $field
        set rules($nrOfRules,a1)    $a1
        set rules($nrOfRules,a2)    $a2
        set rules($nrOfRules,b1)    $b1
        set rules($nrOfRules,b2)    $b2
        incr nrOfRules
    } elseif {[regexp $ticketRegex $i all values]} {
        if {$myTicket == ""} {
            set myTicket [split $values ","]
        } else {
            lappend nearbyTickets           [split $values ","]
            incr nrOfNearbyTickets
        }
    }
}


set sumInvalidFields     0

foreach ticket $nearbyTickets {
    foreach field $ticket {
        set validField false
        for {set r 0} {$r < $nrOfRules} {incr r} {
            if {(($rules($r,a1) <= $field) && ($field <= $rules($r,a2))) ||
                (($rules($r,b1) <= $field) && ($field <= $rules($r,b2))) } {
                set validField true
                break
            }
        }
        if {!$validField} {
            incr sumInvalidFields $field
        }
    }
}

puts $sumInvalidFields


# --------------------------------------------------------------------------------
# Question 2
# --------------------------------------------------------------------------------
puts $puzzleNr:b



# --------------------------------------------------------------------------------
# Solution
# --------------------------------------------------------------------------------

# 2020.16:a
# 25895


# --------------------------------------------------------------------------------
# Notes
# --------------------------------------------------------------------------------
