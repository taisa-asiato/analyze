#index$BKh$K(B, $BIC4V2?%U%m!<$,N.$l$F$-$F$$$k$+$r%+%&%s%H$9$k(B
flow_index_array = Array.new( 256 ){ Array.new(){ 0 } }
#index$BKh$N%Q%1%C%H?t$r%+%&%s%H(B
packet = Array.new( 256 ){ 0 }
#index$BKh$K(B, $B%U%m!<$N?t$r%+%&%s%H(B
flow = Array.new( 256 ){ Hash.new( -1.0 ) }
#index$BKh$K(B, $B;~4V$"$?$j$N%U%m!<?t$r%+%&%s%H(B
interval_flow = Array.new( 256 ){ Hash.new( 0 ) }

total_flow = 0
total_packet = 0
total_packet_index = Array.new( 256 ){ 0 }
time = 1.0
time_index = Array.new( 256 ){ 1 }
File.open( 'pra.out' ) do | openfile |
#File.open( 'analyze2009_1.out' ) do | openfile |
		while line = openfile.gets
#		line = line.scrub('.') #$BIT@5%P%$%H$r(B.$B$KCV$-49$((B
		line_split = line.split(", ")
		num = line_split[8].to_i
		time = line_split[0].to_f
		#flow id $B$N:n@.(B
		flow_id = line_split[1] + "-" + line_split[2] + "-" + line_split[3] + "-" + line_split[4] + "-" + line_split[5]
		#flow id$B$4$H$KO"A[G[Ns$r:n@.$9$k(B
		if flow[num][flow_id] == -1 then
			flow[num][flow_id] = time
		elsif flow[num][flow_id] != -1 then
			flow[num][flow_id] = -2
		end
#		flow[num][flow_id] = flow[num][flow_id] + 1
		#index$BKh$N%Q%1%C%H?t$r%+%&%s%H(B
		
		#index$B$4$H$KG[Ns$r:n@.$9$k(B ($B;~4VKh$N%U%m!<?t$r%+%&%s%H$9$k(B)
#		flow_index_array[num].push( line_split )
		total_packet = total_packet + 1
#		print line_split[0], ",", line_split[1], ",", line_split[2], ",", line_split[3], ",", 
#			line_split[4], ",", line_split[5], ",", line_split[6], ",", line_split[7], ",", line_split[8], "\n"
	end
end
j = 0
for i in 0...256 do
	#index$BKh$K>e0L(B4$B%U%m!<$r=PNO(B
	flow_array = flow[i].sort{|a, b| a[1]<=>b[1] }
	for j in 0...flow[i].length do
		if flow_array[j][1] != -2 then 
			array = flow_array[j][0].split("-")
			print array[0], ", ", array[1], ", ", array[2], ", ", array[3], ", ", array[4], ", ", flow_array[j][1], "\n"
		end
	end
end
