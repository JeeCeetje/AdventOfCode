# --------------------------------------------------------------------------------
# Input
# --------------------------------------------------------------------------------
set puzzleNr    [file rootname [file tail [info script]]]
set input       [split [read [open $puzzleNr\_input.txt r]] \n]
# set input       [split [read [open $puzzleNr\_example.txt r]] \n]



# --------------------------------------------------------------------------------
# Question A
# --------------------------------------------------------------------------------
puts $puzzleNr:a

# Find low points, thus boundaries are max
set boundaryHeight 9

# Add boundary to north and south
set width [string length [lindex $input 0]]
set input [linsert $input 0   [string repeat $boundaryHeight $width]]
set input [linsert $input end [string repeat $boundaryHeight $width]]

# Create map
set y 0
foreach i $input {
    set x 0
    set map($x,$y) $boundaryHeight
    foreach j [split $i ""] {
        incr x
        set map($x,$y) $j
    }
    incr x
    set map($x,$y) $boundaryHeight
    incr y
}

set  height $y
incr width  2

# Run over map
set riskLevel 0
for {set y 1} {$y < [expr $height-1]} {incr y} {
    for {set x 1} {$x < [expr $width-1]} {incr x} {
        if {($map($x,$y) < $map($x,[expr $y-1])) && \
            ($map($x,$y) < $map($x,[expr $y+1])) && \
            ($map($x,$y) < $map([expr $x-1],$y)) && \
            ($map($x,$y) < $map([expr $x+1],$y)) } {
            incr riskLevel $map($x,$y)
            incr riskLevel
        }
    }
}

puts $riskLevel



# --------------------------------------------------------------------------------
# Question B
# --------------------------------------------------------------------------------
puts $puzzleNr:b

# Helper function to print the map
proc printMap {{argTxt ""}} {
    puts "$argTxt"
    for {set y 0} {$y < $::height} {incr y} {
        for {set x 0} {$x < $::width} {incr x} {
            puts -nonewline [format "%3d" $::map($x,$y)]
        }
        puts ""
    }
    puts ""
}

# Replace height map by zeros and ones
for {set y 0} {$y < $height} {incr y} {
    for {set x 0} {$x < $width} {incr x} {
        if {$map($x,$y) < 0 || 8 < $map($x,$y)} {
            set map($x,$y) 0
        } else {
            set map($x,$y) 1
        }
    }
}
# printMap "Original"

# Create a flow function
proc flow {x y} {
    # If there is nothing to flow, don't flow
    upvar #0 ::map($x,$y) c
    if {$c == 0} {return 0}
    
    # If only one direction to flow, flow that direction
    upvar #0 ::map($x,[expr $y-1]) n \
             ::map([expr $x+1],$y) e \
             ::map($x,[expr $y+1]) s \
             ::map([expr $x-1],$y) w
    # puts " $n \n$w$c$e\n $s"
    if {$n  > 0 && $e == 0 && $s == 0 && $w == 0} {incr n $c; set c 0; return 1}
    if {$n == 0 && $e  > 0 && $s == 0 && $w == 0} {incr e $c; set c 0; return 1}
    if {$n == 0 && $e == 0 && $s  > 0 && $w == 0} {incr s $c; set c 0; return 1}
    if {$n == 0 && $e == 0 && $s == 0 && $w  > 0} {incr w $c; set c 0; return 1}
    
    # If max two directions to flow, flow if directions are connected
    upvar #0 ::map([expr $x+1],[expr $y-1]) ne \
             ::map([expr $x+1],[expr $y+1]) se \
             ::map([expr $x-1],[expr $y+1]) sw \
             ::map([expr $x-1],[expr $y-1]) nw
    # puts "$nw$n$ne\n$w$c$e\n$sw$s$se"
    if {$n > 0 && $e > 0 && $ne > 0 && $s == 0 && $w == 0} {incr n $c; set c 0; return 1}
    if {$n > 0 && $w > 0 && $nw > 0 && $s == 0 && $e == 0} {incr n $c; set c 0; return 1}
    if {$s > 0 && $e > 0 && $se > 0 && $n == 0 && $w == 0} {incr s $c; set c 0; return 1}
    if {$s > 0 && $w > 0 && $sw > 0 && $n == 0 && $e == 0} {incr s $c; set c 0; return 1}
    
    # Else wait till neighbours have flowed
    return 0
}

# Create a flow around mountain function (this is slower to check)
proc flowAroundMountain {x y} {
    # If there is nothing to flow, check if this point is a mountain in a bassin
    upvar #0 ::map($x,$y) c
    if {$c != 0} {return 0}
    
    # If flowing around the mountain, break that deadloop
    upvar #0 ::map($x,[expr $y-1])          n  \
             ::map([expr $x+1],$y)          e  \
             ::map($x,[expr $y+1])          s  \
             ::map([expr $x-1],$y)          w  \
             ::map([expr $x+1],[expr $y-1]) ne \
             ::map([expr $x+1],[expr $y+1]) se \
             ::map([expr $x-1],[expr $y+1]) sw \
             ::map([expr $x-1],[expr $y-1]) nw
    if {$n  > 0 && $e  > 0 && $s  > 0 && $w  > 0 && \
        $ne > 0 && $se > 0 && $sw > 0 && $nw > 0 } {
        incr n  $nw
        set  nw 0
        return 1
    }
    return 0
}

# Start the flowing
set loop 0
set stillFlowing 1
while {$stillFlowing > 0} {
    set stillFlowing 0
    for {set y 1} {$y < [expr $height-1]} {incr y} {
        for {set x 1} {$x < [expr $width-1]} {incr x} {
            incr stillFlowing [flow $x $y]
        }
    }
    if {$stillFlowing == 0} {
        for {set y 1} {$y < [expr $height-1]} {incr y} {
            for {set x 1} {$x < [expr $width-1]} {incr x} {
                incr stillFlowing [flowAroundMountain $x $y]
            }
        }
    }
    incr loop
    # printMap "Loop $loop"
}

# Collect the bassins, sort them by size
set bassins {}
for {set y 1} {$y < [expr $height-1]} {incr y} {
    for {set x 1} {$x < [expr $width-1]} {incr x} {
        if {$map($x,$y) > 0} {
            lappend bassins $map($x,$y)
        }
    }
}
set bassins [lsort -integer -decreasing $bassins]
set resultB [expr [lindex $bassins 0] * [lindex $bassins 1] * [lindex $bassins 2]]

puts $resultB




# --------------------------------------------------------------------------------
# Solution
# --------------------------------------------------------------------------------

# 2021.09:a
# 500
# 2021.09:b
# 970200



# --------------------------------------------------------------------------------
# Notes
# --------------------------------------------------------------------------------


