extends CanvasLayer

# Referenz auf das Label-Node holen
@onready var money_label: Label = $MoneyLabel

func _ready() -> void:
	# Signal aus dem Singleton mit der lokalen Funktion verbinden
	GameState.money_changed.connect(_on_money_changed)
	
	# Initialer Aufruf, um den Startwert von 0.0 sofort anzuzeigen
	_on_money_changed(GameState.current_money)

# Diese Funktion wird automatisch aufgerufen, sobald money_changed.emit() feuert
func _on_money_changed(new_amount: float) -> void:
	money_label.text = "Geld: " + str(new_amount)
	print("[UI] Anzeige aktualisiert auf: ", new_amount)
