extends HFlowContainer

const LegendElement = preload("uid://bniasv6rpbhsy")
const _ELEMENT_SCENE = preload("uid://cj8ushf5bl4te")

# id -> LegendElement
var _entries: Dictionary = {}

# API
#================================================================================#
func add_entry(id: StringName, text_key: String) -> void:
	if _entries.has(id):
		push_error("Sweet Settings: legend already has an entry '%s'." % id)
		return

	var entry: LegendElement = _ELEMENT_SCENE.instantiate()
	entry.setup(text_key)
	add_child(entry)
	_entries[id] = entry

func set_entry_icon(id: StringName, texture: Texture2D, tint: Color = Color.WHITE) -> void:
	if not _entries.has(id):
		push_error("Sweet Settings: legend has no entry '%s'." % id)
		return

	(_entries[id] as LegendElement).set_icon(texture, tint)

func has_entry(id: StringName) -> bool:
	return _entries.has(id)

func refresh_locale() -> void:
	for id in _entries:
		(_entries[id] as LegendElement).refresh_locale()
#================================================================================#
