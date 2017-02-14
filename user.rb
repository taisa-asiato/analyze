#index$BKh$K(B, $B%U%m!<$N?t$r%+%&%s%H(B
user = Hash.new{ 0 }

#File.open( 'pra.out' ) do | openfile |
#ARGV[1] = 1packetflowuse_and_number********.out
File.open( ARGV[0], "r" ) do | openfile |
	while line = openfile.gets
		line_split = line.split(" ")

	#	flownumber = line_split[1].to_i
		#1packet flow$B$r(B1000$B0J>e@8@.$7$F$$$k(Buser$B$rO"A[G[Ns$KEPO?(B
	#	if flownumber >= 1000 then
		user[line_split[0]] = 1
		
	end
end

#$BB?<!85(Bhash$B$N@k8@(B, 1packetflow$B$r@8@.$9$k(Buser$B$,@8@.$9$k(B1$B%Q%1%C%H$N%U%m!<$H$=$&$G$J$$%U%m!<$N?t$r7W;;$9$k(B
flow = Hash.new{ | hash, key | hash[key] = Hash.new{ 0 } }
#$B%H%l!<%9%U%!%$%kCfA4BN$N%U%m!<$N?t$r7W;;$9$k(B
total_flow = Hash.new{ 0 } 
#$B%H%l!<%9%U%!%$%kCfA4BN$N(Buser$B$N?t$r7W;;$9$k(B
total_user = Hash.new{ 0 }

#ARGV[2] = ../../caputer/input_sample_*****
File.open( ARGV[1], "r" ) do | openfile2 |
	while line = openfile2.gets
		line_split = line.split(" ")
		flow_id = line_split[0] + " " + line_split[1] + " " + line_split[2] + " " + line_split[3] + " " + line_split[4]
		
		total_flow[flow_id] = 1
		total_user[line_split[0]] = 1

		if user[line_split[0]] == 1 then 
			#1packet$B$N%U%m!<$r@8@.$7$F$$$k(Buser$B$N>l9g$N=hM}(B		
			#flow[line_split[0]][flow_id]$B$NCM$O(B, user$B$G$"$k(Bline_split[0]$B$,@8@.$7$?(Bflow_id$B%U%m!<$,2?(Bpacket$B$G9=@.$5$l$F$$$k$+$rI=$9(B
			flow[line_split[0]][flow_id] = flow[line_split[0]][flow_id] + 1
		end
	end
end		

total_flow_num = total_flow.size.to_f
print "=====flow total : ", total_flow_num, "\n"
print "=====user total : ", total_user.size, "\n"
#puts flow.length
flow.each{|key, value|
	onepacketflow = 0
	overonepacketflow = 0
	onepacketnumber = 0
	o1packetnumber = 0
	print key, ", "
	value.each{|key1, value1|
		if value1 == 1 then 
			onepacketflow = onepacketflow + 1
			onepacketnumber = onepacketnumber + value1
		elsif value1 > 1 then 
			overonepacketflow = overonepacketflow + 1
			o1packetnumber = o1packetnumber + value1 
		end
	}
	print onepacketflow, ", ", overonepacketflow, ", ", onepacketnumber, ", ", o1packetnumber, ", ", onepacketflow/total_flow_num, ", ", overonepacketflow/total_flow_num, "\n"
}
