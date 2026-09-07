extends HBoxContainer

const _SEPARATION := 6

var _icon: TextureRect
var _label: Label
var _text_key: String = ""

# INIT
#================================================================================#
func _ready() -> void:
	_ensure_nodes()

func _ensure_nodes() -> void:
	if _icon != null:
		return

	add_theme_constant_override("separation", _SEPARATION)
	_icon = $Icon
	_label = $Label
#================================================================================#

# API
#================================================================================#
# text_key is passed through tr() now and again on every refresh_locale().
func setup(text_key: String) -> void:
	_ensure_nodes()
	_text_key = text_key
	_label.text = tr(text_key)

func set_icon(texture: Texture2D, tint: Color = Color.WHITE) -> void:
	_ensure_nodes()
	_icon.texture = texture
	_icon.modulate = tint

func refresh_locale() -> void:
	_ensure_nodes()
	_label.text = tr(_text_key)
#================================================================================#
