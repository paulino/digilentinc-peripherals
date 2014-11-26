.PHONY:	clean
BUILD_DIR = build

VPATH = $(BUILD_DIR)

BASE_FILE = digilent_peripherals
PDF_FILE = $(BASE_FILE).pdf
FIGURES_EPS = figure-buttons-controller.eps figure-display-controller.eps figure-leds-controller.eps figure-switches-controller.eps figure-display-blocks.eps
#figures_png = $(patsubst %.png,%.eps,$(figures_eps))

all: $(PDF_FILE) 

$(PDF_FILE): $(FIGURES_EPS) $(BASE_FILE).tex 
	cd $(BUILD_DIR) ; pdflatex ../$(BASE_FILE).tex ; pdflatex ../$(BASE_FILE).tex
	cp $(BUILD_DIR)/$@ .

html: $(FIGURES_EPS) $(BASE_FILE).tex
	latex2html $(BASE_FILE).tex

%.eps:	%.odg
	cd $(BUILD_DIR) ; soffice  --invisible --convert-to eps ../$<
	cd $(BUILD_DIR) ; convert  $@ $(basename $@).png
	

clean:
	cd $(BUILD_DIR) ; rm $(FIGURES_EPS) $(BASE_FILE).pdf $(BASE_FILE).pdf $(BASE_FILE).aux
