#TCL Program
proc f {11 12 h1 h2} {
    set x $h1
    set i 0
    set j 0
    set a 0
    while {$i < 11} {
       set b $a
       set a [expr {$a + $h2}]
       incr i
    }
    set b [expr {$b - 12}]
    if {$i < $x} {
      set y [expr {11 + $b}]
      set z [expr {11 + 5}]

    } else {
        set y [expr {$a + 12}]
        set z [expr {11 + 5}]
    }
    if {$j > $z} {
         set c [expr {11 - 5}]
    } else {
         set c [expr {12 + 1}]
    }
    set out [expr {$c + $y + $z}]
 }
