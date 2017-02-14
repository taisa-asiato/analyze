#index毎に, フローの数をカウント
user = Hash.new{ 0 }

#File.open( 'pra.out' ) do | openfile |
#ARGV[1] = 1packetflowuse_and_number********.out
#ARGV[1]の候補としては, 100uesrのみのほうが早いかもしれない
#ARGV[1] = ./2016****/sort_by_onepacket_top100とか
#その場合は, line.split(", ")とすべき
File.open( ARGV[0], "r" ) do | openfile |
	while line = openfile.gets
		line_split = line.split(", ")
		#line_split[0]には送信元IPアドレスが入る
		user[line_split[0]] = 1
	end
end
print "user numnber==",  user.size, "==\n"
#要素として時刻を保持する配列を持つHashの作成, flowのidによる
flow = Hash.new{|hash, key| hash[key] = Hash.new{ 0 } }
#user個分, そのuserが最後にいつパケットを送ったのか記憶する配列を作成
user_time = Hash.new{|hash, key| hash[key] = Hash.new{ 0 } }

#トレースファイル中全体のフローの情報を入れる
total_flow = Hash.new{ 0 } 
#トレースファイル中全体のuserの情報を入れる
total_user = Hash.new{ 0 }
#userごとにいくつのフローを生成したのかを記録するhash
user_flow = Hash.new{ |hash, key| hash[key] = Hash.new{ 0 } }

#全フローを記録する
total_per_second = Hash.new{ 0 }
#1秒間に送信されるフローの総数を記録する
total_flow_time = Hash.new{ 0 }

#mice userではないもの
not_mice_user_flow = Hash.new{ 0 }
not_mice_flow_time = Hash.new{ 0 }


#パケットキャプチャ開始からの時刻
time = 1.0
packet = 0
#ARGV[2] = ../../caputer/input_sample_*****
File.open( ARGV[1], "r" ) do | openfile2 |
	while line = openfile2.gets
		line_split = line.split(" ")
		flow_id = line_split[0] + " " + line_split[1] + " " + line_split[2] + " " + line_split[3] + " " + line_split[4]
		
		total_flow[flow_id] = 1
		total_user[line_split[0]] = 1

		#user毎にいくつのフローを生成しているかを計算する
		if user[line_split[0]]  == 1 then 
			user_flow[line_split[0]][flow_id] = user_flow[line_split[0]][flow_id] + 1
		end

		if time >= line_split[5].to_i then 
			if user[line_split[0]] == 1 then
				#1packetのフローを生成しているuserの場合の処理
				flow[line_split[0]][flow_id] = 1
			elsif user[line_split[0]] == 0 then 
				#1packetフローを生成していないuserの場合
				not_mice_user_flow[flow_id] = 1
			end
		
			#フロー全体
			total_per_second[flow_id] = 1
		elsif time < line_split[5].to_i then
			#timeまでに何フローきているかを記録する
			total_flow_time[time.to_i] = total_per_second.size
			#miceフローを生成していないuserが生成したフロー数per秒
			not_mice_flow_time[time.to_i] = not_mice_user_flow.size
	#		print time, "\n"
			flow.each{|key,value|
				user_time[key][time.to_i] = value.size
				#valueの要素数を0にする
				value.clear
			}
			#total_per_secondの要素を0にする
			total_per_second.clear
			total_per_second[flow_id] = 1

			#mice userではないuser
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
	#ルータがパケットの収集を開始した時刻(はじめは0~1秒)
	print key, ", ", user_flow[key].size, ", "
	#15分間パケットキャプチャを行っているので, 900秒
	for time in 1...900 do
		print value[time], ", "
	end
	print "\n"
}
print "\n"

#全フローの, 1秒辺りのフロー数を出力する
print "all", ", ", total_flow_num, ", "
for time in 1...900 do
	print total_flow_time[time], ", "
end
print "\n"

#1packetを生成しないuserの送信する1秒辺りのフロー数
print "not mice user", ", ", "not count", ", "
for time in 1...900 do
	print not_mice_flow_time[time], ", "
end
print "\n"
#print packet, "\n"
