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

set sumEasyValues 0
foreach i $input {
    set digits [lrange [regexp -inline {\| (\w+) (\w+) (\w+) (\w+)} $i] 1 end]
    foreach digit $digits {
        switch [string length $digit] {
            2 - 4 - 3 - 7 {
                incr sumEasyValues
            }
        }
    }
}

puts $sumEasyValues



# --------------------------------------------------------------------------------
# Question B
# --------------------------------------------------------------------------------
puts $puzzleNr:b

proc stringLengthSort {a b} {
    return [expr [string length $a]-[string length $b]]
}

set sumOutputValues 0
foreach i $input {
    # Get digits from regex
    set digits [lrange [regexp -inline {(\w+) (\w+) (\w+) (\w+) (\w+) (\w+) (\w+) (\w+) (\w+) (\w+) \| (\w+) (\w+) (\w+) (\w+)} $i] 1 end]
    # Reorder signals in digits alphabetically
    set pattern {}
    foreach digit $digits {
        lappend pattern [join [lsort [split $digit ""]] ""]
    }
    # Get sequence digits and sort them on string length
    set sequenceDigits [lsort -command stringLengthSort [lrange $pattern 0 9]]
    # Decode easy digits on string length (see also question A)
    set code(1) [lindex $sequenceDigits 0]
    set code(7) [lindex $sequenceDigits 1]
    set code(4) [lindex $sequenceDigits 2]
    set code(8) [lindex $sequenceDigits 9]
    # Digits with 6 segments
    #   1. 4 is fully contained in 9 but not in 0 and 6
    #   2. 7 is fully contained in 0 but not in 6
    #   3. 6 is left over
    foreach s [lrange $sequenceDigits 6 8] {
        if {([regexp -all "\[$code(4)\]" $s] == 3) && ([regexp -all "\[$code(7)\]" $s] == 3)} { set code(0) $s }
        if {([regexp -all "\[$code(4)\]" $s] == 3) && ([regexp -all "\[$code(7)\]" $s] == 2)} { set code(6) $s }
        if {([regexp -all "\[$code(4)\]" $s] == 4) && ([regexp -all "\[$code(7)\]" $s] == 3)} { set code(9) $s }
    }
    # Digits with 5 segments
    #   1. 7 is fully contained in 3 but not in 2 and 5
    #   2. 5 is fully contained in 6
    #   3. 2 is left over
    foreach s [lrange $sequenceDigits 3 5] {
        if {([regexp -all "\[$code(6)\]" $s] == 4) && ([regexp -all "\[$code(7)\]" $s] == 2)} { set code(2) $s }
        if {([regexp -all "\[$code(6)\]" $s] == 4) && ([regexp -all "\[$code(7)\]" $s] == 3)} { set code(3) $s }
        if {([regexp -all "\[$code(6)\]" $s] == 5) && ([regexp -all "\[$code(7)\]" $s] == 2)} { set code(5) $s }
    }
    # Get output value digits
    set values [lrange $pattern 10 13]
    set outputValue ""
    foreach value $values {
        for {set i 0} {$i < 10} {incr i} {
            if {$code($i) == $value} {
                append outputValue $i
                break
            }
        }
    }
    incr sumOutputValues [string trimleft $outputValue "0"] ;# Avoid octal issue
}

puts $sumOutputValues



# --------------------------------------------------------------------------------
# Solution
# --------------------------------------------------------------------------------

# 2021.08:a
# 456
# 2021.08:b
# 1091609



# --------------------------------------------------------------------------------
# Notes
# --------------------------------------------------------------------------------


