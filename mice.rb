#index毎に, 秒間何フローが流れてきているかをカウントする
flow_index_array = Array.new( 256 ){ Array.new(){ 0 } }
#index毎のパケット数をカウント
packet = Array.new( 256 ){ 0 }
#index毎に, フローの数をカウント
flow = Array.new( 256 ){ Hash.new( -1.0 ) }
#index毎に, 時間あたりのフロー数をカウント
interval_flow = Array.new( 256 ){ Hash.new( 0 ) }

total_flow = 0
total_packet = 0
total_packet_index = Array.new( 256 ){ 0 }
time = 1.0
time_index = Array.new( 256 ){ 1 }
File.open( 'pra.out' ) do | openfile |
#File.open( 'analyze2009_1.out' ) do | openfile |
		while line = openfile.gets
#		line = line.scrub('.') #不正バイトを.に置き換え
		line_split = line.split(", ")
		num = line_split[8].to_i
		time = line_split[0].to_f
		#flow id の作成
		flow_id = line_split[1] + "-" + line_split[2] + "-" + line_split[3] + "-" + line_split[4] + "-" + line_split[5]
		#flow idごとに連想配列を作成する
		if flow[num][flow_id] == -1 then
			flow[num][flow_id] = time
		elsif flow[num][flow_id] != -1 then
			flow[num][flow_id] = -2
		end
#		flow[num][flow_id] = flow[num][flow_id] + 1
		#index毎のパケット数をカウント
		
		#indexごとに配列を作成する (時間毎のフロー数をカウントする)
#		flow_index_array[num].push( line_split )
		total_packet = total_packet + 1
#		print line_split[0], ",", line_split[1], ",", line_split[2], ",", line_split[3], ",", 
#			line_split[4], ",", line_split[5], ",", line_split[6], ",", line_split[7], ",", line_split[8], "\n"
	end
end
j = 0
for i in 0...256 do
	#index毎に上位4フローを出力
	flow_array = flow[i].sort{|a, b| a[1]<=>b[1] }
	for j in 0...flow[i].length do
		if flow_array[j][1] != -2 then 
			array = flow_array[j][0].split("-")
			print array[0], ", ", array[1], ", ", array[2], ", ", array[3], ", ", array[4], ", ", flow_array[j][1], "\n"
		end
	end
end
