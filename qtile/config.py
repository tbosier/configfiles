# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import os
import subprocess

from libqtile import bar, hook, layout, qtile, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy

@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser("~")
    subprocess.Popen(["/bin/sh", home + "/.config/qtile/autostart.sh"])


mod = "mod4"
terminal = "kitty"

colors = {
    "base": "#1e1e2e",
    "mantle": "#181825",
    "surface0": "#313244",
    "surface1": "#45475a",
    "overlay0": "#6c7086",
    "subtext0": "#a6adc8",
    "subtext1": "#bac2de",
    "text": "#cdd6f4",
    "red": "#f38ba8",
    "yellow": "#f9e2af",
    "green": "#a6e3a1",
    "blue": "#89b4fa",
    "mauve": "#cba6f7",
    "teal": "#94e2d5",
}

# X11 has no clipboard daemon: whoever copies must stay alive to serve the
# data. xclip was the last command in a foreground shell, so when that shell
# exited xclip could be signalled away with it and the paste came back empty --
# which is why this worked only sometimes.
#
# copyq, when running, takes ownership itself and keeps it. setsid -f detaches
# xclip as a fallback so it survives the shell either way.
screenshot_command = (
    "sh -c 'dir=\"$HOME/Pictures/Screenshots\"; mkdir -p \"$dir\"; "
    "file=\"$dir/$(date +%Y-%m-%d_%H-%M-%S).png\"; "
    "if maim -s \"$file\"; then "
    "if command -v copyq >/dev/null 2>&1; then "
    "copyq write image/png - < \"$file\" >/dev/null && copyq select 0 >/dev/null; "
    "else "
    "setsid -f xclip -selection clipboard -t image/png -i \"$file\"; "
    "fi; "
    "else rm -f \"$file\"; fi'"
)


def gpu_status():
    try:
        output = subprocess.check_output(
            [
                "nvidia-smi",
                "--query-gpu=memory.used,memory.total,utilization.gpu,temperature.gpu",
                "--format=csv,noheader,nounits",
            ],
            stderr=subprocess.DEVNULL,
            text=True,
            timeout=2,
        ).splitlines()[0]
        used, total, utilization, temperature = [
            float(value.strip()) for value in output.split(",")
        ]
        return (
            f"󰢮 {utilization:.0f}% "
            f"{used / 1024:.1f}/{total / 1024:.1f}G "
            f"{temperature:.0f}°"
        )
    except (OSError, subprocess.SubprocessError, ValueError, IndexError):
        return "󰢮 N/A"


def volume_status():
    try:
        output = subprocess.check_output(
            ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"],
            stderr=subprocess.DEVNULL,
            text=True,
            timeout=2,
        ).strip()
        volume = round(float(output.split()[1]) * 100)
        muted = "[MUTED]" in output

        if muted:
            icon = "󰝟"
        elif volume < 34:
            icon = "󰕿"
        elif volume < 67:
            icon = "󰖀"
        else:
            icon = "󰕾"

        return f"{icon} {volume}%"
    except (OSError, subprocess.SubprocessError, ValueError, IndexError):
        return "󰖁 N/A"


keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left()),
    Key([mod], "l", lazy.layout.right()),
    Key([mod], "j", lazy.layout.down()),
    Key([mod], "k", lazy.layout.up()),
    Key([mod, "shift"], "h", lazy.layout.swap_left()),
    Key([mod, "shift"], "l", lazy.layout.swap_right()),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up()),
    Key([mod, "control"], "l", lazy.spawn("i3lock -c 1e1e2e"), desc="Lock screen"),
    Key([mod], "i", lazy.layout.grow()),
    Key([mod], "m", lazy.layout.shrink()),
    Key([mod], "n", lazy.layout.reset()),
    Key([mod, "shift"], "n", lazy.layout.normalize()),
    Key([mod], "o", lazy.layout.maximize()),
    Key([mod, "shift"], "a", lazy.layout.toggle_auto_maximize()),
    Key([mod, "shift"], "space", lazy.layout.flip()),
        # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key(
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key([mod], "t", lazy.window.toggle_floating(), desc="Toggle floating on the focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    Key(
        [mod, "shift"],
        "s",
        lazy.spawn(screenshot_command),
        desc="Select a screenshot, save it, and copy it to the clipboard",
    ),
]

# Add key bindings to switch VTs in Wayland.
# We can't check qtile.core.name in default config as it is loaded before qtile is started
# We therefore defer the check until the key binding is run by using .when(func=...)
for vt in range(1, 8):
    keys.append(
        Key(
            ["control", "mod1"],
            f"f{vt}",
            lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
            desc=f"Switch to VT{vt}",
        )
    )


group_labels = [
    ("1", "HERDR"),
    ("2", "FIREFOX"),
    ("3", "OBSIDIAN"),
    ("4", "PROJECT"),
    ("5", "GAMES"),
    ("6", "MEDIA"),
    ("7", "FILES"),
    ("8", "CHAT"),
    ("9", "MISC"),
]
groups = [Group(name, label=f"{name}:{label}") for name, label in group_labels]

