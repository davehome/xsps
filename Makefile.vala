# Copyright (c) 2012 davehome <davehome@redthumb.info.tm>.
# All rights reserved.
# Distributed under a modified BSD-style license.
# See the COPYING file in the toplevel directory for license details.

VALAC := valac

TARGET := gxsps
XSPS_CONFIG_DIR := config

PREFIX := /usr/local
DESTDIR :=
INSTALL_DIR := $(DESTDIR)$(PREFIX)/bin
INSTALL_TARGET := $(INSTALL_DIR)/$(TARGET)

SRC   := $(shell find src -type f -name '*.c')
OBJ   := $(patsubst src/%.c,tmp/%.o,$(SRC))
VSRC  := $(shell find include src -type f -name '*.va*')
VCSRC := tmp/vmain.c
VCOBJ := $(subst tmp/main.o,,$(OBJ))
VOBJ  := tmp/vmain.o

LIBS := -lconfuse

STD := -std=c99
WARN := -Wall -Wextra -Werror -Wshadow -Wformat=2 -Wconversion\
	-Wformat-security -pedantic -Wnested-externs -Wvla\
	-Wno-overlength-strings -Wmissing-declarations -Wdisabled-optimization\
	--param ssp-buffer-size=1
OPTZ := -O2 -pipe -mtune=generic -fPIC -funroll-loops -fno-exceptions\
	-fstack-protector-all -D_FORTIFY_SOURCE=2
DEBUG := -ggdb -DXSPS_DEBUG
STATIC :=
INCLUDE := -Iinclude
DEFINES := -DXSPS_CONFIG_DIR=\"$(XSPS_CONFIG_DIR)\" -D_REENTRANT\
	   -D_XOPEN_SOURCE=600
CFLAGS  := $(STD) $(WARN) $(STATIC) $(OPTZ) $(DEFINES) $(DEBUG) $(INCLUDE) \
	   $(shell pkg-config --cflags glib-2.0 gio-2.0)
LDFLAGS := $(STD) $(STATIC) $(LIBS) $(shell pkg-config --libs glib-2.0 gio-2.0)\
	   -Wl,--as-needed

all: $(TARGET)

$(TARGET): $(VOBJ) $(VCOBJ)
	@echo "[LD]	$@"
	@$(CC) $(LDFLAGS) $^ -o $@

$(VOBJ): $(VSRC)
	@mkdir -p ${@D}
	@echo "[VC]	$@"
	@valac --save-temps -c --Xcc=-o$@ -b src -d tmp \
	      --vapidir=include --use-fast-vapi $^

tmp/%.o: src/%.c
	@mkdir -p ${@D}
	@echo "[CC]	$@"
	@$(CC) $(CFLAGS) -c $< -o $@

clean:
	@rm -rf tmp $(TARGET)
	@echo "[CLEAN]"

install: $(INSTALL_TARGET)

$(INSTALL_TARGET): $(TARGET)
	@echo "[INSTALL]	$@"
	@mkdir -p $(INSTALL_DIR)
	@install -m0755 $< $@

uninstall:
	@echo "[UNINSTALL]	$(INSTALL_TARGET)"
	@rm -f $(INSTALL_TARGET)

.PHONY: all clean install uninstall