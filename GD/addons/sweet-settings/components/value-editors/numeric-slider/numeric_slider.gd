extends HBoxContainer

signal value_changed(value: float)

var _slider: HSlider
var _line_edit: LineEdit
var _suffix_label: Label

var _updating := false
var _signals_connected := false
var _disabled := false
# Captured before the first disable so re-enabling restores whatever the scene
# or a host theme set, rather than assuming FOCUS_ALL.
var _slider_focus_mode := Control.FOCUS_ALL
var _line_edit_focus_mode := Control.FOCUS_ALL
var _min := 0.0
var _max := 1.0
var _step := 0.01
var _suffix := ""
var _display_scale := 1.0


func _ready() -> void:
	alignment = BoxContainer.ALIGNMENT_CENTER
	_ensure_nodes()

func configure(setting: Dictionary) -> void:
	_ensure_nodes()
	_connect_signals()

	_min = setting.get("min", 0.0)
	_max = setting.get("max", 1.0)
	_step = setting.get("step", 0.01)
	_suffix = setting.get("suffix", "")
	_display_scale = setting.get("display_scale", 1.0)

	_slider.min_value = _min
	_slider.max_value = _max
	_slider.step = _step
	_suffix_label.text = _suffix
	_suffix_label.visible = not _suffix.is_empty()

func get_value() -> float:
	_ensure_nodes()
	return _slider.value

func set_value(value: float) -> void:
	_ensure_nodes()
	_updating = true
	var clamped := clampf(snapped(value, _step), _min, _max)
	_slider.value = clamped
	_line_edit.text = _format_value(clamped)
	_updating = false

func set_disabled(disabled: bool) -> void:
	_ensure_nodes()
	_disabled = disabled

	_slider.editable = not disabled
	_line_edit.editable = not disabled

	# editable alone still allows focus, so a disabled row would keep a focus ring
	# and stay reachable by keyboard and controller navigation.
	_slider.focus_mode = Control.FOCUS_NONE if disabled else _slider_focus_mode
	_line_edit.focus_mode = Control.FOCUS_NONE if disabled else _line_edit_focus_mode

	if disabled:
		if _slider.has_focus() or _line_edit.has_focus():
			_slider.release_focus()
			_line_edit.release_focus()

	modulate.a = 0.45 if disabled else 1.0

func _ensure_nodes() -> void:
	if _slider != null:
		return

	_slider = $Slider
	_line_edit = $InputContainer/LineEdit
	_suffix_label = $InputContainer/SuffixLabel

	_slider_focus_mode = _slider.focus_mode
	_line_edit_focus_mode = _line_edit.focus_mode

	_slider.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	_line_edit.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	_suffix_label.size_flags_vertical = Control.SIZE_SHRINK_CENTER

func _connect_signals() -> void:
	if _signals_connected:
		return

	_slider.value_changed.connect(_on_slider_changed)
	_line_edit.text_submitted.connect(_on_text_committed)
	_line_edit.focus_exited.connect(_on_focus_exited)
	_signals_connected = true

func _format_value(stored_value: float) -> String:
	var display_value := snapped(stored_value * _display_scale, _step * _display_scale)
	if _step * _display_scale >= 1.0:
		return str(int(display_value))
	return str(display_value)

func _parse_text(text: String) -> Variant:
	var trimmed := text.strip_edges()
	if not _suffix.is_empty() and trimmed.ends_with(_suffix):
		trimmed = trimmed.trim_suffix(_suffix).strip_edges()

	if not trimmed.is_valid_float():
		return null

	return float(trimmed) / _display_scale

func _commit_text() -> void:
	# _disabled guards the focus_exited that set_disabled itself triggers when it
	# releases focus, so becoming disabled cannot commit a half-typed edit.
	if _updating or _disabled:
		return

	var parsed: Variant = _parse_text(_line_edit.text)
	if parsed == null:
		_line_edit.text = _format_value(_slider.value)
		return

	set_value(float(parsed))
	value_changed.emit(get_value())

func _on_slider_changed(value: float) -> void:
	if _updating:
		return

	_updating = true
	_line_edit.text = _format_value(value)
	_updating = false
	value_changed.emit(value)

func _on_text_committed(_text: String) -> void:
	_commit_text()

func _on_focus_exited() -> void:
	_commit_text()
