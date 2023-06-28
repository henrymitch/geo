PROJ_NAME=geo
COMPILER=ghc

SRC_DIR=src
SRCS=$(wildcard $(SRC_DIR)/*.hs)
LEXER=${SRC_DIR}/Lexer.x

OUT_DIR=out

# MAIN
$(PROJ_NAME): lexer parser $(SRCS)
	mkdir -p $(OUT_DIR)
	$(COMPILER) -hidir $(OUT_DIR) -odir $(OUT_DIR) -o $(OUT_DIR)/$@ $(SRCS)

lexer: $(SRC_DIR)/Lexer.x
	alex -d -i -o $(SRC_DIR)/Lexer.hs $^

parser: $(SRC_DIR)/Parser.y
	happy -a -d -i -o $(SRC_DIR)/Parser.hs $^

run: $(PROJ_NAME)
	./$(OUT_DIR)/$< $(INFILE)

docs: $(SRCS)
	mkdir -p $(OUT_DIR)/docs
	haddock --html -o $(OUT_DIR)/docs $(SRCS)

clean: $(PROJ_NAME)
	rm -r ./$(OUT_DIR)
