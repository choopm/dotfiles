# This is a modified version of audiosink.py
# to support pipewire systems where pacmd is not available.
# It replaces usages of `pacmd` with `pactl` and relies on JSON format.
#
# Origin:
#   - https://github.com/ultrabug/py3status/blob/a74245415f5747ba7e022566855ad5277707ac13/py3status/modules/audiosink.py

r"""
Display and toggle default audiosink.

Configuration parameters:
    cache_timeout: How often we refresh this module in seconds
        (default 10)
    display_name_mapping: dictionary mapping devices names to display names
        (default {})
    format: display format for this module
        (default '{audiosink}')
    sinks_to_ignore: list of devices names to ignore
        (default [])

Format placeholders:
    {audiosink} comma seperated list of (display) names of default sink(s)

Requires:
    pactl: Control a running PulseAudio sound server (libpulse)

Examples:
```
pwaudiosink {
    display_name_mapping = {
        "Family 17h/19h HD Audio Controller Analog Stereo": "Int",
        "ThinkPad Dock USB Audio Analog Stereo": "Dock"
    }
    format = "{audiosink}"
    sinks_to_ignore = ["Renoir Radeon High Definition Audio Controller Digital Stereo (HDMI)"]
}
```

@author Jens Brandt <py3status@brandt-george.de>
@license BSD

SAMPLE OUTPUT
{'full_text': 'Dock'}

int
{'full_text': 'Int'}
"""

import os
import json

class Py3status:
    # available configuration parameters
    cache_timeout = 10
    display_name_mapping = {}
    format = r"{audiosink}"
    sinks_to_ignore = []

    def _get_display_name(self, name):
        if name in self.display_name_mapping:
            return self.display_name_mapping[name]
        return name

    # returns list of (not ignored) audiosinks
    # each audiosink is given by the dictionary keys:
    # - id: pulseaudio id of the device
    # - name: device name
    # - display_name: display name as given by display_name_mapping
    # - is_active: boolean, if the device is currently the default output device
    def _get_state(self):
        state = json.loads(
            os.popen("pactl -f json list sinks")
            .read()
        )
        default_sink = (
            os.popen("pactl get-default-sink")
            .read()
        )
        # filter for not ignored (or active) devices
        state = list(
            filter(
                lambda d: (d["description"] not in self.sinks_to_ignore),
                state,
            )
        )
        # set is_active flag (missing in `pactl list sinks` output)
        for d in state:
            d["is_active"] = (d["name"] in default_sink)
        # lookup name
        for d in state:
            d["description"] = self._get_display_name(d["description"])
        return state

    def _to_string(self, state):
        return ", ".join([s["description"] for s in state if s["is_active"]])

    def _activate_input(self, input_id):
        os.popen(f"pactl set-default-sink {input_id}")

    # activates the next devices following the first currently active device
    def _toggle(self, state):
        for i in range(len(state)):
            if state[i]["is_active"]:
                input_to_activate_index = (i + 1) % len(state)
                self._activate_input(state[input_to_activate_index]["name"])
                return

    def pwaudiosink(self):
        composites = [
            {"full_text": self._to_string(self._get_state())},
        ]
        audiosink = self.py3.composite_create(composites)
        cached_until = self.py3.time_in(self.cache_timeout)
        return {
            "cached_until": cached_until,
            "full_text": self.py3.safe_format(self.format, {"audiosink": audiosink}),
        }

    def on_click(self, event):
        button = event["button"]
        if button == 1:
            self._toggle(self._get_state())


if __name__ == "__main__":
    """
    Run module in test mode.
    """
    from py3status.module_test import module_test

    module_test(Py3status)
