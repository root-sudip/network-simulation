Phy/WirelessPhy set freq_ 2.472e9  
Phy/WirelessPhy set RXThresh_ 2.62861e-09; 
Phy/WirelessPhy set CSThresh_ [expr 0.9*[Phy/WirelessPhy set RXThresh_]]
Phy/WirelessPhy set bandwidth_ 11.0e6 
Mac/802_11 set dataRate_ 11Mb 
Mac/802_11 set basicRate_ 2Mb 


set val(channel)   			Channel/WirelessChannel
set val(propagation)   		Propagation/TwoRayGround
set val(netif)  			Phy/WirelessPhy
set val(mac)    			Mac/802_11
set val(ifqueue)    		Queue/DropTail/PriQueue
set val(ll)     			LL 
set val(antenna)    		Antenna/OmniAntenna
set val(ifql)   			50
set val(nn)     			4
set val(rp)     			AODV
set val(x)					900
set val(y)      			900
set val(stop)   			30

set ns [new Simulator]
set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)
create-god $val(nn)

set tracefile [open out.tr w]
$ns trace-all $tracefile


set namfile [open out.nam w]
$ns namtrace-all $namfile
$ns namtrace-all-wireless $namfile $val(x) $val(y)

set chan [new $val(channel)]






$ns node-config -adhocRouting     $val(rp)    \
				-macType		  $val(mac)   \
				-llType    		  $val(ll)    \
				-ifqType		  $val(ifqueue)   \
				-ifqLen		  	  $val(ifql)  \
				-antType		  $val(antenna)   \
				-propType		  $val(propagation)  \
				-phyType		  $val(netif) \
				-channel          $chan       \
				-topoInstance     $topo        \
				-topoInstance $topo \
                -agentTrace ON \
                -routerTrace ON \
                -macTrace OFF \
                -movementTrace OFF \





set n0 [$ns node]
$n0 set X_ 200
$n0 set Y_ 10
$n0 set Z_ 0
$ns initial_node_pos $n0 30


set n1 [$ns node]
$n1 set X_ 200
$n1 set Y_ 10
$n1 set Z_ 0
$ns initial_node_pos $n1 30

set n2 [$ns node]
$n2 set X_ 200
$n2 set Y_ 10
$n2 set Z_ 0
$ns initial_node_pos $n2 30


set n3 [$ns node]
$n3 set X_ 200
$n3 set Y_ 400
$n3 set Z_ 0
$ns initial_node_pos $n3 30



$ns at 0.0 "$n0 setdest 200 400 40"
$ns at 0.0 "$n1 setdest 200 400 50"
$ns at 0.0 "$n2 setdest 200 400 60"


$ns at 10.0 "$n0 setdest 100 600 40"
$ns at 7.0  "$n1 setdest 300 600 50"
$ns at 12.0 "$n2 setdest 100 600 60"

set tcp [new Agent/TCP]
$ns attach-agent $n3 $tcp


set tcpsink [new Agent/TCPSink]
$ns attach-agent $n0 $tcpsink

$ns connect $tcp $tcpsink

#$tcp set packetSize_ 1500

set ftp [new Application/FTP]
$ftp attach-agent $tcp



$ns at 1.0 "$ftp start"
#$ns at val(stop) "$ftp stop"

$ns at $val(stop) "finish"

proc finish {} \
{
	global ns namfile tracefile
	$ns flush-trace
	close $namfile
	close $tracefile
	exec nam out.nam &
    exit 0
}


#$ns at $val(stop) "$ns nam-end-wireless $val(stop)"


$ns run