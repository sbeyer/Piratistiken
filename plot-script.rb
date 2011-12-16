#!/usr/bin/env ruby
# Generate plot script for gnuplot
#
# (C) 2011, Stephan Beyer
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

if ARGV.length != 18
	STDERR.puts "Error: need 18 arguments"
	exit 1
end

print <<EOF
# Generate output based on mitglieder.csv
set terminal png size 800,480
set output "output-tmp.png"

ymax = #{((ARGV[0].to_i + 200)/1000.0).ceil*1000}

set xdata time
set timefmt "%Y%m%d"
set xlabel "Datum"
set xtics \\
	"20070701",7776000 \\
	axis \\
	rotate \\
	offset 0,character 0.8 \\
	font "sans,9" \\
	format "%y-%m"
set key outside center right
set ytics 1000
set mytics 4

### define colors for special date markers
col_europa = "#3030ff"
col_bund = "#303030"
col_land = "#d5d5d5"
col_bpt = "#ffd530"

### define markers for special dates
EOF

startdate = 20070701
enddate = 20120201

[20090118, # Landtagswahl HE
 20090830, # Landtagswahl SL,SN,TH
 20090927, # Landtagswahl BB,SH
 20100509, # Landtagswahl NRW
 20110220, # Bürgerschaftswahl HH
 20110320, # Landtagswahl LSA
 20110327, # Landtagswahl BW
 20110327, # Landtagswahl RP
 20110522, # Bürgerschaftswahl HB
 20110904, # Landtagswahl MV
 20110918, # Abgeordnetenhauswahl BE
 20120506, # Landtagswahl SH
].each do |date|
	puts 'set arrow from "'+date.to_s+'",0 rto 0,ymax nohead lt rgb col_land' if date >= startdate and date <= enddate
end

[20090927 # Bundestagswahl 2009
].each do |date|
	puts 'set arrow from "'+date.to_s+'",0 rto 0,ymax nohead lt rgb col_bund' if date >= startdate and date <= enddate
end

[20090607, # EUW 2009
].each do |date|
	puts 'set arrow from "'+date.to_s+'",0 rto 0,ymax nohead lt rgb col_europa' if date >= startdate and date <= enddate
end

[20060910, # Gründungsversammlung
 20080517, 20080518, # BPT 2008.1
 20081003, 20081004, 20081005, # BPT 2008.2
 20090704, 20090705, # BPT 2009.1
 20100515, 20100516, # BPT 2010.1
 20101120, 20101121, # BPT 2010.2
 20110514, 20110515, # BPT 2011.1
 20111203, 20111204, # BPT 2011.2
 20120428, 20120429, # BPT 2012.1
].each do |date|
	puts 'set arrow from "'+date.to_s+'",0 rto 0,ymax nohead lt rgb col_bpt' if date >= startdate and date <= enddate
end

print <<EOF
### define colors for LVs
col_#{Translate[ARGV[1]][1]} = "#5f9812"
col_#{Translate[ARGV[2]][1]} = "#65cb39"
col_#{Translate[ARGV[3]][1]} = "#9ff8e8"
col_#{Translate[ARGV[4]][1]} = "#8ea5f9"
col_#{Translate[ARGV[5]][1]} = "#8171fc"
col_#{Translate[ARGV[6]][1]} = "#7a4ce6"
col_#{Translate[ARGV[7]][1]} = "#824f7f"
col_#{Translate[ARGV[8]][1]} = "#9f4c36"
col_#{Translate[ARGV[9]][1]} = "#be472e"
col_#{Translate[ARGV[10]][1]} = "#f14122"
col_#{Translate[ARGV[11]][1]} = "#ef8129"
col_#{Translate[ARGV[12]][1]} = "#eda32d"
col_#{Translate[ARGV[13]][1]} = "#dcba2e"
col_#{Translate[ARGV[14]][1]} = "#9eac25"
col_#{Translate[ARGV[15]][1]} = "#5b9c1c"
col_#{Translate[ARGV[16]][1]} = "#2d8b13"
col_#{Translate[ARGV[17]][1]} = "#136707"

plot ["#{startdate}":"#{enddate}"] [0:ymax] \\
 'mitglieder.csv' using 1:18 t "#{Translate[ARGV[17]][0]}" w filledcurves x1 lt rgb col_#{Translate[ARGV[17]][1]}, \\
 'mitglieder.csv' using 1:17 t "#{Translate[ARGV[16]][0]}" w filledcurves x1 lt rgb col_#{Translate[ARGV[16]][1]}, \\
 'mitglieder.csv' using 1:16 t "#{Translate[ARGV[15]][0]}" w filledcurves x1 lt rgb col_#{Translate[ARGV[15]][1]}, \\
 'mitglieder.csv' using 1:15 t "#{Translate[ARGV[14]][0]}" w filledcurves x1 lt rgb col_#{Translate[ARGV[14]][1]}, \\
 'mitglieder.csv' using 1:14 t "#{Translate[ARGV[13]][0]}" w filledcurves x1 lt rgb col_#{Translate[ARGV[13]][1]}, \\
 'mitglieder.csv' using 1:13 t "#{Translate[ARGV[12]][0]}" w filledcurves x1 lt rgb col_#{Translate[ARGV[12]][1]}, \\
 'mitglieder.csv' using 1:12 t "#{Translate[ARGV[11]][0]}" w filledcurves x1 lt rgb col_#{Translate[ARGV[11]][1]}, \\
 'mitglieder.csv' using 1:11 t "#{Translate[ARGV[10]][0]}" w filledcurves x1 lt rgb col_#{Translate[ARGV[10]][1]}, \\
 'mitglieder.csv' using 1:10 t "#{Translate[ARGV[9]][0]}" w filledcurves x1 lt rgb col_#{Translate[ARGV[9]][1]}, \\
 'mitglieder.csv' using 1:9 t "#{Translate[ARGV[8]][0]}" w filledcurves x1 lt rgb col_#{Translate[ARGV[8]][1]}, \\
 'mitglieder.csv' using 1:8 t "#{Translate[ARGV[7]][0]}" w filledcurves x1 lt rgb col_#{Translate[ARGV[7]][1]}, \\
 'mitglieder.csv' using 1:7 t "#{Translate[ARGV[6]][0]}" w filledcurves x1 lt rgb col_#{Translate[ARGV[6]][1]}, \\
 'mitglieder.csv' using 1:6 t "#{Translate[ARGV[5]][0]}" w filledcurves x1 lt rgb col_#{Translate[ARGV[5]][1]}, \\
 'mitglieder.csv' using 1:5 t "#{Translate[ARGV[4]][0]}" w filledcurves x1 lt rgb col_#{Translate[ARGV[4]][1]}, \\
 'mitglieder.csv' using 1:4 t "#{Translate[ARGV[3]][0]}" w filledcurves x1 lt rgb col_#{Translate[ARGV[3]][1]}, \\
 'mitglieder.csv' using 1:3 t "#{Translate[ARGV[2]][0]}" w filledcurves x1 lt rgb col_#{Translate[ARGV[2]][1]}, \\
 'mitglieder.csv' using 1:2 t "#{Translate[ARGV[1]][0]}" w filledcurves x1 lt rgb col_#{Translate[ARGV[1]][1]}
EOF
