extends Node

# Variablen initialisieren
var current_money: float = 0.0
var total_xp: float = 0.0
var prestige_multiplier: float = 1.0

# Funktion zum Hinzufügen von Geld unter Berücksichtigung des Prestige-Faktors
func add_money(amount: float) -> void:
	var final_amount: float = amount * prestige_multiplier
	current_money += final_amount
	# Kontostand in der Konsole ausgeben
	print("[GameState] Geld erhalten: ", final_amount, " | Neuer Kontostand: ", current_money)
