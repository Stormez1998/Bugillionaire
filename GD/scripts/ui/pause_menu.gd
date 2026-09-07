extends CanvasLayer

@onready var menu_panel: VBoxContainer = $MenuPanel
@onready var settings_menu: VBoxContainer = $Settings


func _ready() -> void:
	settings_menu.hide()
	# Neu: Lauscht darauf, ob das Settings-Menü unsichtbar wird (z. B. durch seinen Exit-Button)
	settings_menu.hidden.connect(_on_settings_closed)
	hide()

func _on_btn_settings_pressed() -> void:
	menu_panel.hide()
	settings_menu.show()

# Wird automatisch gefeuert, wenn die Settings geschlossen werden
func _on_settings_closed() -> void:
	menu_panel.show()
	print("Settings geschlossen, Hauptmenü wieder aktiv.")

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

func _on_btn_game_resume_pressed() -> void:
	print("[PauseMenu] Weiter-Button geklickt.")
	toggle_pause()

func _on_btn_game_quit_pressed() -> void:
	print("Spiel wird beendet...")
	get_tree().quit()
