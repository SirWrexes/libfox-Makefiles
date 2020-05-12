##
## EPITECH PROJECT, 2019
## Multipart Makefile
## File description:
## Reciepes
##

ifndef MKRECIEPES
MKRECIEPES :=1

#
# Compile DB and C tags (recommended if you use vim with YouCompleteMe)
#########################################################################################
.PHONY: completion-tools
completion-tools: ctags compiledb
# ------------------------------------------------------------------------------------- #
.PHONY: compiledb
ifneq "$(shell which compiledb 2>/dev/null)" ""
compiledb:
	@$(ECHO$(BIN)) $(CBOLD)$(CLIGHTBLUE)"Create"$(CRESET) $(CLIGHTBLUE)"$(COMPILEDB)"$(CRESET)
	@compiledb -no $(COMPILEDB) make -nrRki $(COMPILEDBTARGET) ECHO$(BIN)='echo' 2>/dev/null
	@$(ECHO$(BIN)) $(CBOLD)$(CLIGHTBLUE)"Done."$(CRESET)
else
compiledb:
	@$(ECHO$(BIN)) $(CRED)"compiledb "$(CBOLD)" is not installed"$(CRESET)$(CRED)", cannot create $(COMPILEDB)"
endif
# ------------------------------------------------------------------------------------- #
.PHONY: ctags
ifneq "$(shell which ctags 2>/dev/null)" ""
ctags: CURRDIR := $(shell pwd)
ctags:
	@$(ECHO$(BIN)) $(CBOLD)$(CLIGHTBLUE)"Create"$(CRESET) $(CLIGHTBLUE)"$(CTAGS)"$(CRESET)
	@ctags -R .
	@$(ECHO$(BIN)) $(CBOLD)$(CLIGHTBLUE)"Done."$(CRESET)
else
ctags:
	@$(ECHO$(BIN)) $(CRED)"ctags "$(CBOLD)" is not installed"$(CRESET)$(CRED)", cannot create $(ctags)"
endif
# ------------------------------------------------------------------------------------- #
$(BIN): completion-tools
$(DEBUGBIN): completion-tools
$(TESTBIN): completion-tools
#########################################################################################

#
# Libfox modules
#########################################################################################
.PHONY: libfox
ifdef NOLIBFOX
libfox:
	@$(ECHO$(BIN)) $(CRED)$(CBOLD)"Skip libfox reciepe"$(CRESET)
else
libfox:
	@echo
	@$(ECHO$(BIN)) $(CORANGE)"Make libfox rule(s)"$(CRESET) $(CBOLD)$(foreach r,$(FOXRULE),"$r")$(CRESET)
	@echo -e "\n"$(CORANGE)"*** START LIBFOX BUILD LOG ***\n"$(CRESET)
	@$(MAKE) $(FOXDIR) $(FOXRULE)
	@echo -e $(CORANGE)"*** STOP LIBFOX BUILD LOG ***\n"$(CRESET)
endif
#########################################################################################


#
# Build
#########################################################################################
.PHONY: build
build: $(FILES)
	@$(RM) $(COV)
	@$(CC) -o $(TARGET) $(CFLAGS) $(FILES) $(LDFLAGS) $(LDLIBS)	$(CMDOPTS)
	@$(ECHO$(BIN)) $(CBOLD)"Link OK"$(CRESET)
	@$(ECHO$(BIN)) $(CBOLD)$(CLIGHTBLUE)"Done compiling"$(CRESET) $(CLIGHTBLUE)"$(TARGET)"$(CRESET)
#########################################################################################


#
# Main target
#########################################################################################
.PHONY: all $(NAME) run
all: $(NAME)
$(NAME): $(BIN)
$(BIN): TARGET          := $(BIN)
$(BIN): COMPILEDBTARGET := $(BIN)
$(BIN): OBJ             += $(MAIN:.c=.o)
$(BIN): FILES           := $(OBJ)
$(BIN): libfox
$(BIN): $(OBJ) $(MAIN:.c=.o) build
# ------------------------------------------------------------------------------------- #
run: all
	./$(BIN)
#########################################################################################


#
# Debug target
#########################################################################################
.PHONY: debug
debug: $(DEBUGBIN)
$(DEBUGBIN): TARGET  := $(DEBUGBIN)
$(DEBUGBIN): CFLAGS  += -ggdb3 -rdynamic
$(DEBUGBIN): SRC     += $(MAIN)
$(DEBUGBIN): libfox
	$(CC) -o $(DEBUGBIN) $(CFLAGS) $(SRC) $(CMDOPTS) $(LDFLAGS) $(LDLIBS)
