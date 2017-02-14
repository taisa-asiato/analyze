#index$BKh$K(B, $B%U%m!<$N?t$r%+%&%s%H(B
user = Hash.new{ 0 }

#File.open( 'pra.out' ) do | openfile |
#ARGV[1] = 1packetflowuse_and_number********.out
#ARGV[1]$B$N8uJd$H$7$F$O(B, 100uesr$B$N$_$N$[$&$,Aa$$$+$b$7$l$J$$(B
#ARGV[1] = ./2016****/sort_by_onepacket_top100$B$H$+(B
#$B$=$N>l9g$O(B, line.split(", ")$B$H$9$Y$-(B
File.open( ARGV[0], "r" ) do | openfile |
	while line = openfile.gets
		line_split = line.split(", ")
		#line_split[0]$B$K$OAw?.85(BIP$B%"%I%l%9$,F~$k(B
		user[line_split[0]] = 1
	end
end
print "user numnber==",  user.size, "==\n"
#$BMWAG$H$7$F;~9o$rJ];}$9$kG[Ns$r;}$D(BHash$B$N:n@.(B, flow$B$N(Bid$B$K$h$k(B
flow = Hash.new{|hash, key| hash[key] = Hash.new{ 0 } }
#user$B8DJ,(B, $B$=$N(Buser$B$,:G8e$K$$$D%Q%1%C%H$rAw$C$?$N$+5-21$9$kG[Ns$r:n@.(B
user_time = Hash.new{|hash, key| hash[key] = Hash.new{ 0 } }

#$B%H%l!<%9%U%!%$%kCfA4BN$N%U%m!<$N>pJs$rF~$l$k(B
total_flow = Hash.new{ 0 } 
#$B%H%l!<%9%U%!%$%kCfA4BN$N(Buser$B$N>pJs$rF~$l$k(B
total_user = Hash.new{ 0 }
#user$B$4$H$K$$$/$D$N%U%m!<$r@8@.$7$?$N$+$r5-O?$9$k(Bhash
user_flow = Hash.new{ |hash, key| hash[key] = Hash.new{ 0 } }

#$BA4%U%m!<$r5-O?$9$k(B
total_per_second = Hash.new{ 0 }
#1$BIC4V$KAw?.$5$l$k%U%m!<$NAm?t$r5-O?$9$k(B
total_flow_time = Hash.new{ 0 }

#mice user$B$G$O$J$$$b$N(B
not_mice_user_flow = Hash.new{ 0 }
not_mice_flow_time = Hash.new{ 0 }


#$B%Q%1%C%H%-%c%W%A%c3+;O$+$i$N;~9o(B
time = 1.0
packet = 0
#ARGV[2] = ../../caputer/input_sample_*****
File.open( ARGV[1], "r" ) do | openfile2 |
	while line = openfile2.gets
		line_split = line.split(" ")
		flow_id = line_split[0] + " " + line_split[1] + " " + line_split[2] + " " + line_split[3] + " " + line_split[4]
		
		total_flow[flow_id] = 1
		total_user[line_split[0]] = 1

		#user$BKh$K$$$/$D$N%U%m!<$r@8@.$7$F$$$k$+$r7W;;$9$k(B
		if user[line_split[0]]  == 1 then 
			user_flow[line_split[0]][flow_id] = user_flow[line_split[0]][flow_id] + 1
		end

		if time >= line_split[5].to_i then 
			if user[line_split[0]] == 1 then
				#1packet$B$N%U%m!<$r@8@.$7$F$$$k(Buser$B$N>l9g$N=hM}(B
				flow[line_split[0]][flow_id] = 1
			elsif user[line_split[0]] == 0 then 
				#1packet$B%U%m!<$r@8@.$7$F$$$J$$(Buser$B$N>l9g(B
				not_mice_user_flow[flow_id] = 1
			end
		
			#$B%U%m!<A4BN(B
			total_per_second[flow_id] = 1
		elsif time < line_split[5].to_i then
			#time$B$^$G$K2?%U%m!<$-$F$$$k$+$r5-O?$9$k(B
			total_flow_time[time.to_i] = total_per_second.size
			#mice$B%U%m!<$r@8@.$7$F$$$J$$(Buser$B$,@8@.$7$?%U%m!<?t(Bper$BIC(B
			not_mice_flow_time[time.to_i] = not_mice_user_flow.size
	#		print time, "\n"
			flow.each{|key,value|
				user_time[key][time.to_i] = value.size
				#value$B$NMWAG?t$r(B0$B$K$9$k(B
				value.clear
			}
			#total_per_second$B$NMWAG$r(B0$B$K$9$k(B
			total_per_second.clear
			total_per_second[flow_id] = 1

			#mice user$B$G$O$J$$(Buser
			not_mice_user_flow.clear
			if user[line_split[0]] == 1 then
				flow[line_split[0]][flow_id] = 1
			elsif user[line_split[0]] == 0 then 
				not_mice_user_flow[flow_id] = 1
			end
			time = time + 1
		end		
	end
end		

total_flow_num = total_flow.size.to_f
print "flow total:", total_flow_num, "\n"
print "user total:", total_user.size, "\n"

user_time.each{|key, value|
	#$B%k!<%?$,%Q%1%C%H$N<}=8$r3+;O$7$?;~9o(B($B$O$8$a$O(B0~1$BIC(B)
	print key, ", ", user_flow[key].size, ", "
	#15$BJ,4V%Q%1%C%H%-%c%W%A%c$r9T$C$F$$$k$N$G(B, 900$BIC(B
	for time in 1...900 do
		print value[time], ", "
	end
	print "\n"
}
print "\n"

#$BA4%U%m!<$N(B, 1$BICJU$j$N%U%m!<?t$r=PNO$9$k(B
print "all", ", ", total_flow_num, ", "
for time in 1...900 do
	print total_flow_time[time], ", "
end
print "\n"

#1packet$B$r@8@.$7$J$$(Buser$B$NAw?.$9$k(B1$BICJU$j$N%U%m!<?t(B
print "not mice user", ", ", "not count", ", "
for time in 1...900 do
	print not_mice_flow_time[time], ", "
end
print "\n"
#print packet, "\n"
