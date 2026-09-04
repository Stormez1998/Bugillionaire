extends Control

func _ready() -> void:
	print("[MainMenu] Geladen. Warte auf Benutzereingabe.")

func _on_btn_game_start_pressed() -> void:
	print("[MainMenu] Start-Button geklickt. Wechsle zu MainLevel...")
	# Lädt die Hauptspielszene und ersetzt das aktuelle Menü im Speicher
	get_tree().change_scene_to_file("res://scenes/levels/MainLevel.tscn")


func _on_btn_game_quit_pressed() -> void:
	print("Spiel wird beendet...")
	get_tree().quit()
