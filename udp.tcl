#-------Event scheduler object creation--------#
set ns [new Simulator]
#---Open the Trace files---#

set file1 [open Tcpred4.tr w]
$ns trace-all $file1
#--Open the NAM trace file----#
set file2 [open Tcpred4.nam w]
$ns namtrace-all $file2
#Define different colors for data flows (for NAM)
$ns color 1 Blue
$ns color 2 Red
#Create six nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
#create links between the nodes
$ns duplex-link $n1 $n5 2Mb 1ms DropTail
# $ns duplex-link $n1 $n2 2Mb 10ms DropTail
# $ns simplex-link $n2 $n3 0.3Mb 100ms DropTail
# $ns simplex-link $n3 $n2 0.3Mb 100ms DropTail
# $ns duplex-link $n3 $n4 0.5Mb 40ms DropTail
# $ns duplex-link $n3 $n5 0.5Mb 30ms DropTail
#Give node position (for NAM)
# $ns duplex-link-op $n0 $n2 orient right-down
# $ns duplex-link-op $n1 $n2 orient right-up
# $ns simplex-link-op $n2 $n3 orient right
# $ns simplex-link-op $n3 $n2 orient left
# $ns duplex-link-op $n3 $n4 orient right-up
# $ns duplex-link-op $n3 $n5 orient right-down

 

#Set Queue Size of link (n2-n3) to 10

# $ns queue-limit $n2 $n3 20

#Setup a TCP connection

# set tcp [new Agent/TCP/Newreno]
# $ns attach-agent $n0 $tcp
# set sink [new Agent/TCPSink/DelAck]
# $ns attach-agent $n4 $sink
# $ns connect $tcp $sink
# $tcp set fid_ 1
# $tcp set window_ 8000
# $tcp set packetSize_ 552

# #Setup a FTP over TCP connection
# set ftp [new Application/FTP]
# $ftp attach-agent $tcp
# $ftp set type_ FTP

 

#Setup a UDP connection

set udp [new Agent/UDP]
$ns attach-agent $n1 $udp
set null [new Agent/Null]
$ns attach-agent $n5 $null
$ns connect $udp $null
$udp set fid_ 2

#Setup a CBR over UDP connection

set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
# $cbr set type_ CBR
# $cbr set packet_size_ 1000
# $cbr set rate_ 0.01mb
# $cbr set random_ false

$ns at 0.1 "$cbr start"
# $ns at 1.0 "$ftp start"
# $ns at 10.0 "$ftp stop"
$ns at 10.5 "$cbr stop"

 

#Define a 'finish' procedure

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

#----------How to run----------#

$ns tcpred4.tcl

#--------Snapshot--------#