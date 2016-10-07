# encoding=utf-8 
require 'open-uri'
require 'net/http'
require "json"

if ARGV[0].nil?
	year = "all"
else
	year = ARGV[0]
end



top_url = "http://weather.unisys.com/hurricane/w_pacific/"
top_path = "http://weather.unisys.com/hurricane/w_pacific/"


pat1 = /<a href="(\d{4}\/index.php)">/
pat2 = /<tr><td width="20" align="right" style="color:black;">(\d+)<\/td><td width="250" style="color:black;">([\w\s]+ #\d+)\s+<\/td><td width="125" align="right" style="color:black;">([\w\d\s\-]+)\s+<\/td><td width="40" align="right" style="color:black;">\s?(\d+)\s<\/td><td width="40" align="right" style="color:black;">\s*([\d\-]+)\s+<\/td><td width="40" align="right" style="color:black;">\s+([\d\-]+)<\/td><td>&nbsp;<\/td>/

if year == "all"
	top_page = open(top_url).read
	years = top_page.scan(pat1).to_a
	puts years.size.to_s + " years found!"
else
	years = []
	years[0] = []
	years[0][0] = year + "/index.php"
end

unless Dir.exists?("data")
	Dir.mkdir("data")
end

for year in years
	yr = year[0][0..3]
	unless Dir.exists?("data/" + yr)
		Dir.mkdir("data/" + yr)
	end
	page_url = top_path + year[0]
	puts "visiting: " + page_url
	tmp = open(page_url).read
	data = tmp.scan(pat2)
	for datum in data
		dat_url = top_path + yr + '/' + datum[0] + "/track.dat"
		puts "\tfetching: " + dat_url
		begin
			dat = open(dat_url).read
			File.open("data/#{yr}/#{datum[0]}.dat", "w+:utf-8") do |i|
		    	i.write(dat)
			end
		rescue
			next
		end
	end
end










