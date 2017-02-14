#############################################################################################################################
#1$B%Q%1%C%H%U%m!<$r@8@.$9$k(Buser$B$N$&$A(B, $B>e0L(B100$B$N(Buser$B$,@8@.$9$k(B
#1$B%Q%1%C%H%U%m!<$N$_$N(B, $BC10L;~4VJU$j$N%U%m!<?t$NJQ2=$r(Bcsv$B7A<0$G=PNO$9$k%W%m%0%i%`(B
#$BF~NO%U%!%$%k$O(B,
#(1) sort_by_onepacket_top100.out (top100user$B$,(B, user, $B%U%m!<?t$G6h@Z$i$l$F$$$k%U%!%$%k(B)
#(2) onepacketflow_2016****.out (1$B%M%C%H%o!<%/%H%l!<%9%U%!%$%kCf$NA4$F$N(B1$B%Q%1%C%H%U%m!<$N(B5$B%?%W%k$,5-O?$5$l$F$$$k%U%!%$%k(B)
#(3) input_sample_2016****.out (IPv4, TCP$B$*$h$S(BUDP$B$N%Q%1%C%H$r$9$Y$F5-O?$7$F$$$k%U%!%$%k(B)
############################################################################################################################

################################################################
# top100user$B$r(BHash$B$G$"$k(Buser$B$KDI2C$9$k(B
# File.open( 'pra.out' ) do | openfile |
# ARGV[1] = 1packetflowuse_and_number********.out
# ARGV[1]$B$N8uJd$H$7$F$O(B, 100uesr$B$N$_$N$[$&$,Aa$$$+$b$7$l$J$$(B
# ARGV[1] = ./2016****/sort_by_onepacket_top100$B$H$+(B
# $B$=$N>l9g$O(B, line.split(", ")$B$H$9$Y$-(B
user = Hash.new{ 0 }
File.open( ARGV[0], "r" ) do | openfile1 |
	while line = openfile1.gets
		line_split = line.split(", ")
		#line_split[0]$B$K$OAw?.85(BIP$B%"%I%l%9$,F~$k(B
		user[line_split[0]] = 1
	end
end
print "user numnber",  ", ", user.size, "\n"
################################################################


##############################################################################
# (2)$B$N%U%!%$%k$+$i(B, key$B$H$7$F(Buser$B$KEPO?$5$l$F$$$k(Btop100$B$N(Buser, 
# value$B$H$7$F(B1$B%Q%1%C%H%U%m!<$G$"$k%U%m!<$H$$$&>pJs$r;}$D(BHash$B$r:n@.(B
# pair_1packetflow_user[key][value] = 1$B$N$H$-EPO?(B, = 0 $B$N$H$-L$EPO?$H$J$k(B
t100u_1packetflow = Hash.new{ |hash, key| hash[key] = Hash.new{ 0 } }
File.open( ARGV[1], "r" ) do | openfile2 |
	while line = openfile2.gets
		#5$B%?%W%k$NCM$O6uGr$G6h@Z$i$l$F$$$k(B
		line_split = line.split(" ")
		flow_id = line_split[0] + " " + line_split[1] + " " + line_split[2] + " " + line_split[3] + " " + line_split[4]
		if user[line_split[0]] == 1 then 
			t100u_1packetflow[line_split[0]][flow_id] = 1
		end
	end
end
print "1packetflow", ", ", t100u_1packetflow.size, "\n"
#############################################################################


#############################################################################
# (3)$B$N%U%!%$%k$r3+$-(B, 
# [1] : top100$B$N(Buser$B$,@8@.$7$?%U%m!<(B
# [2] : top100$B$N(Buser$B$,@8@.$7$?%U%m!<$N$&$A(B, 1$B%Q%1%C%H%U%m!<(B
# $B$N(B, $BC10L;~4VJU$j$NA+0\$r5a$a$k(B

time = 1.0
# (3)$B$N%U%!%$%kCf$K2?%U%m!<$"$k$+$r5-O?$9$k(Bhash, key$B$H$7$F(Bflow_id, value$B$H$7$F(B1($B$"$k(B), 0($B$J$$(B)$B$r;}$D(B
total_flow = Hash.new{ 0 }

# $BC10L;~4VJU$j$KA4BN$G2?%U%m!<$,Aw$i$l$F$$$k$+$r5-O?$9$k(B
# ~~[key] = value, key:flow_id, value:1($BEPO?$7$?(B), 0($BL$EPO?(B)
total_per_second_flow = Hash.new{ 0 }

# $BC10L;~4V$"$?$j$KA4BN$G2?%U%m!<@8@.$5$l$F$$$k$+$r;~9o$4$H$K5-O?$9$k(B
# ~~[key] = value, key:$B;~9o(B, value:$BC10L;~4VJU$j$N%U%m!<?t(B
total_fn_ptime = Hash.new{ 0 }

