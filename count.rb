array_separate_index = Array.new( 256 ){ Array.new(){ Array.new( 8 ) } } #index$BJL$K%U%m!<$H%Q%1%C%H?t$r5-O?(B
array_all = Array.new() #$B$9$Y$F$N%U%m!<$H$=$N%Q%1%C%H?t$r5-O?(B
array_num = -1
index_packet_flow = Array.new( 256 ){ Array.new( 3 ) }

File.open( 'static_2009_0402.out' ) do | openfile |
	while line = openfile.gets
		line = line.scrub('.') #$BIT@5%P%$%H$r(B.$B$KCV$-49$((B
		line_split = line.split(" ")

		if line_split.length == 1 then
			array_num = array_num + 1
		elsif line_split.length == 8 then 
			array_all.push( line_split )
			array_separate_index[array_num].push( line_split )
		end
	end
end

array_all.sort! {|a, b| b[7].to_i <=> a[7].to_i } #2$B<!85G[Ns$NFCDj$NMWAG$GJB$SBX$((B
#$BA4%U%m!<$NCf$G(B, $B%Q%1%C%H?t$,>e0L(B1024$BHVL\$^$G$N$b$N$r=PNO(B
for num in 0...1024 do 
	print num, ",", array_all[num][0], " ", array_all[num][1], " ", array_all[num][2], " ", array_all[num][3], " ", array_all[num][4], " ", array_all[num][7], "\n"
end

print "\n==========\n"
num = 0
flow = 0
for num in 0...256 do 
	packet = 0
	flow = 0
	for array_num in 0...array_separate_index[num].length do
		packet = packet + array_separate_index[num][array_num][7].to_i #$B3F(Bindex$BKh$KEPO?$5$l$k%Q%1%C%H?t$r;;=P(B
		flow = flow + 1
	end

	index_packet_flow[num][0] = num
	index_packet_flow[num][1] = packet
	index_packet_flow[num][2] = flow

	print "==========INDEX", num, "==========", " Frame number ", packet, "\n"
	array_separate_index[num].sort! {|a, b| b[7].to_i <=> a[7].to_i }
	for array_num in 0...4 do #$B3F(Bindex$BKh$K%Q%1%C%H?t>e0L(B4$B0L$N%U%m!<$r=PNO(B
		print array_num, ",", array_separate_index[num][array_num][0], " ", array_separate_index[num][array_num][1], " ", 
			array_separate_index[num][array_num][2], " ", array_separate_index[num][array_num][3], " ",
			array_separate_index[num][array_num][4], " ", array_separate_index[num][array_num][7], "\n"
	end
end

print "\n==========\n"
for num in 0...256 do 
	print "INDEX:", index_packet_flow[num][0], " number:", index_packet_flow[num][1], " flow", index_packet_flow[num][2], "\n"
end
