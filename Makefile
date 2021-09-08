all: alma geotopo

alma: pdfs
	@$(MAKE) -C AlgorithmischeMathematik2
	@cp AlgorithmischeMathematik2/full.pdf pdfs/2021_Algorithmische_Mathematik.pdf

geotopo: pdfs GeometrieUndTopologie/full.gnuplots
	$(MAKE) -C GeometrieUndTopologie
	@cp GeometrieUndTopologie/full.pdf pdfs/2021_Topologie.pdf


GeometrieUndTopologie/full.gnuplots:
	@$(MAKE) -C GeometrieUndTopologie get-gnuplots


pdfs:
	mkdir pdfs

init:
	@git submodule update --init --recursive --rebase
