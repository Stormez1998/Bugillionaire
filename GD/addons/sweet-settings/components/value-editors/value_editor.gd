class_name SweetValueEditor
extends RefCounted

signal value_changed(value: Variant)

func get_control() -> Control:
	return null

func setup(_setting: Dictionary) -> void:
	push_error("SweetValueEditor: setup not implemented")

func get_value() -> Variant:
	return null

func set_value(_value: Variant) -> void:
	pass

# focus_mode is the only thing Godot's own focus navigation consults — it skips
# FOCUS_NONE and invisible Controls, but happily lands on a control that is merely
# 'disabled' or not 'editable'. So disabling has to clear focus_mode, or a d-pad
# will walk straight onto a greyed-out row.
#
# The original mode is captured on first use rather than assumed, so re-enabling
# restores whatever the control or a host theme actually set.
var _focus_mode: int = Control.FOCUS_ALL
var _focus_mode_captured := false

func block_focus(control: Control, disabled: bool) -> void:
	if control == null:
		return
	if not _focus_mode_captured:
		_focus_mode = control.focus_mode
		_focus_mode_captured = true
	control.focus_mode = Control.FOCUS_NONE if disabled else _focus_mode
	if disabled and control.has_focus():
		control.release_focus()

func set_disabled(disabled: bool) -> void:
	var control := get_control()
	if control == null:
		return
	if "disabled" in control:
		control.disabled = disabled
		block_focus(control, disabled)
		return

	# Nothing here can actually disable the control: dimming and mouse_filter do
	# not stop children being focused, so it stays reachable by keyboard and
	# controller. An editor rooted in a container must override set_disabled.
	push_error(
		"Sweet Settings: %s has no 'disabled' property, so this editor can only be dimmed, not disabled. Override set_disabled() in the value editor."
		% control.get_class()
	)
	control.modulate.a = 0.45 if disabled else 1.0
	control.mouse_filter = (
		Control.MOUSE_FILTER_IGNORE if disabled else Control.MOUSE_FILTER_STOP
	)