#########################################################################################


#
# Test target
#########################################################################################
.PHONY: tests
tests: test_report
$(TESTBIN): TARGET          := $(TESTBIN)
$(TESTBIN): COMPILEDBTARGET := $(TESTBIN)
$(TESTBIN): FILES           += $(SRC) $(TST) $(WRAPSRC)
$(TESTBIN): CFLAGS          += --coverage
$(TESTBIN): CFLAGS          += $(WRAPFLAGS)
$(TESTBIN): LDLIBS          += -l criterion
$(TESTBIN): FOXRULE         := $(subst tests,,$(FOXRULE)) tests
$(TESTBIN): libfox build
# ------------------------------------------------------------------------------------- #
.PHONY: test_report
test_report: rm_test_files $(TESTBIN)
	@$(ECHO$(BIN)) $(CUNDERLN)$(CGREEN)$(REPORTTXT)$(CRESET)
	@./$(TESTBIN) $(UTFLAGS)
	@$(RM) $(notdir $(DEPSRC:.c=.gc*) $(WRAPSRC:.c=.gc*))
	-@$(GCOV) $(COVFLAGS)
#########################################################################################


#
# Cleanup
#########################################################################################
.PHONY: rm_test_files
rm_test_files:
	@$(ECHO$(BIN)) $(CRED)"Delete"$(CRESET)" test temp files"
	@$(foreach tmp, $(TESTTMP), $(RM) $(tmp))
# ------------------------------------------------------------------------------------- #
.PHONY: rm_fox_script
rm_fox_script:
	@$(ECHO$(BIN)) $(CRED)"Delete"$(CRESET)" libfox config script ($(FOXSCRIPT))"
	@$(RM) $(FOXSCRIPT)
# ------------------------------------------------------------------------------------- #
.PHONY: clean
clean: FOXRULE := clean
clean: OBJ     += $(MAIN:.c=.o)
clean: rm_test_files
ifndef NOLIBFOX
clean: libfox rm_fox_script
endif
	@$(ECHO$(BIN)) $(CRED)"Delete"$(CRESET)" objects"
	@$(RM) $(OBJ)
	@$(ECHO$(BIN)) $(CRED)"Delete"$(CRESET)" dependency files"
	@$(RM) $(DEP)
	@$(ECHO$(BIN)) $(CRED)"Delete"$(CRESET)" coverage files"
	@$(RM) $(COV)
	@$(ECHO$(BIN)) $(CRED)"Delete"$(CRESET)" progress bar script ($(PROGSCRIPT))"
	@$(RM) $(PROGSCRIPT)
# ------------------------------------------------------------------------------------- #
.PHONY: fclean
fclean: FOXRULE := fclean
fclean: OBJ     += $(MAIN:.c=.o)
fclean: rm_test_files
ifndef NOLIBFOX
fclean: libfox rm_fox_script
endif
fclean:
	@$(ECHO$(BIN)) $(CRED)"Delete"$(CRESET)" $(COMPILEDB)"
	@$(RM) $(COMPILEDB)
	@$(ECHO$(BIN)) $(CRED)"Delete"$(CRESET)" $(CTAGS)"
	@$(RM) $(CTAGS)
	@$(ECHO$(BIN)) $(CRED)"Delete"$(CRESET)" objects"
	@$(RM) $(OBJ)
	@$(ECHO$(BIN)) $(CRED)"Delete"$(CRESET)" dependency files"
	@$(RM) $(DEP)
	@$(ECHO$(BIN)) $(CRED)"Delete"$(CRESET)" coverage files"
	@$(RM) $(COV)
	@$(ECHO$(BIN)) $(CRED)"Delete"$(CRESET) $(BIN)
	@$(RM) $(BIN)
	@$(ECHO$(BIN)) $(CRED)"Delete"$(CRESET) $(TESTBIN)
	@$(RM) $(TESTBIN)
	@$(ECHO$(BIN)) $(CRED)"Delete"$(CRESET) $(DEBUGBIN)
	@$(RM) $(DEBUGBIN)
	@$(ECHO$(BIN)) $(CRED)"Delete"$(CRESET)" progress bar script ($(PROGSCRIPT))"
	@$(RM) $(PROGSCRIPT)
# ------------------------------------------------------------------------------------- #
.PHONY: re
re:
	@$(MAKE) . fclean
	@$(MAKE) . $(.DEFAULT_GOAL)
#########################################################################################

endif
