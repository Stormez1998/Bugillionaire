extends Node

signal money_changed(new_amount: float)
signal player_health_changed(new_health: float) # Neues Signal für die UI

var current_money: float = 0.0
var total_xp: float = 0.0
var prestige_multiplier: float = 1.0

# Neue Variablen für das Spielerleben
var player_max_health: float = 100.0
var player_health: float = 100.0

func add_money(amount: float) -> void:
	var final_amount: float = amount * prestige_multiplier
	current_money += final_amount
	money_changed.emit(current_money)
	print("[GameState] Geld erhalten: ", final_amount, " | Neuer Kontostand: ", current_money)

# Die fehlende Funktion, die vom SpikedInsect aufgerufen wird
func take_player_damage(amount: float) -> void:
	player_health -= amount
	player_health_changed.emit(player_health) # Informiert die UI über den neuen Wert
	
	print("[GameState] Spieler erleidet Schaden: ", amount, " | Rest-HP: ", player_health)
	
	if player_health <= 0.0:
		print("[GameState] Game Over! Spieler hat keine Lebenspunkte mehr.")
		# Hier kann später das Spiel pausiert oder ein Game-Over-Screen geladen werden
