extends Area2D

var health: float = 3.0
var max_health: float = 3.0

@onready var life_bar: ProgressBar = $LifeBar


func _ready() -> void:
	# Initialisiert den Lebensbalken mit den korrekten Werten
	life_bar.max_value = max_health
	life_bar.value = health
	life_bar.show_percentage = false

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	# Prüft, ob das Event ein Mausklick (linke Taste) ist und gerade heruntergedrückt wird
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		take_damage(1.0)

func take_damage(amount: float) -> void:
	health -= amount
	life_bar.value = health # Balken aktualisieren
	
	if health <= 0.0:
		GameState.add_money(5.0) 
		queue_free()
