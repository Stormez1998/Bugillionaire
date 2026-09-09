extends Control

@export var upgrade_button_scene: PackedScene
@export var upgrade_database: Array[UpgradeData]

@onready var grid_container: GridContainer = $ScrollContainer/GridContainer
@onready var btn_next_round: Button = $BtnNextRound # Referenz auf den neuen Button

func _ready() -> void:
	_populate_grid()
	
	# Verbindet den Neue-Runde-Button
	btn_next_round.pressed.connect(_on_btn_next_round_pressed)

# Fängt Tastatureingaben ab (ESC = ui_cancel)
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		# Lädt die Pausen-Szene (Pfad ggf. anpassen)
		get_tree().change_scene_to_file("res://scenes/ui/PauseMenu.tscn")

func _on_btn_next_round_pressed() -> void:
	# Wendet die neuen maximalen Werte (z. B. Leben) auf die aktuelle Runde an
	GameState.reset_round()
	
	# Wechselt zurück ins Spiel
	get_tree().change_scene_to_file("res://scenes/levels/MainLevel.tscn")

func _populate_grid() -> void:
	for upgrade in upgrade_database:
		# Instanziiert einen neuen Button aus der Vorlage
		var btn_instance: Button = upgrade_button_scene.instantiate()
		
		# Fügt den Button in das Raster ein
		grid_container.add_child(btn_instance)
		
		# Übergibt die spezifischen Daten an den Button
		btn_instance.initialize(upgrade)
		
		# Verbindet das Klick-Signal dynamisch und übergibt die ID des Upgrades
		# Übergibt das gesamte 'upgrade'-Objekt anstatt nur der ID
		btn_instance.pressed.connect(_on_upgrade_pressed.bind(upgrade))

func _on_upgrade_pressed(upgrade: UpgradeData) -> void:
	print("[UI] Kaufversuch für Upgrade: ", upgrade.id)
	
	var success: bool = UpgradeManager.try_purchase(upgrade)
	if success:
		print(">> Upgrade erfolgreich gekauft!")
		# Optional: UI aktualisieren, z.B. Geldanzeige
