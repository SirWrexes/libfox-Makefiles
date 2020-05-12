##
## EPITECH PROJECT, 2019
## Multipart Makefile
## File description:
## Master Makefile
##

#
# Do NOT change the order of those
# It will likely break the makefile
##########################################
# ↓ Project/binary name and sources
include ./makeinclude/1-project.mk

# ↓ Makefile configuration
include ./makeinclude/2-makeconf.mk

# ↓ Colors and text formatting
include ./makeinclude/3-format.mk

# ↓ Progress bar script
include ./makeinclude/4-progress.mk

# ↓ Libfox module detection
include ./makeinclude/5-foxmodules.mk

# ↓ Various build configuration
include ./makeinclude/6-buildconf.mk

# ↓ Rules (for %.a and %.o)
include ./makeinclude/7-rules.mk

# ↓ Reciepes for making targets
include ./makeinclude/8-recipes.mk
##########################################
