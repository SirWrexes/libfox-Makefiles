##
## EPITECH PROJECT, 2019
## Multipart Makefile
## File description:
## Progress bar script generation
##

ifndef PROGBAR-CODE

# Using the username doesn't work.
# ifneq "$(USER)" "bugs"
#  # The autograder doesn't support coloured output.
#  # Deactivate it when building from there.
#    BARCOLOR := \033[38;2;255;167;4m
#    COLOROFF := \033[0m
# endif

define PROGBAR-CODE
#!$(shell which python)
import argparse
import math
import sys

def main():
  parser = argparse.ArgumentParser(description=__doc__)
  parser.add_argument("--stepno", type=int, required=True)
  parser.add_argument("--nsteps", type=int, required=True)
  parser.add_argument("remainder", nargs=argparse.REMAINDER)
  args = parser.parse_args()

  nchars = int(math.log(args.nsteps, 10)) + 1
  fmt_str = "$(BARCOLOR)[$(strip $(subst ",, $(NAME))) | {:Xd}/{:Xd} | {:6.2f}%]$(COLOROFF)".replace("X", str(nchars))
  progress = 100 * args.stepno / args.nsteps
  sys.stdout.write(fmt_str.format(args.stepno, args.nsteps, progress))
  for item in args.remainder:
    sys.stdout.write(" ")
    sys.stdout.write(item)
  sys.stdout.write("\n")

if __name__ == "__main__":
  main()
endef

PROGSCRIPT := .progbar
$(call export PROGBAR-CODE) $(file >$(PROGSCRIPT),$(PROGBAR-CODE))
endif

ifndef ECHO$(BIN)
  T := $(shell $(MAKE) . $(MAKECMDGOALS)	-nrR \
	  ECHO$(BIN)="COUNT$(BIN)" | grep -c "COUNT$(BIN)")
  N := x
  _stepno = --stepno=$(words $N) $(eval N := $N x)
  ECHO$(BIN) = python ./$(PROGSCRIPT) $(call _stepno) --nsteps=$T
endif
