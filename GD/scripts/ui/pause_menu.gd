extends CanvasLayer

func _ready() -> void:
	hide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()

func toggle_pause() -> void:
	var is_paused: bool = not get_tree().paused
	get_tree().paused = is_paused
	
	if is_paused:
		show()
		print("[PauseMenu] Spiel PAUSIERT.")
	else:
		hide()
		print("[PauseMenu] Spiel FORTGESETZT.")

func _on_btn_game_resume_pressed() -> void:
	toggle_pause()

func _on_btn_game_quit_pressed() -> void:
	get_tree().quit()

func _on_btn_main_menu_pressed() -> void:
	# 1. Globale Pause zwingend aufheben, sonst startet das nächste Spiel eingefroren
	get_tree().paused = false

	# 2. Szene sauber austauschen (zerstört das alte MainLevel)
	get_tree().change_scene_to_file("res://scenes/ui/MainMenu.tscn")
