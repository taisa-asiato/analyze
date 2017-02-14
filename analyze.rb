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
#		line = line.scrub('.') #不正バイトを.に置き換え
		line_split = line.split(", ")
		num = line_split[8].to_i
		time = line_split[0].to_f
		#flow id の作成
		flow_id = line_split[1] + "-" + line_split[2] + "-" + line_split[3] + "-" + line_split[4] + "-" + line_split[5]
		#flow idごとに連想配列を作成する
		flow[num][flow_id] = flow[num][flow_id] + 1
		#index毎のパケット数をカウント
		packet[num] = packet[num] +1
		
		if time_index[num] < time then 
			interval_flow[num][flow_id] = interval_flow[num][flow_id] + 1
		elsif time_index[num] > time then
			tmp = interval_flow[num].length
			flow_index_array[num].push( tmp )
			interval_flow[num].clear()
			interval_flow[num][flow_id] = interval_flow[num][flow_id] + 1
			time = time + 1
		end
			
		#indexごとに配列を作成する (時間毎のフロー数をカウントする)
#		flow_index_array[num].push( line_split )
		total_packet = total_packet + 1
#		print line_split[0], ",", line_split[1], ",", line_split[2], ",", line_split[3], ",", 
#			line_split[4], ",", line_split[5], ",", line_split[6], ",", line_split[7], ",", line_split[8], "\n"
	end
end

for i in 0...256 do
	tmp = interval_flow[i].length
	if tmp != 0 then 
		flow_index_array[i].push( tmp )
	end
end

print "all contents were pushed into hash "
print ", , , , , , , , "
for i in 0...900 do
	print i, ", "
end
print "\n"
j = 0
for i in 0...256 do
	#index毎のパケット数, フロー数を出力
	print "INDEX:", i, ", ", packet[i], ", ", flow[i].length, ", " 
	#全フロー数を加算
	total_flow = total_flow + flow[i].length

	#index毎に上位4フローを出力
	flow_array = flow[i].sort{|a, b| b[1]<=>a[1] }
	for j in 0...4 do
		print flow_array[j][0], "-", flow_array[j][1], ", "
	end

	packet_length = flow_index_array[i].length
	for j in 0...packet_length do
		print flow_index_array[i][j],
		if j != packet_length then
			print ", "
		end
	end
	print "\n"
end
print "total_packet:", total_packet, "total_flow:", total_flow, "\n"
