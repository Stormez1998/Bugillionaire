extends MarginContainer

const ControllerIconMap = preload("uid://g1joegdpp4uw")
const IconPaths = preload("uid://cxwurn6qv7ral")
const Icons = preload("uid://dhdqwmdcw4n26")
const InputDeviceTracker = preload("uid://dpnmg6swmq30l")
const Legend = preload("uid://d15jjkdb0qaqk")

# Theme type for the addon's own properties. Users style Sweet Settings by adding entries under this type in their Theme.
const THEME_TYPE := &"SweetSettings"

const _CONFLICT_ENTRY := &"conflict"
const _HOLD_CLEAR_ENTRY := &"hold_clear"

const _HOLD_CLEAR_BUTTON := JOY_BUTTON_A

var _keyboard_icon: TextureRect
var _controller_icon: TextureRect
var _legend: Legend

var _last_family: String = ""

# INIT
#================================================================================#
func _ready() -> void:
	_ensure_nodes()
	_build_legend()
	_refresh_icons()

func _ensure_nodes() -> void:
	if _keyboard_icon != null:
		return

	_keyboard_icon = $Row/ValueEditorContainer/Columns/KeyboardIcon
	_controller_icon = $Row/ValueEditorContainer/Columns/ControllerIcon
	_legend = $Row/LegendContainer/Legend as Legend

func _build_legend() -> void:
	if _legend.has_entry(_CONFLICT_ENTRY):
		return

	_legend.add_entry(_CONFLICT_ENTRY, "legend_conflict")
	_legend.add_entry(_HOLD_CLEAR_ENTRY, "legend_hold_clear")
#================================================================================#

# API
#================================================================================#
# Called by the settings menu when the language changes.
func refresh_locale() -> void:
	_ensure_nodes()
	_legend.refresh_locale()

# Called by the settings menu when the player switches input device family.
func refresh_input_device() -> void:
	_refresh_icons()
#================================================================================#

# DISPLAY
#================================================================================#
func _refresh_icons() -> void:
	_ensure_nodes()
	_last_family = InputDeviceTracker.current_family()
	_keyboard_icon.texture = Icons.texture_for_keyboard_device()
	_controller_icon.texture = Icons.texture_for_controller_device(_last_family)
	_refresh_legend_icons()

func _refresh_legend_icons() -> void:
	if _legend == null or not _legend.has_entry(_CONFLICT_ENTRY):
		return

	_legend.set_entry_icon(
		_CONFLICT_ENTRY,
		IconPaths.load_texture(IconPaths.join("keyboard-mouse", "keyboard_any.svg")),
		get_theme_color("conflict_icon_modulate", THEME_TYPE)
	)

	_legend.set_entry_icon(
		_HOLD_CLEAR_ENTRY,
		ControllerIconMap.texture_for_button(_HOLD_CLEAR_BUTTON, _last_family)
	)
#================================================================================#

# SIGNAL HANDLERS
#================================================================================#
func _notification(what: int) -> void:
	if what == NOTIFICATION_THEME_CHANGED and is_node_ready():
		_refresh_icons()
#================================================================================#
