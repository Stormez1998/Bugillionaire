extends Node2D

@export var damage: float = 1.0
@export var base_cooldown: float = 0.5 # Halbe Sekunde Pause zwischen Klicks

var can_click: bool = true
var is_player_cursor: bool = true

@onready var cooldown_timer: Timer = $CooldownTimer

func _ready() -> void:
	# Fügt die Hand einer Gruppe hinzu, damit Insekten sie finden können
	add_to_group("PlayerHand")
	
	cooldown_timer.wait_time = base_cooldown
	cooldown_timer.one_shot = true
	cooldown_timer.timeout.connect(_on_cooldown_timeout)

func _process(_delta: float) -> void:
	if is_player_cursor:
		global_position = get_global_mouse_position()

# Wird vom Insekt aufgerufen, um zu prüfen, ob ein Angriff möglich ist
func try_attack() -> bool:
	if can_click:
		can_click = false
		cooldown_timer.start()
		return true
	return false

func _on_cooldown_timeout() -> void:
	can_click = true
