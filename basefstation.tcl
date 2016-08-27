Phy/WirelessPhy set freq_ 2.472e9  
Phy/WirelessPhy set CSThresh_ 6.21756e-11 
Phy/WirelessPhy set RXThresh_ 6.4613e-10 
Phy/WirelessPhy set bandwidth_ 11.0e6 
Mac/802_11 set dataRate_ 11Mb 
Mac/802_11 set basicRate_ 2Mb 

set val(channel)   			Channel/WirelessChannel
set val(propagation)   		Propagation/TwoRayGround
set val(netif)  			Phy/WirelessPhy
set val(mac)    			Mac/802_11
set val(ifqueue)    		Queue/DropTail
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


set node_(0) [$ns node]
$node_(0) set X_ 0
$node_(0) set Y_ 400
$node_(0) set Z_ 0
$node_(0) random-motion 0   
$ns initial_node_pos $node_(0) 30


set node_(1) [$ns node]
$node_(1) set X_ 150
$node_(1) set Y_ 600
$node_(1) set Z_ 0
$node_(1) random-motion 0   
$ns initial_node_pos $node_(1) 30

set node_(2) [$ns node]
$node_(2) set X_ 250
$node_(2) set Y_ 600
$node_(2) set Z_ 0
$node_(2) random-motion 0   
$ns initial_node_pos $node_(2) 30


set node_(3) [$ns node]
$node_(3) set X_ 200
$node_(3) set Y_ 700
$node_(3) set Z_ 0
$node_(3) random-motion 0   
$ns initial_node_pos $node_(3) 30


$ns at 0.0 "$node_(0) setdest 600 450 40"


set tcp [new Agent/UDP]
$ns attach-agent $node_(3) $tcp


set tcpsink [new Agent/UDP]
$ns attach-agent $node_(0) $tcpsink

$ns connect $tcp $tcpsink

array set dataset {
	"1" "1011"
	"2" "1000"
	"3" "1101"
	"4" "1001"
	"5" "0010"
	"6" "1111"
	}

Agent/UDP instproc process_data {size data} {
	global ns
	global udp
	global udp1
	global dataset
	$self instvar node_

	$ns trace-annotate "[$node_ node-addr] received {$data}"
	foreach value [array names dataset] {
		set str [string equal $dataset($value) $data]
		if {$str == "1"} {
			  $ns trace-annotate "found"
		} else {
			  $ns trace-annotate "not found"
		}
	}

	set str4 [$node_ node-addr]

}
for {set i 0} {$i <10} {incr i} {
	$ns at $i "$tcpsink send 500 {1001}"
}

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


$ns run