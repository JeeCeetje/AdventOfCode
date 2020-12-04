# Read input file
set puzzleNr    [file rootname [file tail [info script]]]
set data        [read [open $puzzleNr\_input.txt r]]


# Split data by finding as many chars until more than one newline is found
set splitted [regexp -inline -line -all {(.+\n?)+} $data]

# Due to how the tcl regexp inline function works, keep only the even results
set input ""
for {set i 0} {$i < [llength $splitted]} {incr i 2} {
    lappend input [lindex $splitted $i]
}


# Question 1
proc findValidSimple {
    {optional_byr 0}
    {optional_iyr 0}
    {optional_eyr 0}
    {optional_hgt 0}
    {optional_hcl 0}
    {optional_ecl 0}
    {optional_pid 0}
    {optional_cid 1}
} {
    set result 0
    foreach i $::input {
        if {$optional_byr == 0 && [regexp {byr:} $i] == 0} {continue}
        if {$optional_iyr == 0 && [regexp {iyr:} $i] == 0} {continue}
        if {$optional_eyr == 0 && [regexp {eyr:} $i] == 0} {continue}
        if {$optional_hgt == 0 && [regexp {hgt:} $i] == 0} {continue}
        if {$optional_hcl == 0 && [regexp {hcl:} $i] == 0} {continue}
        if {$optional_ecl == 0 && [regexp {ecl:} $i] == 0} {continue}
        if {$optional_pid == 0 && [regexp {pid:} $i] == 0} {continue}
        if {$optional_cid == 0 && [regexp {cid:} $i] == 0} {continue}
        incr result
    }
    return $result
}

puts $puzzleNr:a
puts [findValidSimple]


# Question 2
proc findValidAdvanced {
    {optional_byr 0}
    {optional_iyr 0}
    {optional_eyr 0}
    {optional_hgt 0}
    {optional_hcl 0}
    {optional_ecl 0}
    {optional_pid 0}
    {optional_cid 1}
} {
    set result 0
    foreach i $::input {
        if {$optional_byr == 0 && [regexp {byr:(\d+)\s} $i                         all val     ] == 0} {continue}
            if {$val < 1920 || $val > 2002} {continue}
        if {$optional_iyr == 0 && [regexp {iyr:(\d+)\s} $i                         all val     ] == 0} {continue}
            if {$val < 2010 || $val > 2020} {continue}
        if {$optional_eyr == 0 && [regexp {eyr:(\d+)\s} $i                         all val     ] == 0} {continue}
            if {$val < 2020 || $val > 2030} {continue}
        if {$optional_hgt == 0 && [regexp {hgt:(\d+)(in|cm)\s} $i                  all val unit] == 0} {continue}
            if {$unit == "cm" && ($val < 150 || $val > 193)} {continue}
            if {$unit == "in" && ($val <  59 || $val >  76)} {continue}
        if {$optional_hcl == 0 && [regexp {hcl:#[0-9a-fA-F]{6}\s} $i               all val     ] == 0} {continue}
        if {$optional_ecl == 0 && [regexp {ecl:(amb|blu|brn|gry|grn|hzl|oth)\s} $i all val     ] == 0} {continue}
        if {$optional_pid == 0 && [regexp {pid:\d{9}\s} $i                         all val     ] == 0} {continue}
        if {$optional_cid == 0 && [regexp {cid:} $i                                all val     ] == 0} {continue}
        incr result
    }
    return $result
}

puts $puzzleNr:b
puts [findValidAdvanced]