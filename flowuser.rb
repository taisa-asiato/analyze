#index$BKh$K(B, $B%U%m!<$N?t$r%+%&%s%H(B
flow = Hash.new{ |hash, key| hash[key] = Hash.new{ 0 } }

#File.open( 'pra.out' ) do | openfile |
File.open( '../../caputer/input_sample_2016.txt' ) do | openfile |
		while line = openfile.gets
		line_split = line.split(" ")

		#flow id $B$N:n@.(B
		flow_id = line_split[0] + " " + line_split[1] + " " + line_split[2] + " " + line_split[3] + " " + line_split[4]

		#flow id$B$4$H$KO"A[G[Ns$r:n@.$9$k(B
		flow[line_split[0]][flow_id] = flow[line_split[0]][flow_id] + 1;
	end
end

#puts flow.length
flow.each{|key, value| 
	print key, " ", value.length, "\n"
	value.each{|key1, value1|
		print key1, " ", value1, "\n"
	}
}
