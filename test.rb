#index毎に, フローの数をカウント
flow = Hash.new( 0 )
flowuser = Hash.new( 0 )
#File.open( 'pra.out' ) do | openfile |
#input file is ../caputer/input_sample_********.txt
File.open( ARGV[0] ) do | openfile |
		while line = openfile.gets
		line_split = line.split(" ")

		#flow id の作成
		flow_id = line_split[0] + " " + line_split[1] + " " + line_split[2] + " " + line_split[3] + " " + line_split[4]

		#flow idごとに連想配列を作成する
		flow[flow_id] = flow[flow_id] + 1;
		flowuser[line_split[0]] = flowuser[line_split[0]] + 1;
	end
end



#flow.sort{|a, b|
#	b[1] <=> a[1]
#}
onepacketflow = 0
under10packetflow = 0
under100packetflow = 0
under1000packetflow = 0
under10000packetflow = 0
under100000packetflow = 0
elephantflow = 0
flow.each{|key, value| 
	if value == 1 then
		onepacketflow = onepacketflow + 1
	elsif value > 1 && value <= 10 then 
		under10packetflow = under10packetflow + 1
	elsif value > 10 && value <= 100 then 
		under100packetflow = under100packetflow + 1
	elsif value > 100 && value <= 1000 then 
		under1000packetflow = under1000packetflow + 1
	elsif value > 1000 && value <= 10000 then 
		under10000packetflow = under10000packetflow + 1
	elsif value > 10000 && value <= 100000 then 
		under100000packetflow = under100000packetflow + 1
	else
		elephantflow = elephantflow + 1
	end
}

print "====flow number: ", flow.size, "\n"
print "1packet ", onepacketflow, "\n"
print "2~10packet ", under10packetflow, "\n"
print "11~100packet ", under100packetflow, "\n"
print "101~1000packet ", under1000packetflow, "\n"
print "1001~10000packet ", under10000packetflow, "\n"
print "100001~1000000packet ", under100000packetflow, "\n"
print "over 1000000 ", elephantflow, "\n"



onepacketuser = 0
under10packetuser = 0
under100packetuser = 0
under1000packetuser = 0
under10000packetuser = 0
under100000packetuser = 0
elephantuser = 0
flowuser.each{|key, value| 
	if value == 1 then
		onepacketuser = onepacketuser + 1
	elsif value > 1 && value <= 10 then
		under10packetuser = under10packetuser + 1
	elsif value > 10 && value <= 100 then 
		under100packetuser = under100packetuser + 1
	elsif value > 100 && value <= 1000 then 
		under1000packetuser = under1000packetuser + 1
	elsif value > 1000 && value <= 10000 then 
		under10000packetuser = under10000packetuser + 1
	elsif value > 10000 && value <= 100000 then 
		under100000packetuser = under100000packetuser + 1
	else
		elephantuser = elephantuser + 1
	end		
}

print "====flowuser: ", flowuser.size, "\n"
print "1packetuser ", onepacketuser, "\n"
print "2~10packetuser ", under10packetuser, "\n"
print "11~100packetuser ", under100packetuser, "\n"
print "101~1000packetuser ", under1000packetuser, "\n"
print "1001~10000packetuser ", under10000packetuser, "\n"
print "10001~100000packetuser ", under100000packetuser, "\n"
print "elephantuser", elephantuser, "\n"
