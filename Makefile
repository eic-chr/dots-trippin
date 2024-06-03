##
# Project Title
#
# @file
# @version 0.1
UNAME := $(shell uname)

PHONY+=all

ifeq ($(UNAME), Linux)
SUBDIR := linux 
endif
ifeq ($(UNAME), Darwin)
SUBDIR := darwin
endif

PHONY+=all
PHONY+=update
PHONY+=apply
all update apply:
	$(MAKE)	-C $(SUBDIR) $@



.PHONY: $(PHONY)
