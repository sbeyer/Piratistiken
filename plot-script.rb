#!/usr/bin/env ruby
# Generate plot script for gnuplot
#
# (C) 2011 - 2013, Stephan Beyer
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
set terminal pngcairo size 800,480
set output "output-tmp.png"

ymax = #{((ARGV.shift.to_i + 200)/1000.0).ceil*1000}

set xdata time
set timefmt "%Y%m%d"
set xlabel "Datum"
set xtics \\
	"#{startdate}",7776000 \\
	axis \\
	rotate \\
	offset 0,character 0.5 \\
	font "sans,7.7" \\
	format "%Y-%m"
set key outside center right
set ytics 2000 \\
	font "sans,9"
set mytics 2

### define colors for special date markers
col_europa = "#3030ff"
col_bund = "#303030"
col_land = "#d5d5d5"
col_bpt = "#ffd530"

### define markers for special dates
EOF

enddate = ARGV.shift.to_i + 30

[20060326, # Landtagswahl BW,RP,LSA
 20060917, # Abgeordnetenhauswahl BE, Landtagswahl MV
 20070503, # Bürgerschaft HB
 20080127, # Landtagswahl HE,NDS
 20080224, # Bürgerschaftswahl HH
 20080706, # Nachwahlen Bürgerschaft HB
 20080928, # Landtagswahl BY
 20090118, # Landtagswahl HE
 20090830, # Landtagswahl SL,SN,TH
 20090927, # Landtagswahl BB,SH
 20100509, # Landtagswahl NRW
 20110220, # Bürgerschaftswahl HH
 20110320, # Landtagswahl LSA
 20110327, # Landtagswahl BW, RP
 20110522, # Bürgerschaftswahl HB
 20110904, # Landtagswahl MV
 20110918, # Abgeordnetenhauswahl BE
 20120325, # Landtagswahl SL
 20120506, # Landtagswahl SH
 20120513, # Landtagswahl NRW
 20130120, # Landtagswahl NDS
 20130915, # Landtagswahl BY
 20130922, # Landtagswahl HE
].each do |date|
	puts 'set arrow from "'+date.to_s+'",0 rto 0,ymax nohead lt rgb col_land' if date >= startdate and date <= enddate
end

[20090927, # Bundestagswahl 2009
 20130922, # Bundestagswahl 2013
].each do |date|
	puts 'set arrow from "'+date.to_s+'",0 rto 0,ymax nohead lt rgb col_bund' if date >= startdate and date <= enddate
end

[20090607, # EUW 2009
 20140511, # EUW 2014 (geschätzt)
].each do |date|
	puts 'set arrow from "'+date.to_s+'",0 rto 0,ymax nohead lt rgb col_europa' if date >= startdate and date <= enddate
end

[20060910, # Gründungsversammlung in Berlin
 20070519, 20070520, # BPT 2007.1 in Stockheim
 20080517, 20080518, # BPT 2008.1 in Hannover
 20081003, 20081004, 20081005, # BPT 2008.2 in Bielefeld
 20090704, 20090705, # BPT 2009.1 in Hamburg
 20100515, 20100516, # BPT 2010.1 in Bingen
 20101120, 20101121, # BPT 2010.2 in Chemnitz
 20110514, 20110515, # BPT 2011.1 in Heidenheim
 20111203, 20111204, # BPT 2011.2 in Offenbach
 20120428, 20120429, # BPT 2012.1 in Neumünster
 20121124, 20121125, # BPT 2012.2 in Bochum
 20130511, 20130512, # BPT 2013.1 in Neumarkt i. d. OPf.
].each do |date|
	puts 'set arrow from "'+date.to_s+'",0 rto 0,ymax nohead lt rgb col_bpt' if date >= startdate and date <= enddate
end

puts "### define colors for LVs"

index = 0
["#888888",
 "#5f9812",
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
puts "plot [\"#{startdate}\":\"#{enddate}\"] [0:ymax] \\"
print((1..17).to_a.reverse.map do |i|
  " 'mitglieder.csv' using 1:#{i+1} t \"#{Translate[ARGV[i]][0]}\" w filledcurves x1 lt rgb col_#{Translate[ARGV[i]][1]}"
 end.join(", \\\n"))
puts ", \\\n '#{ARGV[0]}' using 1:2 t \"#{Translate[ARGV[0]][0]}\" w lines lt rgb col_#{Translate[ARGV[0]][1]}\n"
