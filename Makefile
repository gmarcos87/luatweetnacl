
# ----------------------------------------------------------------------
# Use environment variables to override the default options:
#      CC, LUA, CFLAGS, FPIC, LUA_CFLAGS, LDFLAGS
#  for example: CC=mips-linux-gcc LUA_LIB=lua5.2 make


LUA ?= lua5.1
LUA_CFLAGS ?= -I/usr/include/$(LUA)
LUA_LIB ?= m -L/usr/local/lib -l$(LUA)
# ----------------------------------------------------------------------

CC ?= gcc
FPIC ?= -fPIC
CFLAGS ?= -Os

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
	LDFLAGS += -bundle -undefined dynamic_lookup
endif

OBJS= luatweetnacl.o randombytes.o tweetnacl.o

%.o: src/%.c
	$(CC) $(LUA_CFLAGS) $(CFLAGS) $(LDFLAGS) $(FPIC) -c -o $@ $<

compile: $(OBJS)
	$(CC) -shared $(FPIC) -o luatweetnacl.so -l$(LUA_LIB) $(OBJS)

test: compile
	$(LUA) src/smoketest.lua

clean:
	rm -f *.o *.a *.so

install: compile
	mkdir -p $(DESTDIR)
	cp -pR *.so $(DESTDIR)/

.PHONY: clean 
