all: alma geotopo

alma:
	$(MAKE) -C AlgorithmischeMathematik2
	@cp AlgorithmischeMathematik2/full.pdf 2021_Algorithmische_Mathematik.pdf

geotopo:
	$(MAKE) -C GeometrieUndTopologie
	@cp GeometrieUndTopologie/full.pdf 2021_Topologie.pdf

init:
	git submodule update --init --recursive --rebase
	git submodule foreach make init-git-hooks
