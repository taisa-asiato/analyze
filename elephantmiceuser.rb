#index毎に, フローの数をカウント
flow = Hash.new( 0 )
#File.open( 'pra.out' ) do | openfile |
#input file is ./mice_***packet***.out
File.open( ARGV[0] ) do | openfile |
		while line = openfile.gets
			line_split = line.split(" ")
	
			#flow id の作成
			flow_id = line_split[0];
	
			#flow idごとに連想配列を作成する
			#連想配列は, このflow_idがいくつの１パケットフローを送信してきたかを示す
			flow[flow_id] = flow[flow_id] + 1;
		end
end

#hashをarrayに変換
flow = flow.to_a
#配列の二番目の要素同士で比較, 
flow.sort!{|k1, k2| k2[0] <=> k1[0] }

for i in 0...flow.length do 
	print flow[i][0], " ", flow[i][1], "\n"
end
