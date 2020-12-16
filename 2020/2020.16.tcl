# --------------------------------------------------------------------------------
# Input
# --------------------------------------------------------------------------------
set puzzleNr    [file rootname [file tail [info script]]]
set input       [split [read [open $puzzleNr\_input.txt r]] \n]


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
    if {[regexp $rulesRegex $i all fieldName a1 a2 b1 b2]} {
        set rules($nrOfRules,fieldName) $fieldName
        set rules($nrOfRules,a1)        $a1
        set rules($nrOfRules,a2)        $a2
        set rules($nrOfRules,b1)        $b1
        set rules($nrOfRules,b2)        $b2
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

set nrOfFields              0
set nrOfValidNearbyTickets  0

set sumInvalidFields        0

foreach ticket $nearbyTickets {
    set validTicket true
    foreach fieldValue $ticket {
        set validField false
        for {set r 0} {$r < $nrOfRules} {incr r} {
            if {(($rules($r,a1) <= $fieldValue) && ($fieldValue <= $rules($r,a2))) ||
                (($rules($r,b1) <= $fieldValue) && ($fieldValue <= $rules($r,b2))) } {
                set validField true
                break
            }
        }
        if {!$validField} {
            incr sumInvalidFields $fieldValue
            set validTicket false
        }
    }
    if {$validTicket} {
        set f 0
        foreach fieldValue $ticket {
            lappend fieldValues($f) $fieldValue
            incr f
        }
        set nrOfFields $f
        incr nrOfValidNearbyTickets
    }
}

puts $sumInvalidFields


# --------------------------------------------------------------------------------
# Question 2
# --------------------------------------------------------------------------------
puts $puzzleNr:b

for {set r 0} {$r < $nrOfRules} {incr r} {
    for {set f 0} {$f < $nrOfFields} {incr f} {
        set ruleAppliesToAllFieldValues true
        foreach fieldValue $fieldValues($f) {
            if {!((($rules($r,a1) <= $fieldValue) && ($fieldValue <= $rules($r,a2))) ||
                  (($rules($r,b1) <= $fieldValue) && ($fieldValue <= $rules($r,b2)))) } {
                set ruleAppliesToAllFieldValues false
                break
            }
        }
        if {$ruleAppliesToAllFieldValues} {
            lappend rules($r,fieldID) $f
        }
    }
}


set rulesHandled ""
for {set i 0} {$i < $nrOfRules} {incr i} {
    set uniqueForRule -1
    set uniqueFieldID -1
    for {set r 0} {$r < $nrOfRules} {incr r} {
        if {[llength $rules($r,fieldID)] == 1 && [lsearch $rulesHandled $r] < 0} {
            set uniqueForRule $r
            set uniqueFieldID $rules($r,fieldID)
            lappend rulesHandled $r
            break
        }
    }
    for {set r 0} {$r < $nrOfRules} {incr r} {
        if {$r == $uniqueForRule} {
            continue
        }
        set id [lsearch -integer $rules($r,fieldID) $uniqueFieldID]
        set rules($r,fieldID) [lreplace $rules($r,fieldID) $id $id]
    }
}

set multResult 1
for {set r 0} {$r < $nrOfRules} {incr r} {
    if {[regexp {departure} $rules($r,fieldName) all]} {
        set multResult [expr $multResult * [lindex $myTicket $rules($r,fieldID)]]
    }
}
puts $multResult


# --------------------------------------------------------------------------------
# Solution
# --------------------------------------------------------------------------------

# 2020.16:a
# 25895
# 2020.16:b
# 5865723727753


# --------------------------------------------------------------------------------
# Notes
# --------------------------------------------------------------------------------
