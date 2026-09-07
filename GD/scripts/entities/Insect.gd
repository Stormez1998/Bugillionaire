extends Area2D

@export var max_health: float = 3.0
@export var reward_money: float = 5.0
@export var speed: float = 50.0 # Einstellbar im Inspektor

var health: float
var direction: Vector2

@onready var life_bar: ProgressBar = $LifeBar
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	health = max_health
	life_bar.max_value = max_health
	life_bar.value = health
	life_bar.show_percentage = false
	
	# Erzeugt eine zufällige Richtung zwischen -1 und 1 auf beiden Achsen
	direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
	_update_animation()

func _process(delta: float) -> void:
	# Aktualisiert die Position kontinuierlich
	position += direction * speed * delta

func _update_animation() -> void:
	# Prüft, ob die Bewegung primär horizontal oder vertikal stattfindet
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			animated_sprite.play("move_right")
		else:
			animated_sprite.play("move_left")
	else:
		if direction.y > 0:
			animated_sprite.play("move_down")
		else:
			animated_sprite.play("move_up")

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# Sucht die aktive Spielerhand auf dem Spielfeld
		var player_hand: Node2D = get_tree().get_first_node_in_group("PlayerHand")
		
		# Prüft, ob die Hand existiert und angriffsbereit ist
		if player_hand and player_hand.try_attack():
			take_damage(player_hand.damage)

func take_damage(amount: float) -> void:
	health -= amount
	life_bar.value = health
	
	if health <= 0.0:
		# Nutzt nun die flexible Variable statt dem festen Wert 5.0
		GameState.add_money(reward_money) 
		queue_free()
