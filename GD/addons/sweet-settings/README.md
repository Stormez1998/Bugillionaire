# Sweet Settings

A drop-in settings menu for Godot 4.7+ games.

Ships with basic settings most games need and is built to be extended. Drop it straight into your game or treat it as a jumping-off point to restructure for your specific needs.

## Features

- **Ready-made defaults** - gameplay, graphics, audio, and controls
- **Schema-driven UI** - settings are defined in JSON, not hardcoded. Add more with a few lines.
- **Automatic keybinds** - Input Map actions become editable bindings with no per-action setup
- **Layout-safe rebinding** - bindings are stored by physical key position, so they survive AZERTY and other layouts
- **Simple, themeable UI** - style it with Godot themes, or swap the components out

## Installation

**From GitHub.** Clone or download, copy `addons/sweet-settings` into your project's `addons/` folder, then enable **Sweet Settings** under **Project → Project Settings → Plugins**.

**From the Asset Store.** Search **Sweet Settings** in the editor's AssetStore tab, install, then enable it under Plugins.

Enabling the plugin adds the `SweetSettings` autoload. Instance `res://addons/sweet-settings/settings.tscn` wherever you want the menu - pause screen, options button, and so on.

### Setup notes

**Audio buses.** The default schema ships one `master_volume` slider, wired to Godot's built-in `Master` bus. Appliers for `music_volume`, `sfx_volume` and `ui_volume` are already registered, so adding those keys to the schema and creating matching `Music`, `SFX` and `UI` buses is all it takes to get working sliders for them.

**Save path.** `SAVE_PATH` in `addons/sweet-settings/addon_paths.gd` (`user://sweet_settings.json`) is a placeholder. Point it somewhere appropriate for your project.

## Scripting API

```gdscript
var volume: float = SweetSettings.get_setting("master_volume")
SweetSettings.set_setting("vsync", true)
```

| Member | Purpose |
|---|---|
| `get_setting(key)` | Current value (default or player override) |
| `set_setting(key, value, persist = true)` | Set current value |
| `reset_section(id)` / `reset_all()` | Drop overrides and re-apply defaults. |
| `register_applier(key, callable)` | Run your own code when a setting changes (see below). |
| `flush(wait = false)` | Force a save now. Saves are otherwise debounced and threaded. |
| `setting_changed(key, value)` | Signal. Fires after a setting is applied. |
| `input_device_changed(family)` | Signal. Fires when the player switches device |

**Custom appliers** let a setting drive your own systems:

```gdscript
SweetSettings.register_applier("controller_deadzone", func(value: float) -> void:
	for action in InputMap.get_actions():
		InputMap.action_set_deadzone(action, value)
)
```

Call it from any autoload `_ready` or later. Registrations made before boot finishes are queued; registrations after boot apply the stored value immediately.

## Controls

Add actions in **Project → Project Settings → Input Map**. The controls section uses `"settings_source": "input_map"`, so every action becomes an editable keybind automatically. Use `exclude_prefixes` on that section to hide engine or internal actions.

Each action can hold multiple keyboard and controller bindings, shown as aligned pair-rows - **+** adds another pair. A legend at the top of the list of actions explains the below behavior:

- **Unbind** - with a slot selected, click the **×** badge, or on a controller hold any button for 0.8s.
- **Conflicts** - an input bound to more than one action is tinted yellow on both. Nothing is auto-cleared; it is up to you whether to allow it.

How bindings are stored:

**Bindings are positional.** A key is saved by its physical position, not the letter printed on it, so a binding made on QWERTY still lands on the same physical key on AZERTY. Labels and icons are translated through the active layout, so the menu always shows the correct key.

**Only rebindable events are touched.** Applying a binding replaces the key, mouse button, joypad button and joypad axis events on an action and leaves anything else in place. Those four are all the Input Map editor can create, so this only comes up if your project adds others in code, such as a screen touch or a MIDI note. A rebind will not clear them.

