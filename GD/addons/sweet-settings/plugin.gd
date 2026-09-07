@tool
extends EditorPlugin

const AddonPaths = preload("uid://jls0ogr3p8a3")

var _export_plugin: EditorExportPlugin

func _enable_plugin() -> void:
	if not ProjectSettings.has_setting("autoload/" + AddonPaths.AUTOLOAD_NAME):
		add_autoload_singleton(AddonPaths.AUTOLOAD_NAME, AddonPaths.AUTOLOAD_SCRIPT)
		return

	var entry: String = ProjectSettings.get_setting("autoload/" + AddonPaths.AUTOLOAD_NAME)
	if _normalize_autoload_path(entry) == AddonPaths.AUTOLOAD_SCRIPT:
		return

	push_error(
		"Sweet Settings: an autoload named '%s' already exists and points at '%s'. Rename or remove it, then re-enable the plugin."
		% [AddonPaths.AUTOLOAD_NAME, entry]
	)

func _disable_plugin() -> void:
	if not ProjectSettings.has_setting("autoload/" + AddonPaths.AUTOLOAD_NAME):
		return

	var entry: String = ProjectSettings.get_setting("autoload/" + AddonPaths.AUTOLOAD_NAME)
	if _normalize_autoload_path(entry) == AddonPaths.AUTOLOAD_SCRIPT:
		remove_autoload_singleton(AddonPaths.AUTOLOAD_NAME)

func _normalize_autoload_path(entry: String) -> String:
	var path: String = entry.trim_prefix("*").strip_edges()
	if not path.begins_with("uid://"):
		return path

	var uid: int = ResourceUID.text_to_id(path)
	if uid == ResourceUID.INVALID_ID or not ResourceUID.has_id(uid):
		return path
	return ResourceUID.get_id_path(uid)

# EXPORT
#================================================================================#
class SweetSettingsExport extends EditorExportPlugin:
	func _get_name() -> String:
		return "SweetSettingsConfig"

	# Schema files are plain .json, so Godot treats them as non-resource files and
	# skips them unless the project's export filter includes *.json.
	func _export_begin(_features, _is_debug, _path, _flags) -> void:
		for file_name in DirAccess.get_files_at(AddonPaths.CONFIG_DIR):
			if file_name.get_extension().to_lower() != "json":
				continue
			var res_path := AddonPaths.CONFIG_DIR.path_join(file_name)
			add_file(res_path, FileAccess.get_file_as_bytes(res_path), false)

func _enter_tree() -> void:
	_export_plugin = SweetSettingsExport.new()
	add_export_plugin(_export_plugin)

func _exit_tree() -> void:
	if _export_plugin != null:
		remove_export_plugin(_export_plugin)
		_export_plugin = null
#================================================================================#