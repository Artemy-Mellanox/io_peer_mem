#
# By default, the build is done against the running linux kernel source.
# To build against a different kernel source tree, set SYSSRC:
#
#    make SYSSRC=/path/to/kernel/source

ifdef SYSSRC
 KERNEL_SOURCES	 = $(SYSSRC)
else
 KERNEL_UNAME	:= $(shell uname -r)
 KERNEL_SOURCES	 = /lib/modules/$(KERNEL_UNAME)/build
endif

export KBUILD_EXTRA_SYMBOLS=${MOFED_PATH}/Module.symvers

build: modules
.PHONY: build

install: modules_install
.PHONY: install

%::
	$(MAKE) -C $(KERNEL_SOURCES) M=$$PWD $@

insmod: build
	-sudo rmmod io_peer_mem
	sudo insmod $$PWD/io_peer_mem.ko
