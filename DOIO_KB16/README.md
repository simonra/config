Here are configurations and resources for the DOIO KB16-01 I got for my birthday!

I believe it to be the second revision, but not 100% sure.
Based on the extra I/O holes in the PCB not visible in a picture of the first revision which I found in a github issue, I'm fairly certain it's the second.
I can't be bothered to disassemble it to verify for now, so I'll just work on the assumption that it's the second revision.

# Configuration and flashing

There are several tools for viewing what layout you currently have, verifying the keycodes/output, and creating and flashing new layouts.
All of these seem to work in the browser, and Vial (https://get.vial.today/) also has a desktop UI.
However, they don't seem to work in firefox due to lack of support for the currently experimental [WebHID API](https://developer.mozilla.org/en-US/docs/Web/API/WebHID_API).

- VIA
  - Web configurator: <https://usevia.app/#/>
  - Homepage: <https://www.caniusevia.com/>
  - Documentation: <https://www.caniusevia.com/docs/specification>
- QMK (Quantum Mechanical Keyboard Firmware)
  - Web configurator: <https://config.qmk.fm/>
    - For the DOIO KB16 2nd revision: <https://config.qmk.fm/#/doio/kb16/rev2/LAYOUT>
  - Homepage: <https://qmk.fm/>
  - Documentation: <https://docs.qmk.fm/#/>
  - Source: <https://github.com/qmk/qmk_firmware>
- VIAL
  - Web configurator: <https://vial.rocks/>
    - I can't seem to get it to work at the moment.
  - Homepage: <https://get.vial.today/>
  - Documentation: <https://get.vial.today/manual/>
  - Source: <https://github.com/vial-kb>

# Note on configuring udev on linux

I think none of the web configurators worked properly before I ran this.

```sh
sudo mkdir -p /etc/udev/rules.d/
echo 'KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0666", TAG+="uaccess", TAG+="udev-acl"' | sudo tee /etc/udev/rules.d/92-viia.rules
sudo udevadm control --reload-rules
sudo udevadm trigger
```

At the source on <https://get.vial.today/manual/linux-udev.html>, they said to restart the VIAL UI after running this, refreshes of the web version seemed to have worked though.

# Misc resources

- <https://github.com/qmk/qmk_firmware/issues/17726>
- <https://github.com/qmk/qmk_firmware/pull/18699>
- <https://old.reddit.com/r/MechanicalKeyboards/comments/ya82hm/doio_kb16_megalodon_trip_knob_macroapd_has_been/>
