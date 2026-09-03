extends Node2D

var insect_scene: PackedScene = preload("res://scenes/entities/Insect.tscn")

# Aktualisierte Referenzen auf die Nodes im Szenenbaum
@onready var insect_spawner: Timer = $InsectSpawner
@onready var round_timer: Timer = $RoundTimer
@onready var time_label: Label = $Ui/TimeLabel

func _ready() -> void:
	print("MainLevel gestartet. Runde beginnt!")

func _process(_delta: float) -> void:
	if not round_timer.is_stopped():
		time_label.text = "Zeit: " + str(int(round_timer.time_left)) + "s"

# Hinweis: Stelle sicher, dass das timeout()-Signal des InsectSpawner
# mit dieser aktualisierten Funktion verbunden ist.
func _on_insect_spawner_timeout() -> void:
	var insect_instance: Area2D = insect_scene.instantiate()
	var random_x: float = randf_range(50.0, 1100.0)
	var random_y: float = randf_range(50.0, 600.0)
	
	insect_instance.position = Vector2(random_x, random_y)
	add_child(insect_instance)

func _on_round_timer_timeout() -> void:
	insect_spawner.stop() # Stoppt den umbenannten Spawner
	time_label.text = "Zeit: 0s"
	print("Runde beendet! InsectSpawner wurde gestoppt.")
