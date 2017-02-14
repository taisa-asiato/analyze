#############################################################################################################################
#1パケットフローを生成するuserのうち, 上位100のuserが生成する
#1パケットフローのみの, 単位時間辺りのフロー数の変化をcsv形式で出力するプログラム
#入力ファイルは,
#(1) sort_by_onepacket_top100.out (top100userが, user, フロー数で区切られているファイル)
#(2) onepacketflow_2016****.out (1ネットワークトレースファイル中の全ての1パケットフローの5タプルが記録されているファイル)
#(3) input_sample_2016****.out (IPv4, TCPおよびUDPのパケットをすべて記録しているファイル)
############################################################################################################################

################################################################
# top100userをHashであるuserに追加する
# File.open( 'pra.out' ) do | openfile |
# ARGV[1] = 1packetflowuse_and_number********.out
# ARGV[1]の候補としては, 100uesrのみのほうが早いかもしれない
# ARGV[1] = ./2016****/sort_by_onepacket_top100とか
# その場合は, line.split(", ")とすべき
user = Hash.new{ 0 }
File.open( ARGV[0], "r" ) do | openfile1 |
	while line = openfile1.gets
		line_split = line.split(", ")
		#line_split[0]には送信元IPアドレスが入る
		user[line_split[0]] = 1
	end
end
print "user numnber",  ", ", user.size, "\n"
################################################################


##############################################################################
# (2)のファイルから, keyとしてuserに登録されているtop100のuser, 
# valueとして1パケットフローであるフローという情報を持つHashを作成
# pair_1packetflow_user[key][value] = 1のとき登録, = 0 のとき未登録となる
t100u_1packetflow = Hash.new{ |hash, key| hash[key] = Hash.new{ 0 } }
File.open( ARGV[1], "r" ) do | openfile2 |
	while line = openfile2.gets
		#5タプルの値は空白で区切られている
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
# (3)のファイルを開き, 
# [1] : top100のuserが生成したフロー
# [2] : top100のuserが生成したフローのうち, 1パケットフロー
# の, 単位時間辺りの遷移を求める

time = 1.0
# (3)のファイル中に何フローあるかを記録するhash, keyとしてflow_id, valueとして1(ある), 0(ない)を持つ
total_flow = Hash.new{ 0 }

# 単位時間辺りに全体で何フローが送られているかを記録する
# ~~[key] = value, key:flow_id, value:1(登録した), 0(未登録)
total_per_second_flow = Hash.new{ 0 }

# 単位時間あたりに全体で何フロー生成されているかを時刻ごとに記録する
# ~~[key] = value, key:時刻, value:単位時間辺りのフロー数
total_fn_ptime = Hash.new{ 0 }

# (3)のファイル中に何userいるかを記録するhash, keyとしてline_split[0], valueとして1(ある), 0(ない)を持つ
total_user = Hash.new{ 0 }

# top100のuserが単位時間辺り何フロー生成しているのかをカウントする
# t100u_flow[key1][key2] = valueとなる
# key1にはuserに登録されているuse, key2にはflow_id, valueとして整数値が与えられる, 0(ない), n(nパケットフロー, nは整数値)
t100u_flow = Hash.new{ |hash, key| hash[key] = Hash.new{ 0 } }

# top100userではないuserが, 単位時間辺りに生成するフロー数をカウントする
n1puser_flow = Hash.new{ 0 }

# top100user以外のuserが生成したフロー数を数える
n1puser_flownum = Hash.new{ 0 } 

# top100userではないuserが, 単位時間辺りに生成するフロー数を時刻毎に記録する
# ~~[key1] = value, key1には時刻, valueにはフロー数が与えられる
n1puser_fn_ptime = Hash.new{ 0 }

# top100のuserのうち, 1パケットフローのみで, 
# 単位時間あたりに何フローを生成しているかをカウントするhash
# t100u_only1fn_ptime[key1][key2] = value, key1としてuserに登録されているuser, key2としてt100u_1packetflowに登録されているflow_id,
# valueとして1(あった)
t100u_only1p_flow = Hash.new{ |hash, key| hash[key] = Hash.new{ 0 } }

# 各top100user毎の, 1パケットフローの数をカウントする
# ~[key] = value, key:user, value:フロー数
t100u_only1pflownum = Hash.new{ 0 }

# 各時刻でのフロー数を記録するhash
# ~~[key1][key2] = value, key1:top100user, key2:時刻, value:1パケットフロー数
t100u_only1fn_ptime = Hash.new{ |hash, key| hash[key] = Hash.new{ 0 } }

# top100userが生成する1パケットフロー数
t100u_only1pflownumall = 0

# top100userが単位時間辺りに生成した1パケットフローのフロー数を記録する
# [key] = value, key:時刻, value:単位時間辺りの1パケットフローのフロー数
t100uall_only1fn_ptime = Hash.new{ 0 }

# t100u_only1fn_ptimeとほぼ同一, 1パケットフローでない場合用
# ~~[key1][key2] = value, key1:top100user, key2:時刻, value:1パケットフローでないフロー数
t100u_not1p_flow = Hash.new{ |hash, key| hash[key] = Hash.new{ 0 } }

# top100userが単位時間辺りに生成した, 1パケット以上で構成されるフロー数の遷移数を記録する
# [key1][key2] = value, key1:user, key2:時刻, value:単位時間辺りに生成されたフロー数
t100u_not1fn_ptime = Hash.new{ |hash, key| hash[key] = Hash.new{ 0 } }

