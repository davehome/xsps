# Copyright (c) 2012 davehome <davehome@redthumb.info.tm>.
# All rights reserved.
# Distributed under a modified BSD-style license.
# See the COPYING file in the toplevel directory for license details.

## Program name and version
NAME    := xsps
MAJVER  := 0
MINVER  := 0
VERSION := $(MAJVER).$(MINVER)

## Configuration file name
CONF := xsps.json

## Build Targets
XSPS        := $(NAME)
XSPS_STATIC := $(NAME).static
TARGETS     := $(XSPS) $(XSPS_STATIC)

## Build directories
SRCDIR  := src
INCDIR  := include/$(NAME)
VAPIDIR := vapi
TMPDIR  := tmp
LCDIR   := config

## Install Directories
DESTDIR     := $(HOME)/xsps_install
PREFIX      := $(DESTDIR)/usr/local
SYSCONF_DIR := $(DESTDIR)/etc
CDIR        := $(SYSCONF_DIR)/xsps

## Install targets
INST_TARGET=$(PREFIX)/bin/$(XSPS)
STATIC_INST_TARGET=$(PREFIX)/bin/$(XSPS_STATIC)
INSTALL_TARGETS := $(INST_TARGET) $(STATIC_INST_TARGET) $(CDIR)/$(CONF)

## Vala and C source/headers/objects
C_SRC    := $(shell find $(SRCDIR) -type f -name '*.c')
V_SRC    := $(shell find $(SRCDIR) -type f -name '*.vala')
V_HEADER := $(TMPDIR)/$(NAME).h
V_VAPI   := $(patsubst $(SRCDIR)/%.vala,$(TMPDIR)/%.vapi,$(V_SRC))
C_OBJ    := $(patsubst $(SRCDIR)/%.c,$(TMPDIR)/%.o,$(C_SRC))
V_OBJ    := $(patsubst $(SRCDIR)/%.vala,$(TMPDIR)/%.vo,$(V_SRC))
ALL_OBJ  := $(V_OBJ) $(C_OBJ)

## Build programs
PKGC  := pkg-config
VALAC := valac

## Required packages -- internal and external
PKGS               := glib-2.0 gobject-2.0 gee-1.0 json-glib-1.0
NON_VAPI_PKGS      := gthread-2.0
PKG_CFLAGS         := $(shell $(PKGC) --cflags $(PKGS) $(NON_VAPI_PKGS))
PKG_LDFLAGS        := $(shell $(PKGC) --libs $(PKGS) $(NON_VAPI_PKGS))
PKG_STATIC_LDFLAGS := $(shell $(PKGC) --libs --static $(PKGS) $(NON_VAPI_PKGS))
V_INTERNAL_PKGS    := posix defs stdlib
V_PKGS             := $(patsubst %,--pkg=%,$(V_INTERNAL_PKGS) $(PKGS))

## Common C Compiler flags
STD  := -std=c99
OPT  := -O2 -pipe -mtune=generic -fPIC -fPIE -fno-exceptions
SSP  := -fstack-protector-all -D_FORTIFY_SOURCE=2 --param ssp-buffer-size=1
INC  := -I. -Iinclude -I$(INCDIR) -I$(TMPDIR)
WARN := -Werror -Wshadow -Wnested-externs -Wno-overlength-strings \
	-Wvla -Wmissing-declarations -Wdisabled-optimization -pedantic \
	-Wformat -Wformat-security -Werror=format-security
DEB  := -ggdb -DXSPS_DEBUG
DEF  := -D_XOPEN_SOURCE=600 -DXSPS_NAME=\"$(NAME)\" \
	-DXSPS_MAJOR=\"$(MAJVER)\" -DXSPS_MINOR=\"$(MINVER)\"  \
	-DXSPS_CONFIG_DIR=\"$(CDIR)\" -DXSPS_CONFIG=\"$(CONF)\"

## CFLAGS, LDFLAGS and options passed to gcc/valac
XSPS_CFLAGS  := $(CFLAGS) $(STD) $(OPT) $(SSP) $(WARN) $(DEF) $(DEB) $(INC)
XSPS_LDFLAGS := $(LDFLAGS) -Wl,--as-needed
VFLAGS       := --nostdpkg --thread --vapidir=$(VAPIDIR) $(V_PKGS) \
		--basedir=$(SRCDIR) --directory=$(TMPDIR)
