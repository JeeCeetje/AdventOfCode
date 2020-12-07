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
    foreach i $::input {                                                                ;# Run over all definitions until we find the definition of myBag :-)
        regexp {(.*)\s+bags\s+contain\s+(.*)} $i all outerBag innerBags                 ;# Analyze the definition; we do not check if the regex fails because our input is clean.
        if {[regexp $myBag $innerBags]} {                                               ;# This bag had myBag in it!
            if {[lsearch $alreadyFoundBags $outerBag] < 0} {                            ;# Is it a new bag that I didn't know of?
                lappend alreadyFoundBags $outerBag                                      ;# If so, make note of it!
                set alreadyFoundBags [findBags $outerBag $alreadyFoundBags]             ;# Also look of this new bag can be in other bags.
            }
        }
    }
    return $alreadyFoundBags;                                                           ;# Okay, done!
}

puts [llength [findBags "shiny gold"]]


# --------------------------------------------------------------------------------
# Question 2
# --------------------------------------------------------------------------------
puts $puzzleNr:b

proc findBagContents {myBag} {
    foreach i $::input {                                                                ;# Run over all definitions until we find the definition of myBag :-)
        regexp {(.*)\s+bags\s+contain\s+(.*)} $i all outerBag innerBags                 ;# Analyze the definition; we do not check if the regex fails because our input is clean.
        if {[regexp $myBag $outerBag]} {                                                ;# The definintion of myBag is found!
            set innerBagsList [regexp -inline -all {(\d+?)\s+(.+?)\s+bag} $innerBags]   ;# This is the list of bags in myBag.
                                                                                        ;#  Again, ignore the strange list that the regexp returns. First item is the full match,
                                                                                        ;#  followed by each subgroup. Therefor we ignore item 0 and increment by 3 in the loop.
            set sumContents 0                                                           ;# Possibly this bag has no contents.
            for {set j 1} {$j < [llength $innerBagsList]} {incr j 3} {                  ;# Run over the list of bags. For each of those bags...
                set nr          [lindex $innerBagsList $j]                              ;# This is the number of times that we have this bag in myBag.
                set contents    [findBagContents [lindex $innerBagsList [expr $j+1]]]   ;# This is the contents of this bag.
                set sumContents [expr $sumContents + $nr + $nr * $contents]             ;# Sum it all together; previous loop result + #(this bag) + #(this bag) * (this bag contents)
            }
            return $sumContents                                                         ;# Return the content of this bag. This breaks the foreach loop but that is ok because
                                                                                        ;# each outerBag should only have a single definition.
        }
    }
    return 0;                                                                           ;# If the bag is not in the list...
}

puts [findBagContents "shiny gold"]


# --------------------------------------------------------------------------------
# Solution
# --------------------------------------------------------------------------------

# 2020.07:a
# 211
# 2020.07:b
# 12414


# --------------------------------------------------------------------------------
# Notes
# --------------------------------------------------------------------------------
