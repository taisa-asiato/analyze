#index$BKh$K(B, $B%U%m!<$N?t$r%+%&%s%H(B
flow = Hash.new( 0 )
#File.open( 'pra.out' ) do | openfile |
#input file is ./mice_***packet***.out
File.open( ARGV[0] ) do | openfile |
		while line = openfile.gets
			line_split = line.split(" ")
	
			#flow id $B$N:n@.(B
			flow_id = line_split[0];
	
			#flow id$B$4$H$KO"A[G[Ns$r:n@.$9$k(B
			#$BO"A[G[Ns$O(B, $B$3$N(Bflow_id$B$,$$$/$D$N#1%Q%1%C%H%U%m!<$rAw?.$7$F$-$?$+$r<($9(B
			flow[flow_id] = flow[flow_id] + 1;
		end
end

#hash$B$r(Barray$B$KJQ49(B
flow = flow.to_a
#$BG[Ns$NFsHVL\$NMWAGF1;N$GHf3S(B, 
flow.sort!{|k1, k2| k2[0] <=> k1[0] }

for i in 0...flow.length do 
	print flow[i][0], " ", flow[i][1], "\n"
end
