#!/bin/bash
#Change to this directory wherever it might be located:
cd "${0%/*}"
xkbcomp -w 0 customUsInternationalKeyboad.xkb $DISPLAY
