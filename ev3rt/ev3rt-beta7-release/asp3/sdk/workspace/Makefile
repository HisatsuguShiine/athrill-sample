#
# Makefile for a workspace of EV3 Platform(ASP3).
#

#
# Include configurations of EV3RT(ASP3) SDK
#

# target folder check flag
TARGET_EXIST=0

ifndef app
TARGET_EXIST=0
endif

SDKDIR = ..
WSPDIR = $(basename $(PWD))
ASPMAKEFILE = Makefile.asp

ifdef app
ifeq ($(shell test -d $(WSPDIR)/$(app) && echo -n yes),yes)
     TARGET_EXIST=1
endif
endif

ifeq ($(TARGET_EXIST), 1)

include $(SDKDIR)/Makefile.sdk.conf
.PHONY: all
all: 
	@mkdir -p $(WSPDIR)/$(app)/deps
	@make --file $(ASPMAKEFILE) -C $(app) all
clean:
	@make --file $(ASPMAKEFILE) -C $(app) clean

.PHONY: clean
else
usage:
	 @echo make app="<folder>"
endif
