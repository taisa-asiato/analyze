#index$BKh$K(B, $BIC4V2?%U%m!<$,N.$l$F$-$F$$$k$+$r%+%&%s%H$9$k(B
flow_index_array = Array.new( 256 ){ Array.new(){ 0 } }
#index$BKh$N%Q%1%C%H?t$r%+%&%s%H(B
packet = Array.new( 256 ){ 0 }
#index$BKh$K(B, $B%U%m!<$N?t$r%+%&%s%H(B
flow = Array.new( 256 ){ Hash.new { |h, k| h[k] = [] } }
#index$BKh$K(B, $B;~4V$"$?$j$N%U%m!<?t$r%+%&%s%H(B
interval_flow = Array.new( 256 ){ Hash.new( 0 ) }

total_flow = 0
total_packet = 0
total_packet_index = Array.new( 256 ){ 0 }
time = 0.0
time_index = Array.new( 256 ){ 1 }

File.open( 'analyze2009_1.out' ) do | openfile |
		while line = openfile.gets
#		line = line.scrub('.') #$BIT@5%P%$%H$r(B.$B$KCV$-49$((B
		#, $B6h@Z$j$GJ8;zNs$rJ,3d(B
		line_split = line.split(", ")

		#$B%U%m!<$N%$%s%G%C%/%9HV9f(B
		num = line_split[8].to_i

		#$B;~9o(B
		time = line_split[0].to_f

		#flow id $B$N:n@.(B
		flow_id = line_split[1] + "-" + line_split[2] + "-" + line_split[3] + "-" + line_split[4] + "-" + line_split[5]
		
		#flow id$B$4$H$KO"A[G[Ns$r:n@.$9$k(B
		flow[num][flow_id] = flow[num][flow_id].push( )
		#index$BKh$N%Q%1%C%H?t$r%+%&%s%H(B
		packet[num] = packet[num] +1
		
		#index$B$4$H$KG[Ns$r:n@.$9$k(B ($B;~4VKh$N%U%m!<?t$r%+%&%s%H$9$k(B)
#		flow_index_array[num].push( line_split )
		total_packet = total_packet + 1
		print line_split[0], ", ", line_split[1], ",", line_split[2], ",", line_split[3], ",", 
			line_split[4], ",", line_split[5], ",", line_split[6], ",", line_split[7], ",", line_split[8]
		end
	end
end
