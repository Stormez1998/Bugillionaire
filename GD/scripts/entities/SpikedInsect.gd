# Erbt die gesamte Logik des Standard-Insekts
extends "res://scripts/entities/Insect.gd"

@export var reflect_damage: float = 50.0 # Schaden, den der Spieler pro Klick erleidet

func _ready() -> void:
	# Wir können Werte aus der Elternklasse überschreiben, z.B. mehr HP
	max_health = 5.0
	health = 5.0
	super() # Ruft die _ready() Funktion der Elternklasse auf (für die Lebensleiste)

# Überschreibt die take_damage Funktion des Basis-Insekts
func take_damage(amount: float) -> void:
	print("Autsch! Dornenkäfer wehrt sich!")
	
	# Fügt dem Spieler Schaden über das GameState-Singleton zu
	GameState.take_player_damage(reflect_damage)
	
	# Führt den restlichen Code (HP abziehen, Geld geben, Sterben) aus der Elternklasse aus
	super(amount)
