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

foreach ticket $nearbyTickets {                                                         ;# For every ticket...
    set validTicket true
    foreach fieldValue $ticket {                                                        ;# ... take every field value...
        set validField false
        for {set r 0} {$r < $nrOfRules} {incr r} {                                      ;# ... check all rules against it...
            if {(($rules($r,a1) <= $fieldValue) && ($fieldValue <= $rules($r,a2))) ||
                (($rules($r,b1) <= $fieldValue) && ($fieldValue <= $rules($r,b2))) } {
                set validField true                                                     ;# ... stop checking the rules if th field value applies to one of them, then this field value is valid.
                break
            }
        }
        if {!$validField} {
            incr sumInvalidFields $fieldValue                                           ;# If this field value didn't follow a single rule, then the ticket is false.
            set validTicket false
        }
    }
    if {$validTicket} {                                                                 ;# Only keep the valid tickets but...
        set f 0
        foreach fieldValue $ticket {                                                    ;# ... instead of saving them as tickets, we save lists of field values.
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

for {set r 0} {$r < $nrOfRules} {incr r} {                                              ;# Run all rules...
    for {set f 0} {$f < $nrOfFields} {incr f} {                                         ;# ... against all lists of field values.
        set ruleAppliesToAllFieldValues true
        foreach fieldValue $fieldValues($f) {                                           ;# If every field value of that list applies to the current rule...
            if {!((($rules($r,a1) <= $fieldValue) && ($fieldValue <= $rules($r,a2))) ||
                  (($rules($r,b1) <= $fieldValue) && ($fieldValue <= $rules($r,b2)))) } {
                set ruleAppliesToAllFieldValues false
                break
            }
        }
        if {$ruleAppliesToAllFieldValues} {                                             ;# ... then this field *COULD* be one for that rule...
            lappend rules($r,fieldID) $f                                                ;# ... so add this field as a possible field for this rule.
        }
    }
}


set rulesHandled ""
for {set i 0} {$i < $nrOfRules} {incr i} {                                              ;# Find a uniqe rule for every field.
    set uniqueForRule -1
    set uniqueFieldID -1
    for {set r 0} {$r < $nrOfRules} {incr r} {                                          ;# Run over all rules...
        if {[llength $rules($r,fieldID)] == 1 && [lsearch $rulesHandled $r] < 0} {      ;# ... and check how many fields follow this rule, if it's only one (and it's not handled yet), we have a winner!
            set uniqueForRule $r
            set uniqueFieldID $rules($r,fieldID)
            lappend rulesHandled $r
            break
        }
    }
    for {set r 0} {$r < $nrOfRules} {incr r} {                                          ;# Now remove this field as possible field for the other rules.
        if {$r == $uniqueForRule} {
            continue
        }
        set id [lsearch -integer $rules($r,fieldID) $uniqueFieldID]
        set rules($r,fieldID) [lreplace $rules($r,fieldID) $id $id]
    }
}

set multResult 1
for {set r 0} {$r < $nrOfRules} {incr r} {                                              ;# Final step, for ever "departure" field, multiply the values of my ticket.
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
