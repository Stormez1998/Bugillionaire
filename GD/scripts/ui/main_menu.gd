extends Control

func _ready() -> void:
	print("[MainMenu] Geladen. Warte auf Benutzereingabe.")

func _on_button_pressed() -> void:
	print("[MainMenu] Start-Button geklickt. Wechsle zu MainLevel...")
	# Lädt die Hauptspielszene und ersetzt das aktuelle Menü im Speicher
	get_tree().change_scene_to_file("res://scenes/levels/MainLevel.tscn")
