INPUT = \
	LV-BB.txt \
	LV-BE.txt \
	LV-BW.txt \
	LV-BY.txt \
	LV-HB.txt \
	LV-HE.txt \
	LV-HH.txt \
	LV-LSA.txt \
	LV-MV.txt \
	LV-NDS.txt \
	LV-NRW.txt \
	LV-RP.txt \
	LV-SH.txt \
	LV-SL.txt \
	LV-SN.txt \
	LV-TH.txt \
	OUTSIDE.txt

Mitgliederentwicklung-nach-LVs.png: output-tmp.png
	pngcrush -brute -l 9 "$<" "$@"

output-tmp.png: mitglieder.csv plotscript
	gnuplot plotscript

mitglieder.csv: $(INPUT) plot-stacked.rb sort.rb Makefile
	./plot-stacked.rb `./sort.rb $(INPUT)` > $@

plotscript: $(INPUT) mitglieder.csv plot-script.rb sort.rb Makefile
	./plot-script.rb `tail -n 1 mitglieder.csv | sed -e 's/^\([0-9]\+\).*\t\([0-9]\+\)$$/\2 \1/'` `./sort.rb $(INPUT)` > $@

diff:
	netstiff -W netstiff > $@
