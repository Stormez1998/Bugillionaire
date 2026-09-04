extends Node2D

var damage: float = 1.0
var is_player_cursor: bool = true # Gibt an, ob diese Hand von der Maus gesteuert wird

func _process(delta: float) -> void:
	if is_player_cursor:
		# Die Hand folgt exakt der Mausposition
		global_position = get_global_mouse_position()

# Spätere Ausbaustufe für Upgrades (Auto-Klicker):
# func _on_auto_attack_timer_timeout():
#     Finde Insekt in der Nähe und füge 'damage' zu