for i in groups:
    keys.extend(
        [
            # mod1 + group number = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + group number = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + group number = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )

layout_theme = {
    "border_width": 2,
    "margin": 10,
    "border_focus": colors["blue"],
    "border_normal": colors["surface0"],
}
    
layouts = [
    #layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=4),
    #layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    layout.MonadTall(**layout_theme),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font="MesloLGS Nerd Font",
    fontsize=13,
    foreground=colors["text"],
    padding=6,
)
extension_defaults = widget_defaults.copy()


def make_bar(primary=False):
    widgets = [
        widget.CurrentLayout(foreground=colors["mauve"], padding=10),
        widget.GroupBox(
            fontsize=14,
            margin_y=5,
            margin_x=2,
            padding_y=2,
            padding_x=7,
            borderwidth=2,
            active=colors["text"],
            inactive=colors["overlay0"],
            rounded=True,
            highlight_method="block",
            highlight_color=colors["surface0"],
            this_current_screen_border=colors["surface1"],
            this_screen_border=colors["surface0"],
            other_current_screen_border=colors["surface1"],
            other_screen_border=colors["surface0"],
            urgent_alert_method="block",
            urgent_border=colors["red"],
        ),
        widget.Prompt(
            foreground=colors["text"],
            background=colors["surface0"],
        ),
        widget.WindowName(
            foreground=colors["subtext1"],
            padding=12,
            max_chars=90,
        ),
        widget.Net(
            format="󰖩 ↓{down:.1f}{down_suffix} ↑{up:.1f}{up_suffix}",
            update_interval=2,
            foreground=colors["teal"],
            padding=8,
        ),
        widget.GenPollText(
            func=volume_status,
            update_interval=1,
            foreground=colors["green"],
            padding=8,
            mouse_callbacks={
                "Button1": lazy.spawn("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
                "Button4": lazy.spawn(
                    "wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"
                ),
                "Button5": lazy.spawn(
                    "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
                ),
            },
        ),
        widget.Sep(
            linewidth=1,
            padding=7,
            foreground=colors["surface1"],
        ),
        widget.CPU(
            format=" {load_percent:.0f}%",
            update_interval=2,
            foreground=colors["blue"],
            padding=8,
        ),
        widget.ThermalSensor(
            tag_sensor="Tctl",
            format=" {temp:.0f}{unit}",
            update_interval=5,
            threshold=80,
            foreground=colors["green"],
            foreground_alert=colors["red"],
            padding=8,
        ),
        widget.Memory(
            format="󰍛 {MemUsed:.1f}/{MemTotal:.1f}G",
            measure_mem="G",
            foreground=colors["yellow"],
            padding=8,
        ),
        widget.GenPollText(
            func=gpu_status,
            update_interval=3,
            foreground=colors["mauve"],
            padding=8,
        ),
    ]

    if primary:
        widgets.append(widget.Systray(padding=8))

    widgets.append(
        widget.Clock(
            format="󰥔 %a %b %-d  %-I:%M %p",
            foreground=colors["blue"],
            padding=10,
        )
    )

    return bar.Bar(widgets, 36, background=colors["base"], opacity=0.97)


screens = [
    Screen(
        wallpaper="~/Pictures/apostle.png",
        wallpaper_mode="fill",
        top=make_bar(primary=True),
    ),
    Screen(
        wallpaper="~/Pictures/second_wallpaper.png",
        wallpaper_mode="fill",
        top=make_bar(),
    ),
]

# ---------------------------------------------------------------------------
# Screen-change handling
#
# qtile 0.37's built-in `reconfigure_screens = True` handler is not safe against
# a transient screen_change event that reports zero connected outputs (monitor
# DPMS/sleep, a cable renegotiating, a mode switch). When that happens,
# Qtile._process_screens() falls into its
#
#     if len(new_screens) == 0:
#         new_screens.append(Screen())
#
# fallback and replaces qtile.screens with a single bare Screen() that is never
# _configure()d. That screen has no .group, no .index and no bar window, so the
# top bar disappears and every later screen_change dies on
# `[s.group for s in self.screens]` -- qtile can never recover on its own.
#
# So: keep qtile's handler switched off and drive reconfiguration ourselves,
# ignoring empty-output events and healing any unconfigured screen we find.
# ---------------------------------------------------------------------------
reconfigure_screens = False


@hook.subscribe.screen_change
def _reconfigure_screens_safely(*_args, **_kwargs):
    from libqtile import qtile as q  # resolved at call time, not import time
    from libqtile.log_utils import logger

    try:
        outputs = q.get_output_info()
    except Exception:
        logger.exception("screen_change: could not read output info; ignoring")
        return

    if not outputs:
        # Transient "no monitors" event. Reconfiguring here is what destroys the
        # bar, so do nothing and wait for the event that reports real outputs.
        logger.warning("screen_change reported no outputs; ignoring")
        return

    # Self-heal: drop any screen that never completed _configure(), otherwise
    # _process_screens() raises on it and reconfiguration stays broken forever.
    stale = [s for s in q.screens if not hasattr(s, "group")]
    if stale:
        logger.warning("dropping %d unconfigured screen(s) before reconfigure", len(stale))
        q.screens[:] = [s for s in q.screens if hasattr(s, "group")]

    try:
        q.reconfigure_screens()
    except Exception:
        logger.exception("screen_change: reconfigure_screens failed; rebuilding screens")
        q.screens.clear()
        q.reconfigure_screens()


# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
# reconfigure_screens is set above, next to the screen_change hook that replaces it.

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
