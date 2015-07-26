#!/usr/bin/env ruby
# Generate plot script for gnuplot
#
# (C) 2011 - 2015, Stephan Beyer
#
# Redistribution and use in source and binary forms, with or
# without modification, are permitted provided that the following
# conditions are met:
#
#   1. Redistributions of source code must retain the above
#      copyright notice, this list of conditions and the
#      following disclaimer.
#
#   2. Redistributions in binary form must reproduce the above
#      copyright notice, this list of conditions and the
#      following disclaimer in the documentation and/or other
#      materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY STEPHAN BEYER ``AS IS'' AND ANY EXPRESS
# OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL STEPHAN BEYER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
# EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# The views and conclusions contained in the software and documentation
# are those of the authors and should not be interpreted as representing
# official policies, either expressed or implied, of Stephan Beyer.

Translate = {
	'BV.txt' => ['Bund', 'bv'],
	'LV-BB.txt' => ['LV BB', 'bb'],
	'LV-BE.txt' => ['LV BE', 'be'],
	'LV-BW.txt' => ['LV BW', 'bw'],
	'LV-BY.txt' => ['LV BY', 'by'],
	'LV-HB.txt' => ['LV HB', 'hb'],
	'LV-HE.txt' => ['LV HE', 'he'],
	'LV-HH.txt' => ['LV HH', 'hh'],
	'LV-LSA.txt' => ['LV LSA', 'lsa'],
	'LV-MV.txt' => ['LV MV', 'mv'],
	'LV-NDS.txt' => ['LV NDS', 'nds'],
	'LV-NRW.txt' => ['LV NRW', 'nrw'],
	'LV-RP.txt' => ['LV RP', 'rp'],
	'LV-SH.txt' => ['LV SH', 'sh'],
	'LV-SL.txt' => ['LV SL', 'sl'],
	'LV-SN.txt' => ['LV SN', 'sn'],
	'LV-TH.txt' => ['LV TH', 'th'],
	'OUTSIDE.txt' => ['Ausland', 'out']
}

if ARGV.length != 20
	STDERR.puts "Error: need 20 arguments"
	exit 1
end

startdate = 20071201

print <<EOF
# Generate output based on mitglieder.csv
set terminal pngcairo size 800,520
set output "output-tmp.png"

ymax = #{((ARGV.shift.to_i + 200)/1000.0).ceil*1000}

set xdata time
set timefmt "%Y%m%d"
set title "Verlauf der Mitgliederanzahl der Piratenpartei Deutschland"
set xlabel "Datum" offset 0,-1
set y2label "Anzahl Mitglieder" offset -1.5
set xtics \\
	"#{startdate}",7776000 \\
	axis \\
	rotate \\
	offset 0,character 0.5 \\
	font "sans,7.7" \\
	format "%Y-%m"
set key outside center left
set y2tics 2000 \\
	font "sans,9" \\
	mirror
set my2tics 2
set noytics

### define colors for special date markers
col_europa = "#3030ff"
col_bund = "#303030"
col_land = "#d5d5d5"
col_bpt = "#ffd530"

### define markers for special dates
EOF

enddate = ARGV.shift.to_i + 30

File.readlines('ltw.txt').each do |line|
	date = line[0,8].to_i
	puts 'set arrow from "'+date.to_s+'",0 rto 0,ymax nohead lt rgb col_land' if date >= startdate and date <= enddate
end

File.readlines('btw.txt').each do |line|
	date = line[0,8].to_i
	puts 'set arrow from "'+date.to_s+'",0 rto 0,ymax nohead lt rgb col_bund' if date >= startdate and date <= enddate
end

File.readlines('euw.txt').each do |line|
	date = line[0,8].to_i
	puts 'set arrow from "'+date.to_s+'",0 rto 0,ymax nohead lt rgb col_europa' if date >= startdate and date <= enddate
end

File.readlines('bpt.txt').each do |line|
	date = line[0,8].to_i
	puts 'set arrow from "'+date.to_s+'",0 rto 0,ymax nohead lt rgb col_bpt' if date >= startdate and date <= enddate
end

puts "### define colors for LVs"

index = 0
["#888888",
 "#000000",
 "#65cb39",
 "#9ff8e8",
 "#8ea5f9",
 "#8171fc",
 "#7a4ce6",
 "#824f7f",
 "#9f4c36",
 "#be472e",
 "#f14122",
 "#ef8129",
 "#eda32d",
 "#dcba2e",
 "#9eac25",
 "#5b9c1c",
 "#2d8b13",
 "#136707",
].each_with_index do |color, i|
	puts "col_#{Translate[ARGV[i]][1]} = \"#{color}\""
end

puts
puts "plot [\"#{startdate}\":\"#{enddate}\"] [0:ymax] \\\n"
lines = (1..17).to_a.reverse.map do |i|
  "'mitglieder.csv' using 1:#{i+1} t \"#{Translate[ARGV[i]][0]}\" w filledcurves x1 lt rgb col_#{Translate[ARGV[i]][1]}"
end << "'#{ARGV[0]}' using 1:2 t \"#{Translate[ARGV[0]][0]}\" w lines lt rgb col_#{Translate[ARGV[0]][1]}"
print lines.join(", \\\n ")
