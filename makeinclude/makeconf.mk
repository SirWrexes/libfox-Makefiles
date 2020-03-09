##
## EPITECH PROJECT, 2019
## Multipart Makefile
## File description:
## Make configuration for modules
##

ifndef MKCONF
MKCONF := 1

#
# Config
##########################################
ifeq "$(NAME)" ""
    NAME        := Untitled project
endif
ifeq "$(BIN)" ""
    BIN         := a.out
endif
TESTBIN         := utest_$(BIN)
DEBUGBIN        := debug_$(BIN)
SHELL           ?= $(shell which bash)
MAKE            := make --no-print-directory -C
RM              := rm -f
CP              := cp -t
MV              := mv -t
GCOV            := gcovr
CC              := gcc
CTAGS           := tags
COMPILEDB       := compile_commands.json
COMPILEDBTARGET := all tests debug
.DEFAULT_GOAL   := all
##########################################

endif
