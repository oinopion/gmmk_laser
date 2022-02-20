#########################
####  Main commands  ####
#########################

.PHONY: build
build: gmmk_pro_ansi_gmmk_laser.bin
	@echo Build complete.
	@echo You can now flash the keyboard with QMK Toolbox
	@echo Firmware binary: $(PWD)/gmmk_pro_ansi_gmmk_laser.bin

.PHONY: setup
setup: .qmk_firmware docker-image

.PHONY: update
update: setup
	(cd .qmk_firmware && git pull --recurse-submodules --ff-only)

.PHONY: clean
clean:
	rm -rf .qmk_firmware


###############################
####  Environment targets  ####
###############################

.qmk_firmware:
	# Clone qmk_firmware
	git clone --recurse-submodules https://github.com/qmk/qmk_firmware.git .qmk_firmware
	docker pull qmkfm/qmk_cli

.PHONY: docker-image
docker-image:
# Pull the laster docker image for QMK CLI
	docker pull qmkfm/qmk_cli


#########################
####  Build targets  ####
#########################

keymap/gmmk_laser.c: keymap/gmmk_laser.json
# Translate keymap JSON file generated by QMK Configurator to it's C representation
# QMK Configurator online: https://config.qmk.fm/
	docker run --rm \
		-w /qmk_firmware \
		-v "$(PWD)/.qmk_firmware":/qmk_firmware \
		-v "$(PWD)/keymap":/qmk_firmware/keyboards/gmmk/pro/ansi/keymaps/gmmk_laser \
		qmkfm/qmk_cli \
		qmk json2c -o keyboards/gmmk/pro/ansi/keymaps/gmmk_laser/gmmk_laser.c keyboards/gmmk/pro/ansi/keymaps/gmmk_laser/gmmk_laser.json

gmmk_pro_ansi_gmmk_laser.bin: keymap/gmmk_laser.c keymap/keymap.c
# Build the binary firmware file for flashing
	docker run --rm \
		-w /qmk_firmware \
		-v "$(PWD)/.qmk_firmware":/qmk_firmware \
		-v "$(PWD)/keymap":/qmk_firmware/keyboards/gmmk/pro/ansi/keymaps/gmmk_laser \
		qmkfm/qmk_cli \
		qmk compile -kb gmmk/pro/ansi -km gmmk_laser
	cp .qmk_firmware/.build/gmmk_pro_ansi_gmmk_laser.bin gmmk_pro_ansi_gmmk_laser.bin


###################
####  Helpers  ####
###################

.PHONY: bash
bash:
	docker run --rm -it \
		-w /qmk_firmware \
		-v "$(PWD)/.qmk_firmware":/qmk_firmware \
		-v "$(PWD)/keymap":/qmk_firmware/keyboards/gmmk/pro/ansi/keymaps/gmmk_laser \
		qmkfm/qmk_cli bash
