# --------------------------------------------------------------------------------
# Input
# --------------------------------------------------------------------------------
set puzzleNr    [file rootname [file tail [info script]]]
set input       [split [read [open $puzzleNr\_input.txt r]] \n]


# --------------------------------------------------------------------------------
# Question 1
# --------------------------------------------------------------------------------
puts $puzzleNr:a

proc findBags {myBag {alreadyFoundBags ""}} {
    foreach i $::input {
        regexp {(.*)\sbags\s+contain\s+(.*)} $i all outerBag innerBags
        if {[regexp $myBag $innerBags]} {
            if {[lsearch $alreadyFoundBags $outerBag] < 0} {
                lappend alreadyFoundBags $outerBag
                set alreadyFoundBags [findBags $outerBag $alreadyFoundBags]
            }
        }
    }
    return $alreadyFoundBags;
}

puts [llength [findBags "shiny gold"]]


# --------------------------------------------------------------------------------
# Question 2
# --------------------------------------------------------------------------------
puts $puzzleNr:b



# --------------------------------------------------------------------------------
# Solution
# --------------------------------------------------------------------------------




# --------------------------------------------------------------------------------
# Notes
# --------------------------------------------------------------------------------
