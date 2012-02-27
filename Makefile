TARGET := xsps

PREFIX := /usr/local
DESTDIR :=
INSTALL_DIR := $(DESTDIR)$(PREFIX)/bin
INSTALL_TARGET := $(INSTALL_DIR)/$(TARGET)
XSPS_CONFIG_DIR := ./config

SRC := $(shell find src -type f -name '*.cc')
OBJ := $(patsubst src/%.cc,tmp/%.o,$(SRC))

STD := -std=c++0x

ifeq ("$(CXX)","clang++")
ifeq ("$(STD)", "-std=c++0x")
	STD=-std=c++11
endif
endif

WARN := -Wall -Werror -pedantic
OPTZ := -ggdb -O2 -pipe -mtune=generic\
	-funroll-loops -fno-exceptions -fstack-protector-all\
	-D_FORTIFY_SOURCE=2
DEBUG := -DXSPS_DEBUG
STATIC :=
INCLUDE := -Isrc -Iinclude
DEFINES := -DXSPS_CONFIG_DIR=\"$(XSPS_CONFIG_DIR)\"
CFLAGS := $(WARN) $(STATIC) $(OPTZ) $(DEFINES) $(DEBUG)
CXXFLAGS := $(STD) $(CFLAGS) $(INCLUDE)
LDFLAGS := $(STD) $(STATIC) -Wl,--as-needed


all: $(TARGET)
	@echo "[DONE]	Nothing more to be done for \`$^'."

tmp/%.o: src/%.cc
	@mkdir -p ${@D}
	@echo "[CXX]	$@"
	@$(CXX) $(CXXFLAGS) -c $< -o $@

$(TARGET): $(OBJ)
	@echo "[LD]	$@"
	@$(CXX) $(LDFLAGS) $^ -o $@

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
