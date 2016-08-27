set ns [new Simulator]

set file1 [open Tcpred4.tr w]
$ns trace-all $file1

set file2 [open Tcpred4.nam w]
$ns namtrace-all $file2

$ns color 1 Blue
$ns color 2 Red

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

$ns duplex-link $n1 $n5 2Mb 1ms DropTail


set udp [new Agent/UDP]
$ns attach-agent $n1 $udp
set udp1 [new Agent/UDP]
$ns attach-agent $n5 $udp1
$ns connect $udp $udp1
$udp set fid_ 2

Agent/UDP instproc process_data {size data} {
	global ns
	global udp
	global udp1
	$ns trace-annotate "received {$data}"
}
for {set i 0} {$i <10} {incr i} {
	$ns at $i "$udp send 500 {how are you}"
}
 
# set cbr [new Application/Traffic/CBR]
# $cbr attach-agent $udp

# $ns at 0.1 "$cbr start"
# $ns at 10.5 "$cbr stop"


proc finish {} {
        global ns file1 file2
        $ns flush-trace
        close $file1
        close $file2
        exec nam Tcpred4.nam &
        exit 0
}

 

$ns at 12.0 "finish"
$ns run


$ns tcpred4.tcl

#--------Snapshot--------#