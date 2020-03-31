##
## EPITECH PROJECT, 2019
## Multipart Makefile
## File description:
## Automatic detection of libfox module usage
##

ifndef FOXAUTOCONFIG

$(if $(wildcard */libfox),,$(eval NOLIBFOX=1))

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

for mod in $$(ls ./lib/libfox | grep -ve 'Makefile');
    do
        grep -qR "fox_$$mod.h"      \
		    src/ tests/             \
		    && echo -n "$$mod "
    done
endef

#
# Write the script in its file
#########################################################
FOXSCRIPT := .foxconfig
$(call export FOXAUTOCONFIG) $(file >$(FOXSCRIPT),$(FOXAUTOCONFIG))
#########################################################

#
# Check what module is used in the project
#########################################################
FOXMODULES := $(strip $(shell $(SHELL) $(FOXSCRIPT)))
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
