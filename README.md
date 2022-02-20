# GMMK Laser

This repo contains personalised QMK keyboard layout for my GMMK Pro.

GMMK Pro includes a rotary knob which currently is not supported by [QMK Configurator](https://config.qmk.fm/). This repo contains Makefile that encapsulates steps necessary to convert keymap JSON file into a binary that includes support for rotary knob.


## Modification workflow

1. Upload `keymap/gmmk_laser.json` to [QMK Configurator](https://config.qmk.fm/)
2. Make keymap changes, download JSON and overwrite `keymap/gmmk_laser.json`
3. Run `make build`
4. Use [QMK Toolbox](https://github.com/qmk/qmk_toolbox) to flash the keyboard

