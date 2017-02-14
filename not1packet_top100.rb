# 
# 元のトラフィックから, top100が生成する1パケットフローを除去したフローを生成する
#
#
#


# top100のuserを記録するhash
top100 = Hash.new{ 0 }
File.open( ARGV[0], "r" ) do | openfile |
	while line = openfile.gets
		line_split = line.split(", ")
		top100[line_split[0]] = 1
	end
end
# print top100.size
# top100のuserが生成した1パケットフローを記録するhash
onepacket_top100 = Hash.new{ 0 }
File.open( ARGV[1], "r" ) do | openfile1 |
	while line = openfile1.gets
		line_split = line.split(" ")

		if top100[line_split[0]] == 1 then 
			onepacket_top100[line] = 1
		end
	end
end
# print onepacket_top100.size
# 元のトラフィックから, top100が生成している1パケットフローを除去する
File.open( ARGV[2], "r" ) do | openfile2 |
	while line = openfile2.gets
		line_split = line.split(" ")

		flow_id = line_split[0] + " " + line_split[1] + " " + line_split[2] + " " + line_split[3] + " " + line_split[4] + "\n"

		if onepacket_top100[flow_id] == 0 then 
			print line
		end
	end
end