## Schema

Settings are defined in JSON under `addons/sweet-settings/config/`. The shipped defaults live in `default_schema.json` - read that for a full working example.

```json
{
	"sections": [
		{
			"id": "...",
			"settings_source": "...",
			"exclude_prefixes": [],
			"header": [],
			"footer": [],
			"settings": [
				{ "key": "...", "type": "...", "default": ... },
				{ "keys": ["...", "..."], "type": "...", "default": ... }
			]
		}
	]
}
```

### Section

Each section is one tab. `sections` order is tab order.

| Field | Meaning |
|-------|---------|
| `id` | Section id. Tab label is humanized from this unless `label` is set. Also used for i18n. |
| `label` | Optional display name override for the tab. |
| `settings` | Array of setting dictionaries for this tab. |
| `settings_source` | Optional injector. `"input_map"` pulls Input Map actions in as keybinds. |
| `exclude_prefixes` | Optional. With `input_map`, skip actions whose names start with these prefixes. |
| `header` / `footer` | Optional extra components above/below the rows - `"control_header"`, `"section_reset"`. |

### Setting

Each entry becomes one or more rows.

| Field | Meaning |
|-------|---------|
| `key` | Id for a single setting. Display text is `tr(key)` unless overridden. |
| `keys` | Batch of ids sharing this entry's other fields. Use instead of `key`. |
| `type` | Which editor to show (see below). |
| `label` | Optional display name override. Passed through `tr()`. |
| `default` | Starting value before the player changes anything. |
| `default_source` | Optional. Fill `default` from the environment (`system_locale`, `primary_resolution`). Wins over `default` when it resolves. |
| `min` / `max` / `step` | Range and step for `numeric_slider` and `spinbox`. |
| `suffix` | Optional. Text after a `numeric_slider` value, e.g. `"%"`. |
| `display_scale` | Optional. Multiplies the stored value for display, e.g. `100` shows `0.1` as `10`. |
| `options` | Choices for `option` - a `{ "Label": value }` map, a list of values, or `[{ "value", "label" }, ...]`. |
| `options_source` | Optional. Fill `options` from the environment (`project_locales`, `display_resolutions`). Replaces static `options`. |
| `disabled_when` | Optional. Grey this setting out when another setting's value is in the given list. |

### Types

| Type | Control |
|------|---------|
| `toggle` | On/off checkbox |
| `option` | Dropdown |
| `spinbox` | Numeric spin box |
| `numeric_slider` | Slider with editable value, optional scaling and suffix |
| `keybind` | Rebindable input |

### Using your own schema

Edit `default_schema.json` directly, or drop another `.json` into the same `config/` folder - a custom schema takes priority, and if several exist the first alphabetically wins. That keeps the addon updatable without editing the shipped default.

## Styling

The UI is intentionally simple: tabs, rows, and value editors. It is meant to get you running with the assumption that you will style the menu to match your game.

A small theme ships at `addons/sweet-settings/theme/sweet_settings.tres`. Extend it, fold its entries into your project's theme, or apply a different theme to the settings scene or a parent. Standard controls style through normal Godot theme inheritance; properties specific to this addon live under the `SweetSettings` theme type:

| Theme item | Effect |
|------------|--------|
| `SweetSettings/colors/conflict_icon_modulate` | Tint on a keybind icon bound to more than one action |

For anything structural, edit or replace the scenes within `components/`.

## Progress

I intend to maintain and update this repo when necessary. Don't expect regular or timely updates.

## License

MIT - see [LICENSE](licenses/LICENSE).

Keybind prompt icons are from [Kenney's Input Prompts](https://kenney.nl/assets/input-prompts) (CC0). See [`licenses/third-party/kenney-input-prompts.txt`](licenses/third-party/kenney-input-prompts.txt).

The extra icon families (`generic/`, `touch/`, and the per-console sets) are there so your own prompts can draw from the same art.
