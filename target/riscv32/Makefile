# This file is part of the OpenADK project. OpenADK is copyrighted
# material, please see the LICENCE file in the top-level directory.

include $(ADK_TOPDIR)/rules.mk
include $(ADK_TOPDIR)/mk/kernel-build.mk
include $(ADK_TOPDIR)/mk/image.mk

KERNEL:=$(LINUX_DIR)/arch/riscv/boot/Image
QEMU_ARGS:=-M virt -m 256 -nographic -device loader,file=$(FW_DIR)/$(TARGET_KERNEL),addr=0x80200000 
ifeq ($(ADK_TARGET_QEMU_WITH_VIRTIO),y)
QEMU_ARGS+=-netdev user,id=eth0 -device virtio-net-device,netdev=eth0
endif
ifeq ($(ADK_TARGET_FS),archive)
QEMU_ARGS+=-device virtio-blk-device,drive=vda -drive file=qemu-${ADK_TARGET_CPU_ARCH}.img,if=none,id=vda,format=raw
endif

# target helper text
ifeq ($(ADK_TARGET_FS),archive)
targethelp:
	@echo "The RootFS tarball is: $(FW_DIR)/$(ROOTFSTARBALL)"
ifeq ($(ADK_TARGET_QEMU),y)
	@echo 'The kernel file is: $(FW_DIR)/${TARGET_KERNEL}'
	@echo "Use following command to create a QEMU Image:"
	@echo "./scripts/create.sh qemu-${ADK_TARGET_CPU_ARCH}.img $(FW_DIR)/$(ROOTFSTARBALL)"
	@echo "Start qemu with following options:"
	@echo 'qemu-system-${ADK_TARGET_CPU_ARCH} ${QEMU_ARGS} -kernel $(FW_DIR)/fw_jump.elf'
endif
endif
ifeq ($(ADK_TARGET_FS),initramfs)
targethelp:
	@echo 'The kernel file is: $(FW_DIR)/${TARGET_KERNEL}'
	@echo 'The initramfs image is: ${FW_DIR}/${INITRAMFS}'
ifeq ($(ADK_TARGET_QEMU),y)
	@echo "Start qemu with following command line:"
	@echo 'qemu-system-riscv32 ${QEMU_ARGS} -kernel $(FW_DIR)/fw_jump.elf -initrd ${FW_DIR}/${INITRAMFS}'
endif
endif
ifeq ($(ADK_TARGET_FS),initramfsarchive)
targethelp:
	@echo 'The kernel file is: $(FW_DIR)/${TARGET_KERNEL}'
	@echo "The RootFS tarball is: $(FW_DIR)/$(ROOTFSUSERTARBALL)"
endif
ifeq ($(ADK_TARGET_FS),initramfspiggyback)
targethelp:
	@echo 'The kernel+initramfs file is: $(FW_DIR)/${TARGET_KERNEL}'
ifeq ($(ADK_TARGET_QEMU),y)
	@echo "Start qemu with following command line:"
	@echo 'qemu-system-riscv32 ${QEMU_ARGS} -kernel $(FW_DIR)/fw_jump.elf'
endif
endif

kernel-strip:

kernel-install: kernel-strip
	 @cp $(KERNEL) $(FW_DIR)/$(TARGET_KERNEL)

bbl:
	@rm -rf $(BUILD_DIR)/opensbi
	(cd $(BUILD_DIR)/ && git clone https://github.com/riscv/opensbi.git)
	(cd $(BUILD_DIR)/opensbi && PATH='$(HOST_PATH)' \
		CROSS_COMPILE=$(GNU_TARGET_NAME)- \
		PLATFORM=qemu/virt make)
	cp $(BUILD_DIR)/opensbi/build/platform/qemu/virt/firmware/fw_jump.elf $(FW_DIR)

# filesystem specific targets
ifeq ($(ADK_TARGET_FS),initramfs)
imageinstall: kernel-install bbl $(FW_DIR)/$(INITRAMFS) targethelp
endif
ifeq ($(ADK_TARGET_FS),initramfsarchive)
imageinstall: kernel-install bbl $(FW_DIR)/$(ROOTFSUSERTARBALL) targethelp
endif
ifeq ($(ADK_TARGET_FS),initramfspiggyback)
imageinstall: createinitramfs bbl targethelp
endif