# (3)$B$N%U%!%$%kCf$K2?(Buser$B$$$k$+$r5-O?$9$k(Bhash, key$B$H$7$F(Bline_split[0], value$B$H$7$F(B1($B$"$k(B), 0($B$J$$(B)$B$r;}$D(B
total_user = Hash.new{ 0 }

# top100$B$N(Buser$B$,C10L;~4VJU$j2?%U%m!<@8@.$7$F$$$k$N$+$r%+%&%s%H$9$k(B
# t100u_flow[key1][key2] = value$B$H$J$k(B
# key1$B$K$O(Buser$B$KEPO?$5$l$F$$$k(Buse, key2$B$K$O(Bflow_id, value$B$H$7$F@0?tCM$,M?$($i$l$k(B, 0($B$J$$(B), n(n$B%Q%1%C%H%U%m!<(B, n$B$O@0?tCM(B)
t100u_flow = Hash.new{ |hash, key| hash[key] = Hash.new{ 0 } }

# top100user$B$G$O$J$$(Buser$B$,(B, $BC10L;~4VJU$j$K@8@.$9$k%U%m!<?t$r%+%&%s%H$9$k(B
n1puser_flow = Hash.new{ 0 }

# top100user$B0J30$N(Buser$B$,@8@.$7$?%U%m!<?t$r?t$($k(B
n1puser_flownum = Hash.new{ 0 } 

# top100user$B$G$O$J$$(Buser$B$,(B, $BC10L;~4VJU$j$K@8@.$9$k%U%m!<?t$r;~9oKh$K5-O?$9$k(B
# ~~[key1] = value, key1$B$K$O;~9o(B, value$B$K$O%U%m!<?t$,M?$($i$l$k(B
n1puser_fn_ptime = Hash.new{ 0 }

# top100$B$N(Buser$B$N$&$A(B, 1$B%Q%1%C%H%U%m!<$N$_$G(B, 
# $BC10L;~4V$"$?$j$K2?%U%m!<$r@8@.$7$F$$$k$+$r%+%&%s%H$9$k(Bhash
# t100u_only1fn_ptime[key1][key2] = value, key1$B$H$7$F(Buser$B$KEPO?$5$l$F$$$k(Buser, key2$B$H$7$F(Bt100u_1packetflow$B$KEPO?$5$l$F$$$k(Bflow_id,
# value$B$H$7$F(B1($B$"$C$?(B)
t100u_only1p_flow = Hash.new{ |hash, key| hash[key] = Hash.new{ 0 } }

# $B3F(Btop100user$BKh$N(B, 1$B%Q%1%C%H%U%m!<$N?t$r%+%&%s%H$9$k(B
# ~[key] = value, key:user, value:$B%U%m!<?t(B
t100u_only1pflownum = Hash.new{ 0 }

# $B3F;~9o$G$N%U%m!<?t$r5-O?$9$k(Bhash
# ~~[key1][key2] = value, key1:top100user, key2:$B;~9o(B, value:1$B%Q%1%C%H%U%m!<?t(B
t100u_only1fn_ptime = Hash.new{ |hash, key| hash[key] = Hash.new{ 0 } }

# top100user$B$,@8@.$9$k(B1$B%Q%1%C%H%U%m!<?t(B
t100u_only1pflownumall = 0

# top100user$B$,C10L;~4VJU$j$K@8@.$7$?(B1$B%Q%1%C%H%U%m!<$N%U%m!<?t$r5-O?$9$k(B
# [key] = value, key:$B;~9o(B, value:$BC10L;~4VJU$j$N(B1$B%Q%1%C%H%U%m!<$N%U%m!<?t(B
t100uall_only1fn_ptime = Hash.new{ 0 }

# t100u_only1fn_ptime$B$H$[$\F10l(B, 1$B%Q%1%C%H%U%m!<$G$J$$>l9gMQ(B
# ~~[key1][key2] = value, key1:top100user, key2:$B;~9o(B, value:1$B%Q%1%C%H%U%m!<$G$J$$%U%m!<?t(B
t100u_not1p_flow = Hash.new{ |hash, key| hash[key] = Hash.new{ 0 } }

# top100user$B$,C10L;~4VJU$j$K@8@.$7$?(B, 1$B%Q%1%C%H0J>e$G9=@.$5$l$k%U%m!<?t$NA+0\?t$r5-O?$9$k(B
# [key1][key2] = value, key1:user, key2:$B;~9o(B, value:$BC10L;~4VJU$j$K@8@.$5$l$?%U%m!<?t(B
t100u_not1fn_ptime = Hash.new{ |hash, key| hash[key] = Hash.new{ 0 } }

