#define simulator

set ns [new Simulator]

#open trace file

set tracefile1 [open out.tr w]
$ns trace-all $tracefile1 

#create nodes
set node_(0) [$ns node]
set node_(1) [$ns node]

#create link
$ns duplex-link $node_(0) $node_(1) 10Mb 10ms DropTail 

# Add Transport agents

set tcp_ [new Agent/TCP]
set sink_ [new Agent/TCPSink]

$ns attach-agent $node_(0) $tcp_
$ns attach-agent $node_(1) $sink_
$ns connect $tcp_ $sink_

# Add application
set ftp_ [new Application/FTP]
$ftp_ attach-agent $tcp_

#define a finish procedure

proc finish { } {
	global ns tracefile1
	$ns flush-trace 
	close $tracefile1
	exit 0
}

# Create a schedule

$ns at 0.0 "$ftp_ start" 
$ns at 2.0 "$ftp_ stop" 
$ns at 4.5 "puts \"NS EXITING...at [$ns now]\""
$ns at 4.6 "finish"

#Run the simulation
puts "Starting Simulation at [$ns now]"
$ns run

