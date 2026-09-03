extends Node

# Neues Signal, das den aktualisierten Geldbetrag übergibt
signal money_changed(new_amount: float)

var current_money: float = 0.0
var total_xp: float = 0.0
var prestige_multiplier: float = 1.0

func add_money(amount: float) -> void:
	var final_amount: float = amount * prestige_multiplier
	current_money += final_amount
	
	# Signal an alle verbundenen Empfänger senden
	money_changed.emit(current_money)
	
	print("[GameState] Geld erhalten: ", final_amount, " | Neuer Kontostand: ", current_money)
