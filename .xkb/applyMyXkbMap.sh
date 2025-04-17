#!/bin/bash
# Change location to this directory containing the script:
cd "${0%/*}"
# The `-w 0` parameter supresses all warning output.
xkbcomp -w 0 customUsInternationalKeyboad.xkb $DISPLAY
# xkbcomp customUsInternationalKeyboad.xkb $DISPLAY