# top100userが生成した, 1パケット以上で構成されるフローを記録する
t100u_not1p_flownum = Hash.new{ |hash, key| hash[key] = Hash.new{ 0 } }

# 全フローから, top100userが生成した1パケットフローのみを除外したときの
# 単位時間辺りのフロー数を記録する
# [key] = value, key:時間, value:top100userが生成した1パケットフローのみを除外したときのフロー数
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

		# user毎にいくつのフローを生成しているかを計算する
		if user[line_split[0]]  == 1 then 
			t100u_flow[line_split[0]][flow_id] = t100u_flow[line_split[0]][flow_id] + 1
		end

		if time >= line_split[5].to_i then 
			if user[line_split[0]] == 1 then
				# 送信元が, top100userの誰かである場合
				if t100u_1packetflow[line_split[0]][flow_id] == 1 then 
					# top100userが送ったフローのうち, 1パケットフローであった場合
					t100u_only1p_flow[line_split[0]][flow_id] = 1 #[1]
					t100u_only1pflownum[line_split[0]] = t100u_only1pflownum[line_split[0]] + 1
					t100u_only1pflownumall = t100u_only1pflownumall + 1
				else
					# top100userが生成したフローのうち, 1パケット以上で構成されたフローの場合
					t100u_not1p_flow[line_split[0]][flow_id] = 1 #[2]
					t100u_not1p_flownum[line_split[0]][flow_id] = 1
				end
				# t100userの1パケットフローと, そうでないフローどちらもカウントする([1].size + [2].size)
				t100u_flow[line_split[0]][flow_id] = 1
			elsif user[line_split[0]] == 0 then 
				# top100userが生成したフローでない場合
				n1puser_flow[flow_id] = 1
				n1puser_flownum[flow_id] = n1puser_flownum[flow_id] + 1
			end
		
			# フロー全体
			total_per_second_flow[flow_id] = 1

		elsif time < line_split[5].to_i then
			# timeまでに何フローきているかを記録する
			# すべてのuserが1秒間あたりに何フロー送ってきているか
			total_fn_ptime[time.to_i] = total_per_second_flow.size
			total_per_second_flow.clear
			total_per_second_flow[flow_id] = 1

			# 元のフローから, top100userのフローを除外した場合の
			# 単位時間辺りのフロー数の変化を記録する
			n1puser_fn_ptime[time.to_i] = n1puser_flow.size	
			n1puser_flow.clear
		
			# top100user, 1パケットフロー及びその他フローすべて
#			t100u_flow.each{|key,value|
	#			t100u_fn_ptime[key][time.to_i] = value.size
		#		#valueの要素数を0にする
			#	value.clear
			#}

			#top100user, 1パケットフローのみ
			t100u_only1p_flow.each{|key, value|
				t100u_only1fn_ptime[key][time.to_i] = value.size
				tmp = tmp + value.size
				value.clear
			}

			# 元のフローから, top100userが生成した1パケットフローを除外した場合の
			# 単位時間辺りのフロー数の変化を記録する
			n_top100u_1pfn_ptime[time.to_i] = total_fn_ptime[time.to_i] - tmp
			tmp = 0
	

			#top100user, 1パケット以上で構成されたフローの数
		#	t100u_not1p_flow{|key, value|
		#		t100u_not1fn_ptime[key][time.to_i] = value.size
		#		value.clear
		#	}

			#total_per_secondの要素を0にする

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
# 最後900秒を過ぎた後のフロー数は正しくカウントされないため
total_fn_ptime[time.to_i] = total_per_second_flow.size
total_per_second_flow.clear
total_per_second_flow[fivetaple] = 1

# miceフローを生成していないuserが生成したフロー数per秒
n1puser_fn_ptime[time.to_i] = n1puser_flow.size	
n1puser_flow.clear

# top100user, 1パケットフロー及びその他フローすべて
#			t100u_flow.each{|key,value|
#			t100u_fn_ptime[key][time.to_i] = value.size
#		#valueの要素数を0にする
#	value.clear
#}

# top100user, 1パケットフローのみ
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

# top100userが生成した1パケットフローの単位時間辺りの遷移数を出力する
t100u_only1fn_ptime.each{|key, value|
	# ルータがパケットの収集を開始した時刻(はじめは0~1秒)
	print key, ", ", t100u_only1pflownum[key], "  ", t100u_not1p_flownum[key].size, ", "
	# 15分間パケットキャプチャを行っているので, 900秒
	for time in 1...901 do
		print value[time], ", "
	end
	print "\n"
}
print "\n"

# 全フローの, 1秒辺りのフロー数を出力する
print "all", ", ", total_flow_num, ", "
for time in 1...901 do
	print total_fn_ptime[time], ", "
end
print "\n"

# 全フローから, top100userの生成するフローすべてを除外したときの, 秒辺りのフロー数
print "not top100user flow", ", ", n1puser_flownum.size, ", "
for time in 1...901 do
	print n1puser_fn_ptime[time], ", "
end
print "\n"

# 全フローから, 1top100userが生成する1パケットフローのみを除外したときの, 秒あたりのフロー数
print "not 1pflow of top100user ", ", ", total_flow_num - t100u_only1pflownumall, ", "
for time in 1...901 do
	print n_top100u_1pfn_ptime[time], ", "
end
print "\n"
##print packet, "\n"
