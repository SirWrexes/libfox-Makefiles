##
## EPITECH PROJECT, 2019
## Multipart Makefile
## File description:
## Automatic detection of libfox module usage
##

ifndef FOXMODULES
FOXMODULES := 1

#
# Find the 'libfox' directory in subfolders
#########################################################
FOXDIR := $(firstword $(wildcard */libfox))
$(if $(FOXDIR),,$(eval NOLIBFOX=1)) # If none is found, disable libfox usage
#########################################################


#
# If libfox dir hasn't been found, don't bother.
#########################################################
ifndef NOLIBFOX
    #
    # Create the script
	# (Yeah, the lack of indentation here triggers me too but
	#  it's a necessary thing. I'm sincerely sorry.)
    #########################################################
define FOXAUTOCONFIG
#!$(SHELL)
#
# .foxconfig.sh
# Copyright (C) 2019 renard <renard@voyager>
#
# Distributed under terms of the MIT license.
#

grep -qRE 'wrap_(close|malloc|open|read|write)\.h' \
    src/ tests/                                    \
    && echo -n "wrap_libc "

grep -qRE 'fox_(list|stack|tree)\.h' \
    src/ tests/                      \
    && echo -n "datastruct "

for mod in $$(ls $(FOXDIR) | grep -ve 'Makefile');
    do
        grep -qR "fox_$$mod.h"      \
            src/ tests/             \
            && echo -n "$$mod "
    done
endef
    #########################################################

    #
    # Write the script in its file
    #########################################################
    FOXSCRIPT := .foxconfig
    $(call export FOXAUTOCONFIG)
    $(file >$(FOXSCRIPT),$(FOXAUTOCONFIG))
    #########################################################

    #
    # Check what module is used in the project
    #########################################################
    FOXMODULES := $(strip $(shell $(SHELL) $(FOXSCRIPT)))
    # This sounds redundant, but is necessary to execute the
    # script without having to give it X permission.
    #########################################################

    #
    # If no libfox module is used, get the coverage at least.
    #########################################################
    ifneq "$(strip $(FOXMODULES))" ""
        FOXRULE = $(FOXMODULES)
    else
        FOXRULE = tests
    endif
    #########################################################
endif
#############################################################

endif
