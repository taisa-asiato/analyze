#index$BKh$K(B, $BIC4V2?%U%m!<$,N.$l$F$-$F$$$k$+$r%+%&%s%H$9$k(B
flow_index_array = Array.new( 256 ){ Array.new(){ 0 } }
#index$BKh$N%Q%1%C%H?t$r%+%&%s%H(B
packet = Array.new( 256 ){ 0 }
#index$BKh$K(B, $B%U%m!<$N?t$r%+%&%s%H(B
flow = Array.new( 256 ){ Hash.new( 0 ) }
#index$BKh$K(B, $B;~4V$"$?$j$N%U%m!<?t$r%+%&%s%H(B
interval_flow = Array.new( 256 ){ Hash.new( 0 ) }

total_flow = 0
total_packet = 0
total_packet_index = Array.new( 256 ){ 0 }
time = 1.0
time_index = Array.new( 256 ){ 1 }
#File.open( 'pra.out' ) do | openfile |
File.open( 'analyze2009_1.out' ) do | openfile |
		while line = openfile.gets
#		line = line.scrub('.') #$BIT@5%P%$%H$r(B.$B$KCV$-49$((B
		line_split = line.split(", ")
		num = line_split[8].to_i
		time = line_split[0].to_f
		#flow id $B$N:n@.(B
		flow_id = line_split[1] + "-" + line_split[2] + "-" + line_split[3] + "-" + line_split[4] + "-" + line_split[5]
		#flow id$B$4$H$KO"A[G[Ns$r:n@.$9$k(B
		flow[num][flow_id] = flow[num][flow_id] + 1
		#index$BKh$N%Q%1%C%H?t$r%+%&%s%H(B
		packet[num] = packet[num] +1
		
		if time_index[num] < time then 
			interval_flow[num][flow_id] = interval_flow[num][flow_id] + 1
		elsif time_index[num] > time then
			tmp = interval_flow[num].length
			flow_index_array[num].push( tmp )
			interval_flow[num].clear()
			interval_flow[num][flow_id] = interval_flow[num][flow_id] + 1
			time = time + 1
		end
			
		#index$B$4$H$KG[Ns$r:n@.$9$k(B ($B;~4VKh$N%U%m!<?t$r%+%&%s%H$9$k(B)
#		flow_index_array[num].push( line_split )
		total_packet = total_packet + 1
#		print line_split[0], ",", line_split[1], ",", line_split[2], ",", line_split[3], ",", 
#			line_split[4], ",", line_split[5], ",", line_split[6], ",", line_split[7], ",", line_split[8], "\n"
	end
end

for i in 0...256 do
	tmp = interval_flow[i].length
	if tmp != 0 then 
		flow_index_array[i].push( tmp )
	end
end

print "all contents were pushed into hash "
print ", , , , , , , , "
for i in 0...900 do
	print i, ", "
end
print "\n"
j = 0
for i in 0...256 do
	#index$BKh$N%Q%1%C%H?t(B, $B%U%m!<?t$r=PNO(B
	print "INDEX:", i, ", ", packet[i], ", ", flow[i].length, ", " 
	#$BA4%U%m!<?t$r2C;;(B
	total_flow = total_flow + flow[i].length

	#index$BKh$K>e0L(B4$B%U%m!<$r=PNO(B
	flow_array = flow[i].sort{|a, b| b[1]<=>a[1] }
	for j in 0...4 do
		print flow_array[j][0], "-", flow_array[j][1], ", "
	end

	packet_length = flow_index_array[i].length
	for j in 0...packet_length do
		print flow_index_array[i][j],
		if j != packet_length then
			print ", "
		end
	end
	print "\n"
end
print "total_packet:", total_packet, "total_flow:", total_flow, "\n"
