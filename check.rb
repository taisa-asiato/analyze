#index毎に, 秒間何フローが流れてきているかをカウントする
flow_index_array = Array.new( 256 ){ Array.new(){ 0 } }
#index毎のパケット数をカウント
packet = Array.new( 256 ){ 0 }
#index毎に, フローの数をカウント
flow = Array.new( 256 ){ Hash.new { |h, k| h[k] = [] } }
#index毎に, 時間あたりのフロー数をカウント
interval_flow = Array.new( 256 ){ Hash.new( 0 ) }

total_flow = 0
total_packet = 0
total_packet_index = Array.new( 256 ){ 0 }
time = 0.0
time_index = Array.new( 256 ){ 1 }

File.open( 'analyze2009_1.out' ) do | openfile |
		while line = openfile.gets
#		line = line.scrub('.') #不正バイトを.に置き換え
		#, 区切りで文字列を分割
		line_split = line.split(", ")

		#フローのインデックス番号
		num = line_split[8].to_i

		#時刻
		time = line_split[0].to_f

		#flow id の作成
		flow_id = line_split[1] + "-" + line_split[2] + "-" + line_split[3] + "-" + line_split[4] + "-" + line_split[5]
		
		#flow idごとに連想配列を作成する
		flow[num][flow_id] = flow[num][flow_id].push( )
		#index毎のパケット数をカウント
		packet[num] = packet[num] +1
		
		#indexごとに配列を作成する (時間毎のフロー数をカウントする)
#		flow_index_array[num].push( line_split )
		total_packet = total_packet + 1
		print line_split[0], ", ", line_split[1], ",", line_split[2], ",", line_split[3], ",", 
			line_split[4], ",", line_split[5], ",", line_split[6], ",", line_split[7], ",", line_split[8]
		end
	end
end
