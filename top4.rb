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
	line_split = line.split(", ")
	num = line_split[8].to_i
	#flow id $B$N:n@.(B
	flow_id = line_split[1] + "-" + line_split[2] + "-" + line_split[3] + "-" + line_split[4] + "-" + line_split[5]
	#flow id$B$4$H$KO"A[G[Ns$r:n@.$9$k(B
	flow[num][flow_id] = flow[num][flow_id] + 1
	#index$BKh$N%Q%1%C%H?t$r%+%&%s%H(B		
	end
end

for i in 0...256 do
	#$B8e$N2C9)$N$70B$5$r9M$($F(B, $B%$%s%G%C%/%9Kh%=!<%H$5$l$?(B, $B#19T$N0l$D$N%U%m!<$r=PNO$9$k$h$&$K$9$k(B
	#index$BKh$K>e0L(B4$B%U%m!<$r=PNO(B
	flow_array = flow[i].sort{|a, b| b[1]<=>a[1] }
	for j in 0...4 do
		tmp_flow = flow_array[j][0].split("-")
		print tmp_flow[0], " ", tmp_flow[1], " ", tmp_flow[2], " ", tmp_flow[3], " ", tmp_flow[4], "\n"
	end
end
