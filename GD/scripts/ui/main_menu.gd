extends Control

@onready var settings_menu: Control = $Settings
@onready var menu_panel: Control = $MenuPanel

func _ready() -> void:
	settings_menu.hide()
	settings_menu.hidden.connect(_on_settings_closed)
	print("[MainMenu] Geladen. Warte auf Benutzereingabe.")

# Wird automatisch gefeuert, wenn die Settings geschlossen werden
func _on_settings_closed() -> void:
	menu_panel.show()
	print("Settings geschlossen, Hauptmenü wieder aktiv.")

func _on_btn_game_start_pressed() -> void:
	print("[MainMenu] Start-Button geklickt. Wechsle zu MainLevel...")
	# Lädt die Hauptspielszene und ersetzt das aktuelle Menü im Speicher
	GameState.reset_full_game()
	get_tree().change_scene_to_file("res://scenes/levels/MainLevel.tscn")

func _on_btn_game_quit_pressed() -> void:
	print("Spiel wird beendet...")
	get_tree().quit()

func _on_btn_settings_pressed() -> void:
	menu_panel.hide()
	settings_menu.show()
	print("[SettingsMenu] Geladen. Warte auf Benutzereingabe.")
