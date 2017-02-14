#index毎に, 秒間何フローが流れてきているかをカウントする
flow_index_array = Array.new( 256 ){ Array.new(){ 0 } }
#index毎のパケット数をカウント
packet = Array.new( 256 ){ 0 }
#index毎に, フローの数をカウント
flow = Array.new( 256 ){ Hash.new( 0 ) }
#index毎に, 時間あたりのフロー数をカウント
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
	#flow id の作成
	flow_id = line_split[1] + "-" + line_split[2] + "-" + line_split[3] + "-" + line_split[4] + "-" + line_split[5]
	#flow idごとに連想配列を作成する
	flow[num][flow_id] = flow[num][flow_id] + 1
	#index毎のパケット数をカウント		
	end
end

for i in 0...256 do
	#後の加工のし安さを考えて, インデックス毎ソートされた, １行の一つのフローを出力するようにする
	#index毎に上位4フローを出力
	flow_array = flow[i].sort{|a, b| b[1]<=>a[1] }
	for j in 0...4 do
		tmp_flow = flow_array[j][0].split("-")
		print tmp_flow[0], " ", tmp_flow[1], " ", tmp_flow[2], " ", tmp_flow[3], " ", tmp_flow[4], "\n"
	end
end
