INPUT_SORTED = \
	OUTSIDE.txt \
	LV-SL.txt \
	LV-HB.txt \
	LV-TH.txt \
	LV-LSA.txt \
	LV-MV.txt \
	LV-BB.txt \
	LV-SN.txt \
	LV-SH.txt \
	LV-RP.txt \
	LV-HH.txt \
	LV-BE.txt \
	LV-HE.txt \
	LV-NDS.txt \
	LV-BW.txt \
	LV-NRW.txt \
	LV-BY.txt

output.png: output-tmp.png
	pngcrush -brute -l 9 output-tmp.png output.png

output-tmp.png: mitglieder.csv plotscript
	./plotscript

mitglieder.csv: $(INPUT_SORTED) plot-stacked.rb Makefile
	./plot-stacked.rb $(INPUT_SORTED) > $@

check:
	netstiff -W netstiff
