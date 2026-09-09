extends Node2D

var basic_insect_scene: PackedScene = preload("res://scenes/entities/Insect.tscn")
var spiked_insect_scene: PackedScene = preload("res://scenes/entities/SpikedInsect.tscn")

@onready var insect_spawner: Timer = $InsectSpawner
@onready var round_timer: Timer = $RoundTimer
@onready var time_label: Label = $Ui/TimeLabel
@onready var ui: CanvasLayer = $Ui

# Neue Referenz auf das Rechteck
@onready var spawn_area: ReferenceRect = $SpawnArea 

func _ready() -> void:
	insect_spawner.wait_time = 1.5 * GameState.spawn_rate_multiplier
	insect_spawner.start()
	GameState.player_died.connect(_on_player_died)
	print("MainLevel gestartet. Runde beginnt!")

func _process(_delta: float) -> void:
	if not round_timer.is_stopped():
		time_label.text = "Zeit: " + str(int(round_timer.time_left)) + "s"

func _on_player_died() -> void:
	insect_spawner.stop()
	round_timer.stop() # Timer zwingend stoppen, da die Runde vorzeitig endet
	ui.show_end_screen("death")

func _on_insect_spawner_timeout() -> void:
	var insect_instance: Area2D
	# Prüft, ob der Dornenkäfer freigeschaltet ist, bevor er in den Pool aufgenommen wird
	if GameState.spiked_insect_unlocked and randf() <= 0.1:
		insect_instance = spiked_insect_scene.instantiate()
	else:
		insect_instance = basic_insect_scene.instantiate()
	
	# Auslesen der globalen Grenzen des gezeichneten Rechtecks
	var rect: Rect2 = spawn_area.get_global_rect()
	
	# Dynamische Berechnung basierend auf der Rect-Größe im Editor
	var random_x: float = randf_range(rect.position.x, rect.position.x + rect.size.x)
	var random_y: float = randf_range(rect.position.y, rect.position.y + rect.size.y)
	
	insect_instance.position = Vector2(random_x, random_y)
	add_child(insect_instance)

func _on_round_timer_timeout() -> void:
	insect_spawner.stop()
	time_label.text = "Zeit: 0s"
	ui.show_end_screen("timeout")
