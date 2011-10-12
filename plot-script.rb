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

if ARGV.length != 17
	STDERR.puts "Error: need 17 arguments"
	exit 1
end

print <<EOF
# Generate output based on mitglieder.csv
set terminal png
set output "output-tmp.png"

ymax = 15500

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

#set arrow from "20060910",0 rto 0,ymax nohead lt rgb col_bpt # Gründungsversammlung
set arrow from "20080517",0 rto 0,ymax nohead lt rgb col_bpt # BPT 2008.1
set arrow from "20080518",0 rto 0,ymax nohead lt rgb col_bpt # BPT 2008.1
set arrow from "20081003",0 rto 0,ymax nohead lt rgb col_bpt # BPT 2008.2
set arrow from "20081004",0 rto 0,ymax nohead lt rgb col_bpt # BPT 2008.2
set arrow from "20081005",0 rto 0,ymax nohead lt rgb col_bpt # BPT 2008.2
set arrow from "20090118",0 rto 0,ymax nohead lt rgb col_land # Landtagswahl HE
set arrow from "20090607",0 rto 0,ymax nohead lt rgb col_europa # Europawahl 2009
set arrow from "20090704",0 rto 0,ymax nohead lt rgb col_bpt # BPT 2009.1
set arrow from "20090705",0 rto 0,ymax nohead lt rgb col_bpt # BPT 2009.1
set arrow from "20090830",0 rto 0,ymax nohead lt rgb col_land # Landtagswahl SL,SN,TH
#set arrow from "20090927",0 rto 0,ymax nohead lt rgb col_land # Landtagswahl BB,SH
set arrow from "20090927",0 rto 0,ymax nohead lt rgb col_bund # Bundestagswahl 2009
set arrow from "20100509",0 rto 0,ymax nohead lt rgb col_land # Landtagswahl NRW
set arrow from "20100515",0 rto 0,ymax nohead lt rgb col_bpt # BPT 2010.1
set arrow from "20100516",0 rto 0,ymax nohead lt rgb col_bpt # BPT 2010.1
set arrow from "20101120",0 rto 0,ymax nohead lt rgb col_bpt # BPT 2010.2
set arrow from "20101121",0 rto 0,ymax nohead lt rgb col_bpt # BPT 2010.2
set arrow from "20110220",0 rto 0,ymax nohead lt rgb col_land # Bürgerschaftswahl HH
set arrow from "20110320",0 rto 0,ymax nohead lt rgb col_land # Landtagswahl LSA
set arrow from "20110327",0 rto 0,ymax nohead lt rgb col_land # Landtagswahl BW
set arrow from "20110327",0 rto 0,ymax nohead lt rgb col_land # Landtagswahl RP
set arrow from "20110514",0 rto 0,ymax nohead lt rgb col_bpt # BPT 2011.1
set arrow from "20110515",0 rto 0,ymax nohead lt rgb col_bpt # BPT 2011.1
set arrow from "20110522",0 rto 0,ymax nohead lt rgb col_land # Bürgerschaftswahl HB
set arrow from "20110904",0 rto 0,ymax nohead lt rgb col_land # Landtagswahl MV
set arrow from "20110918",0 rto 0,ymax nohead lt rgb col_land # Abgeordnetenhauswahl BE
set arrow from "20111203",0 rto 0,ymax nohead lt rgb col_bpt # BPT 2011.2
set arrow from "20111204",0 rto 0,ymax nohead lt rgb col_bpt # BPT 2011.2