# top100user$B$,@8@.$7$?(B, 1$B%Q%1%C%H0J>e$G9=@.$5$l$k%U%m!<$r5-O?$9$k(B
t100u_not1p_flownum = Hash.new{ |hash, key| hash[key] = Hash.new{ 0 } }

# $BA4%U%m!<$+$i(B, top100user$B$,@8@.$7$?(B1$B%Q%1%C%H%U%m!<$N$_$r=|30$7$?$H$-$N(B
# $BC10L;~4VJU$j$N%U%m!<?t$r5-O?$9$k(B
# [key] = value, key:$B;~4V(B, value:top100user$B$,@8@.$7$?(B1$B%Q%1%C%H%U%m!<$N$_$r=|30$7$?$H$-$N%U%m!<?t(B
n_top100u_1pfn_ptime = Hash.new{ 0 }
fivetaple = String.new
tmp = 0
# ARGV[2] = ../../caputer/input_sample_*****
File.open( ARGV[2], "r" ) do | openfile2 |
	while line = openfile2.gets
		line_split = line.split(" ")
		flow_id = line_split[0] + " " + line_split[1] + " " + line_split[2] + " " + line_split[3] + " " + line_split[4]
		
		total_flow[flow_id] = 1
		total_user[line_split[0]] = 1

		# user$BKh$K$$$/$D$N%U%m!<$r@8@.$7$F$$$k$+$r7W;;$9$k(B
		if user[line_split[0]]  == 1 then 
			t100u_flow[line_split[0]][flow_id] = t100u_flow[line_split[0]][flow_id] + 1
		end

		if time >= line_split[5].to_i then 
			if user[line_split[0]] == 1 then
				# $BAw?.85$,(B, top100user$B$NC/$+$G$"$k>l9g(B
				if t100u_1packetflow[line_split[0]][flow_id] == 1 then 
					# top100user$B$,Aw$C$?%U%m!<$N$&$A(B, 1$B%Q%1%C%H%U%m!<$G$"$C$?>l9g(B
					t100u_only1p_flow[line_split[0]][flow_id] = 1 #[1]
					t100u_only1pflownum[line_split[0]] = t100u_only1pflownum[line_split[0]] + 1
					t100u_only1pflownumall = t100u_only1pflownumall + 1
				else
					# top100user$B$,@8@.$7$?%U%m!<$N$&$A(B, 1$B%Q%1%C%H0J>e$G9=@.$5$l$?%U%m!<$N>l9g(B
					t100u_not1p_flow[line_split[0]][flow_id] = 1 #[2]
					t100u_not1p_flownum[line_split[0]][flow_id] = 1
				end
				# t100user$B$N(B1$B%Q%1%C%H%U%m!<$H(B, $B$=$&$G$J$$%U%m!<$I$A$i$b%+%&%s%H$9$k(B([1].size + [2].size)
				t100u_flow[line_split[0]][flow_id] = 1
			elsif user[line_split[0]] == 0 then 
				# top100user$B$,@8@.$7$?%U%m!<$G$J$$>l9g(B
				n1puser_flow[flow_id] = 1
				n1puser_flownum[flow_id] = n1puser_flownum[flow_id] + 1
			end
		
			# $B%U%m!<A4BN(B
			total_per_second_flow[flow_id] = 1

		elsif time < line_split[5].to_i then
			# time$B$^$G$K2?%U%m!<$-$F$$$k$+$r5-O?$9$k(B
			# $B$9$Y$F$N(Buser$B$,(B1$BIC4V$"$?$j$K2?%U%m!<Aw$C$F$-$F$$$k$+(B
			total_fn_ptime[time.to_i] = total_per_second_flow.size
			total_per_second_flow.clear
			total_per_second_flow[flow_id] = 1

			# $B85$N%U%m!<$+$i(B, top100user$B$N%U%m!<$r=|30$7$?>l9g$N(B
			# $BC10L;~4VJU$j$N%U%m!<?t$NJQ2=$r5-O?$9$k(B
			n1puser_fn_ptime[time.to_i] = n1puser_flow.size	
			n1puser_flow.clear
		
			# top100user, 1$B%Q%1%C%H%U%m!<5Z$S$=$NB>%U%m!<$9$Y$F(B
