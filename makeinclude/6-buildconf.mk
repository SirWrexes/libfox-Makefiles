##
## EPITECH PROJECT, 2019
## Multipart Makefile
## File description:
## Build and test config
##

ifndef MKBUILDCONF
MKBUILDCONF := 1

#
# Build settings
############################################################################################
INCDIRS := ./include
INCDIRS += ./lib/libfox/extra/include
# ---------------------------------------------------------------------------------------- #
CFLAGS  := -std=gnu99
CFLAGS  += -Werror
CFLAGS  += -Wall -Wextra
CFLAGS  += -Wdouble-promotion
CFLAGS  += -Wno-implicit-fallthrough
CFLAGS  += -fdiagnostics-color=auto
CFLAGS  += $(foreach dir, $(INCDIRS), -iquote $(dir))
CFLAGS  += $(CUSTOM_CFLAGS)
# ---------------------------------------------------------------------------------------- #
LDFLAGS += $(foreach mod, $(FOXMODULES), -L./lib/libfox/$(strip $(mod)))
LDLIBS  += $(foreach mod, $(FOXMODULES), -lfox_$(strip $(mod)))
LDLIBS  += $(foreach lib, $(LIBS), -l$(strip $(lib)))
# ---------------------------------------------------------------------------------------- #
OBJ     := $(SRC:.c=.o) $(DEPSRC:.c=.o)
DEP     := $(OBJ:.o=.d) $(DEPSRC:.c=.d) $(MAIN:.c=.d)
-include $(DEP)
.PRECIOUS := $(DEP)
# ---------------------------------------------------------------------------------------- #
COV     := $(notdir $(OBJ:.o=.gc*)) $(notdir $(TST:.c=.gc*)) $(notdir $(WRAPSRC:.c=.gc*))
############################################################################################


#
# Test config
############################################################################################
UTFLAGS   := --always-succeed --timeout 5
# ---------------------------------------------------------------------------------------- #
WRAPFLAGS := $(shell grep -qR 'wrap_close.h' tests/ 2>/dev/null && echo -n "-Wl,--wrap=close")
WRAPFLAGS += $(shell grep -qR 'wrap_malloc.h' tests/ 2>/dev/null && echo -n "-Wl,--wrap=malloc")
WRAPFLAGS += $(shell grep -qR 'wrap_open.h' tests/ 2>/dev/null && echo -n "-Wl,--wrap=open")
WRAPFLAGS += $(shell grep -qR 'wrap_read.h' tests/ 2>/dev/null && echo -n "-Wl,--wrap=read")
WRAPFLAGS += $(shell grep -qR 'wrap_write.h' tests/ 2>/dev/null && echo -n "-Wl,--wrap=write")
# ---------------------------------------------------------------------------------------- #
COVFLAGS  := -s --exclude-unreachable-branches
COVFLAGS  += $(foreach s, $(DEPSRC), -e $(notdir $(s)))
COVFLAGS  += --exclude='.*test_.*'
COVFLAGS  += --exclude='.*wrap_.*'
COVFLAGS  += --exclude-directories 'lib'
# ---------------------------------------------------------------------------------------- #
# Run `make tests SHOW_BRANCHES=1` to get branch coverage report
# 1 could actually be any value, all we need is for the variable to exist.
REPORTTXT := "TEST REPORT"
ifdef SHOW_BRANCHES
    COVFLAGS += -b
    REPORTTXT += "(branches)"
endif
############################################################################################

endif
