extends Node

signal money_changed(new_amount: float) # Signal für die UI
signal player_health_changed(new_health: float) # Signal für die UI
signal player_died() # Signal für die UI
signal player_hearts_changed(new_hearts: int) # Signal für die UI

var current_money: float = 0.0
var total_xp: float = 0.0
var prestige_multiplier: float = 1.0

# Variablen für das Spielerleben
var player_max_health: float = 100.0
var player_health: float = 100.0
var player_max_hearts: int = 3
var player_hearts: int = 3

# Funktion für das Zurücksetzen am Rundenanfang
func reset_round() -> void:
	player_health = player_max_health
	player_health_changed.emit(player_health)
	
	print("[GameState] Werte für neue Runde zurückgesetzt.")

#  Wird vom Hauptmenü beim Spielstart aufgerufen
func reset_full_game() -> void:
	player_hearts = player_max_hearts
	player_hearts_changed.emit(player_hearts)
	reset_round()

func add_money(amount: float) -> void:
	var final_amount: float = amount * prestige_multiplier
	current_money += final_amount
	money_changed.emit(current_money)
	print("[GameState] Geld erhalten: ", final_amount, " | Neuer Kontostand: ", current_money)

func take_player_damage(amount: float) -> void:
	player_health -= amount
	
	if player_health <= 0.0:
		player_health = 0.0
		
		# Herz abziehen, wenn der Spieler stirbt
		if player_hearts > 0:
			player_hearts -= 1
			player_hearts_changed.emit(player_hearts)
			print("[GameState] Spieler gestorben. Verbleibende Herzen: ", player_hearts)
			
		player_died.emit()
		
	player_health_changed.emit(player_health)