FVAPI        := --use-fast-vapi

all: $(V_VAPI) $(TARGETS)

## This builds the half-static executable
## Uses a hack with the linker to build all glib stuff statically
$(XSPS_STATIC): $(ALL_OBJ)
	@echo "[CCLD]		${@F}"
	@$(CCACHE) $(CC) -Wl,-Bstatic $^ $(PKG_STATIC_LDFLAGS) \
		$(XSPS_LDFLAGS) -Wl,-Bdynamic -o $@

## This builds the shared executable
$(XSPS): $(ALL_OBJ)
	@echo "[CCLD]		${@F}"
	@$(CCACHE) $(CC) -pie $^ $(PKG_LDFLAGS) $(XSPS_LDFLAGS) -o $@

## This compiles the C source files to C objects
$(TMPDIR)/%.o: $(SRCDIR)/%.c $(V_HEADER)
	@mkdir -p ${@D}
	@echo "[CC]		${@F}"
	@$(CCACHE) $(CC) -c $< $(PKG_CFLAGS) $(XSPS_CFLAGS) -o $@

## This compiles the Vala source directly to C objects 
$(TMPDIR)/%.vo: $(TMPDIR)/%.vapi
	@mkdir -p ${@D}
	@echo "[VALAC]		${@F}"
	@$(VALAC) $(VFLAGS) --compile --cc="$(CCACHE) $(CC)" \
		$(patsubst %,--Xcc=%,$(XSPS_CFLAGS)) \
		$(subst $(FVAPI)=$<,,$(patsubst %,$(FVAPI)=%,$(V_VAPI))) \
		$(patsubst $(TMPDIR)/%.vapi,$(SRCDIR)/%.vala,$<) --Xcc=-o$@

## Generates .vapi files to satisfy the symbol resolution for the above target
$(TMPDIR)/%.vapi: $(SRCDIR)/%.vala
	@mkdir -p ${@D}
	@echo "[VALAC]		${@F}"
	@$(VALAC) $(VFLAGS) --fast-vapi=$@ $<
	@touch $@

## Generates a C header from all of the Vala files to provide an API to plain C
## Uses a hack to prevent it from generating anything else
## This is only generated if there are actual plain C files to build
$(V_HEADER): $(V_SRC)
	@mkdir -p ${@D}
	@echo "[VALAC]		${@F}"
	@$(VALAC) $(VFLAGS) --compile --cc=true --header=$@ $^

## Install targets

## This installs the shared executable
$(INST_TARGET): $(XSPS)
	@echo "[INSTALL]	$@"
	@test -d ${@D} || mkdir -p ${@D}
	@install -m 0755 $^ $@

## This installs the half-static executable
$(STATIC_INST_TARGET): $(XSPS_STATIC)
	@echo "[INSTALL]	$@"
	@test -d ${@D} || mkdir -p ${@D}
	@install -m 0755 $^ $@

## This installs the global configuration file
$(CDIR)/$(CONF): $(LCDIR)/$(CONF)
	@echo "[INSTALL]	$@"
	@test -d ${@D} || mkdir -p ${@D}
	@install -m 0644 $^ $@

## This installs everything above
install: all $(INSTALL_TARGETS)

## This uninstalls everything above
uninstall:
	@for f in $(INSTALL_TARGETS); do \
		if [ -f $$f ]; then \
			echo "[UNINSTALL]	$$f" && \
			rm -f $$f; \
		fi; \
	done

## Strips debugging symbols from binaries
strip:
	@for f in $(TARGETS); do \
		if [ -f $$f ]; then \
			echo "[STRIP]		$$f" && \
			strip --strip-debug $$f; \
		fi; \
	done

## Shows the CFLAGS and LDFLAGS to help you find the required libs to build
show-flags:
	@echo "cflags: \"$(PKG_CFLAGS)\"\n"
	@echo "ldflags: \"$(PKG_LDFLAGS)\"\n"
	@echo "static ldflags: \"$(PKG_STATIC_LDFLAGS)\""

## Removes the tmp dir and the binaries
clean:
	@rm -rf $(TMPDIR) $(TARGETS)
	@echo "[Clean]"

## Shortcut for 'clean'
c: clean

## Tell Make to not do filesystem lookups for these targets
.PHONY: all install uninstall strip show-flags clean c
