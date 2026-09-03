extends Node2D

# Lädt die Insekten-Szene vor dem Start in den Speicher (Preload ist performanter)
var insect_scene: PackedScene = preload("res://scenes/entities/Insect.tscn")

func _ready() -> void:
	print("MainLevel gestartet. Spawner ist aktiv.")

func _on_timer_timeout() -> void:
	# Erstellt eine neue Instanz der Szene
	var insect_instance: Area2D = insect_scene.instantiate()
	
	# Generiert zufällige Koordinaten innerhalb der sichtbaren Bildschirmgrenzen
	var random_x: float = randf_range(50.0, 1100.0)
	var random_y: float = randf_range(50.0, 600.0)
	
	# Weist dem Insekt die neue Position zu
	insect_instance.position = Vector2(random_x, random_y)
	
	# Fügt das Insekt als Child in den Szenenbaum ein, damit es gerendert wird
	add_child(insect_instance)
	
	print("Neues Insekt gespawnt an Position: X=", random_x, " Y=", random_y)
