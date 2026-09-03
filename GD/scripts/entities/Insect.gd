extends Area2D

var health: float = 3.0

func _ready() -> void:
	# Bestätigt, dass das Objekt erfolgreich geladen wurde
	print("Insekt gespawnt. Start-HP: ", health)

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	# Prüft, ob das Event ein Mausklick (linke Taste) ist und gerade heruntergedrückt wird
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		take_damage(1.0)

func take_damage(amount: float) -> void:
	health -= amount
	print("Klick registriert! Schaden: ", amount, " | Verbleibende HP: ", health)
	
	if health <= 0.0:
		print("Insekt eliminiert! Sende Belohnung an GameState...")
		
		# Ruft die globale Methode auf und übergibt z.B. 5.0 als Belohnung
		GameState.add_money(5.0) 
		
		queue_free()