### define colors for LVs
col_#{Translate[ARGV[0]][1]} = "#5f9812"
col_#{Translate[ARGV[1]][1]} = "#65cb39"
col_#{Translate[ARGV[2]][1]} = "#9ff8e8"
col_#{Translate[ARGV[3]][1]} = "#8ea5f9"
col_#{Translate[ARGV[4]][1]} = "#8171fc"
col_#{Translate[ARGV[5]][1]} = "#7a4ce6"
col_#{Translate[ARGV[6]][1]} = "#824f7f"
col_#{Translate[ARGV[7]][1]} = "#9f4c36"
col_#{Translate[ARGV[8]][1]} = "#be472e"
col_#{Translate[ARGV[9]][1]} = "#f14122"
col_#{Translate[ARGV[10]][1]} = "#ef8129"
col_#{Translate[ARGV[11]][1]} = "#eda32d"
col_#{Translate[ARGV[12]][1]} = "#dcba2e"
col_#{Translate[ARGV[13]][1]} = "#9eac25"
col_#{Translate[ARGV[14]][1]} = "#5b9c1c"
col_#{Translate[ARGV[15]][1]} = "#2d8b13"
col_#{Translate[ARGV[16]][1]} = "#136707"

plot ["20070701":"20120101"] [0:ymax] \\
 'mitglieder.csv' using 1:18 t "#{Translate[ARGV[16]][0]}" w filledcurves x1 lt rgb col_#{Translate[ARGV[16]][1]}, \\
 'mitglieder.csv' using 1:17 t "#{Translate[ARGV[15]][0]}" w filledcurves x1 lt rgb col_#{Translate[ARGV[15]][1]}, \\
 'mitglieder.csv' using 1:16 t "#{Translate[ARGV[14]][0]}" w filledcurves x1 lt rgb col_#{Translate[ARGV[14]][1]}, \\
 'mitglieder.csv' using 1:15 t "#{Translate[ARGV[13]][0]}" w filledcurves x1 lt rgb col_#{Translate[ARGV[13]][1]}, \\
 'mitglieder.csv' using 1:14 t "#{Translate[ARGV[12]][0]}" w filledcurves x1 lt rgb col_#{Translate[ARGV[12]][1]}, \\
 'mitglieder.csv' using 1:13 t "#{Translate[ARGV[11]][0]}" w filledcurves x1 lt rgb col_#{Translate[ARGV[11]][1]}, \\
 'mitglieder.csv' using 1:12 t "#{Translate[ARGV[10]][0]}" w filledcurves x1 lt rgb col_#{Translate[ARGV[10]][1]}, \\
 'mitglieder.csv' using 1:11 t "#{Translate[ARGV[9]][0]}" w filledcurves x1 lt rgb col_#{Translate[ARGV[9]][1]}, \\
 'mitglieder.csv' using 1:10 t "#{Translate[ARGV[8]][0]}" w filledcurves x1 lt rgb col_#{Translate[ARGV[8]][1]}, \\
 'mitglieder.csv' using 1:9 t "#{Translate[ARGV[7]][0]}" w filledcurves x1 lt rgb col_#{Translate[ARGV[7]][1]}, \\
 'mitglieder.csv' using 1:8 t "#{Translate[ARGV[6]][0]}" w filledcurves x1 lt rgb col_#{Translate[ARGV[6]][1]}, \\
 'mitglieder.csv' using 1:7 t "#{Translate[ARGV[5]][0]}" w filledcurves x1 lt rgb col_#{Translate[ARGV[5]][1]}, \\
 'mitglieder.csv' using 1:6 t "#{Translate[ARGV[4]][0]}" w filledcurves x1 lt rgb col_#{Translate[ARGV[4]][1]}, \\
 'mitglieder.csv' using 1:5 t "#{Translate[ARGV[3]][0]}" w filledcurves x1 lt rgb col_#{Translate[ARGV[3]][1]}, \\
 'mitglieder.csv' using 1:4 t "#{Translate[ARGV[2]][0]}" w filledcurves x1 lt rgb col_#{Translate[ARGV[2]][1]}, \\
 'mitglieder.csv' using 1:3 t "#{Translate[ARGV[1]][0]}" w filledcurves x1 lt rgb col_#{Translate[ARGV[1]][1]}, \\
 'mitglieder.csv' using 1:2 t "#{Translate[ARGV[0]][0]}" w filledcurves x1 lt rgb col_#{Translate[ARGV[0]][1]}
EOF
