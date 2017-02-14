#index毎に, フローの数をカウント
user = Hash.new{ 0 }

#File.open( 'pra.out' ) do | openfile |
#ARGV[1] = 1packetflowuse_and_number********.out
File.open( ARGV[0], "r" ) do | openfile |
	while line = openfile.gets
		line_split = line.split(" ")

	#	flownumber = line_split[1].to_i
		#1packet flowを1000以上生成しているuserを連想配列に登録
	#	if flownumber >= 1000 then
		user[line_split[0]] = 1
		
	end
end

#多次元hashの宣言, 1packetflowを生成するuserが生成する1パケットのフローとそうでないフローの数を計算する
flow = Hash.new{ | hash, key | hash[key] = Hash.new{ 0 } }
#トレースファイル中全体のフローの数を計算する
total_flow = Hash.new{ 0 } 
#トレースファイル中全体のuserの数を計算する
total_user = Hash.new{ 0 }

#ARGV[2] = ../../caputer/input_sample_*****
File.open( ARGV[1], "r" ) do | openfile2 |
	while line = openfile2.gets
		line_split = line.split(" ")
		flow_id = line_split[0] + " " + line_split[1] + " " + line_split[2] + " " + line_split[3] + " " + line_split[4]
		
		total_flow[flow_id] = 1
		total_user[line_split[0]] = 1

		if user[line_split[0]] == 1 then 
			#1packetのフローを生成しているuserの場合の処理		
			#flow[line_split[0]][flow_id]の値は, userであるline_split[0]が生成したflow_idフローが何packetで構成されているかを表す
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
