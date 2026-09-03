extends CanvasLayer

func _ready() -> void:
	# Das Menü ist zu Beginn unsichtbar
	hide()

# _unhandled_input fängt Tastendrücke ab, die nicht schon von anderen UIs geschluckt wurden
func _unhandled_input(event: InputEvent) -> void:
	# "ui_cancel" ist standardmäßig in Godot auf die ESC-Taste gemappt
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()

func toggle_pause() -> void:
	# Invertiert den aktuellen Pausenstatus des gesamten SceneTrees
	var is_paused: bool = not get_tree().paused
	get_tree().paused = is_paused
	
	if is_paused:
		show()
		print("[PauseMenu] Spiel PAUSIERT. Timer und Spawner gestoppt.")
	else:
		hide()
		print("[PauseMenu] Spiel FORTGESETZT.")

func _on_button_pressed() -> void:
	print("[PauseMenu] Weiter-Button geklickt.")
	toggle_pause()
