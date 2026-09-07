extends Area2D

# @export macht die Variablen rechts im Inspektor sichtbar
@export var max_health: float = 3.0
@export var reward_money: float = 5.0 

var health: float

@onready var life_bar: ProgressBar = $LifeBar

func _ready() -> void:
	# Setzt die aktuellen HP beim Start auf den im Editor definierten Maximalwert
	health = max_health
	life_bar.max_value = max_health
	life_bar.value = health
	life_bar.show_percentage = false

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		take_damage(1.0)

func take_damage(amount: float) -> void:
	health -= amount
	life_bar.value = health
	
	if health <= 0.0:
		# Nutzt nun die flexible Variable statt dem festen Wert 5.0
		GameState.add_money(reward_money) 
		queue_free()