#			t100u_flow.each{|key,value|
	#			t100u_fn_ptime[key][time.to_i] = value.size
		#		#value$B$NMWAG?t$r(B0$B$K$9$k(B
			#	value.clear
			#}

			#top100user, 1$B%Q%1%C%H%U%m!<$N$_(B
			t100u_only1p_flow.each{|key, value|
				t100u_only1fn_ptime[key][time.to_i] = value.size
				tmp = tmp + value.size
				value.clear
			}

			# $B85$N%U%m!<$+$i(B, top100user$B$,@8@.$7$?(B1$B%Q%1%C%H%U%m!<$r=|30$7$?>l9g$N(B
			# $BC10L;~4VJU$j$N%U%m!<?t$NJQ2=$r5-O?$9$k(B
			n_top100u_1pfn_ptime[time.to_i] = total_fn_ptime[time.to_i] - tmp
			tmp = 0
	

			#top100user, 1$B%Q%1%C%H0J>e$G9=@.$5$l$?%U%m!<$N?t(B
		#	t100u_not1p_flow{|key, value|
		#		t100u_not1fn_ptime[key][time.to_i] = value.size
		#		value.clear
		#	}

			#total_per_second$B$NMWAG$r(B0$B$K$9$k(B

			if user[line_split[0]] == 1 then
				t100u_flow[line_split[0]][flow_id] = 1
				if t100u_1packetflow[line_split[0]][flow_id] == 1 then 
					t100u_only1p_flow[line_split[0]][flow_id] = 1
					t100u_only1pflownum[line_split[0]] = t100u_only1pflownum[line_split[0]] + 1
				else 
					t100u_not1p_flow[line_split[0]][flow_id] = 1
					t100u_not1p_flownum[line_split[0]][flow_id] = 1
				end
			elsif user[line_split[0]] == 0 then 
				n1puser_flow[flow_id] = 1
			end
			#print time, "\n"
			time = time + 1
			fivetaple = flow_id
		end		
	end
end		
#--------------------------------------------------------#
# $B:G8e(B900$BIC$r2a$.$?8e$N%U%m!<?t$O@5$7$/%+%&%s%H$5$l$J$$$?$a(B
total_fn_ptime[time.to_i] = total_per_second_flow.size
total_per_second_flow.clear
total_per_second_flow[fivetaple] = 1

# mice$B%U%m!<$r@8@.$7$F$$$J$$(Buser$B$,@8@.$7$?%U%m!<?t(Bper$BIC(B
n1puser_fn_ptime[time.to_i] = n1puser_flow.size	
n1puser_flow.clear

# top100user, 1$B%Q%1%C%H%U%m!<5Z$S$=$NB>%U%m!<$9$Y$F(B
#			t100u_flow.each{|key,value|
#			t100u_fn_ptime[key][time.to_i] = value.size
#		#value$B$NMWAG?t$r(B0$B$K$9$k(B
#	value.clear
#}

# top100user, 1$B%Q%1%C%H%U%m!<$N$_(B
t100u_only1p_flow.each{|key, value|
	t100u_only1fn_ptime[key][time.to_i] = value.size
	tmp = tmp + value.size
	value.clear
}
n_top100u_1pfn_ptime[time.to_i] = total_fn_ptime[time.to_i] - tmp
#--------------------------------------------------------#
##########################################################################


###########################################################################
total_flow_num = total_flow.size.to_f
print "flow total:", total_flow_num, "\n"
print "user total:", total_user.size, "\n"

# top100user$B$,@8@.$7$?(B1$B%Q%1%C%H%U%m!<$NC10L;~4VJU$j$NA+0\?t$r=PNO$9$k(B
t100u_only1fn_ptime.each{|key, value|
	# $B%k!<%?$,%Q%1%C%H$N<}=8$r3+;O$7$?;~9o(B($B$O$8$a$O(B0~1$BIC(B)
	print key, ", ", t100u_only1pflownum[key], "  ", t100u_not1p_flownum[key].size, ", "
	# 15$BJ,4V%Q%1%C%H%-%c%W%A%c$r9T$C$F$$$k$N$G(B, 900$BIC(B
	for time in 1...901 do
		print value[time], ", "
	end
	print "\n"
}
print "\n"

# $BA4%U%m!<$N(B, 1$BICJU$j$N%U%m!<?t$r=PNO$9$k(B
print "all", ", ", total_flow_num, ", "
for time in 1...901 do
	print total_fn_ptime[time], ", "
end
print "\n"

# $BA4%U%m!<$+$i(B, top100user$B$N@8@.$9$k%U%m!<$9$Y$F$r=|30$7$?$H$-$N(B, $BICJU$j$N%U%m!<?t(B
print "not top100user flow", ", ", n1puser_flownum.size, ", "
for time in 1...901 do
	print n1puser_fn_ptime[time], ", "
end
print "\n"

# $BA4%U%m!<$+$i(B, 1top100user$B$,@8@.$9$k(B1$B%Q%1%C%H%U%m!<$N$_$r=|30$7$?$H$-$N(B, $BIC$"$?$j$N%U%m!<?t(B
print "not 1pflow of top100user ", ", ", total_flow_num - t100u_only1pflownumall, ", "
for time in 1...901 do
	print n_top100u_1pfn_ptime[time], ", "
end
print "\n"
##print packet, "\n"
