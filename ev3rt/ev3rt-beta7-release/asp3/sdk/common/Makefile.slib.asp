# Common Makefile for static libraries
# This file can ONLY be included directly from Makefile of static libraries
# DO NOT EDIT BELOW THIS LINE UNLESS YOU KNOW WHAT YOU ARE DOING
# ==============================================================

# v850 
GCC_TARGET_PREFIX = v850-elf-
CXX := $(GCC_TARGET_PREFIX)g++
AR := $(GCC_TARGET_PREFIX)ar

LIB_MKFILE_IDX := $(words $(MAKEFILE_LIST))
MKFILE_PATH := $(abspath $(word $(shell echo $$(($(LIB_MKFILE_IDX) - 1))),$(MAKEFILE_LIST)))
CURRENT_DIR := $(EV3RT_SDK_LIB_DIR)/$(notdir $(patsubst %/,%,$(dir $(MKFILE_PATH))))

THIS_LIB_SRC_DIR   := $(CURRENT_DIR)/src
THIS_LIB_OBJ_DIR   := static-lib/$(THIS_LIB_NAME)

ifdef BUILD_LOADABLE_MODULE
THIS_LIB_ARC_FILE  := $(CURRENT_DIR)/$(THIS_LIB_NAME)-loadable.a
else
THIS_LIB_ARC_FILE  := $(CURRENT_DIR)/$(THIS_LIB_NAME)-standalone.a
endif
THIS_LIB_OBJ_FILES := $(addprefix $(THIS_LIB_OBJ_DIR)/,$(THIS_LIB_OBJS))
THIS_LIB_CXXOBJ_FILES := $(addprefix $(THIS_LIB_OBJ_DIR)/,$(THIS_LIB_CXXOBJS))

APPL_LIBS := $(APPL_LIBS) $(THIS_LIB_ARC_FILE)
INCLUDES := $(INCLUDES) -I$(CURRENT_DIR)/include

ifeq (,$(wildcard $(THIS_LIB_ARC_FILE)))
WORKSPACE_LIB_TO_BUILD := $(WORKSPACE_LIB_TO_BUILD) $(THIS_LIB_ARC_FILE)
endif

SOURCES=$(wildcard $(THIS_LIB_SRC_DIR)/*.cpp)
OBJECTS=$(notdir $(SOURCES:.cpp=.o))

.SUFFIXES: .cpp .o

$(THIS_LIB_ARC_FILE): $(THIS_LIB_CXXOBJ_FILES)
	$(call print_cmd, "AR[L]", $@)
	@rm -f $@
	@$(AR) -rcs $@ $^
##	@rm -f $^

$(THIS_LIB_CXXOBJ_FILES): $(THIS_LIB_OBJ_DIR)/%.o: $(THIS_LIB_SRC_DIR)/%.cpp
	$(call print_cmd, "CXX[L]", $<)
	@mkdir -p $(shell dirname $@)
	@$(CXX) -c $(INCLUDES) $(CFLAGS) -c $< -o $@

all: $(THIS_LIB_CXXOBJ_FILES)

#
# Clear input arguments
#
THIS_LIB_NAME := 
THIS_LIB_OBJS := 
THIS_LIB_CXXOBJS := 

