extends CanvasLayer

@onready var money_label: Label = $MoneyLabel
@onready var time_label: Label = $TimeLabel
@onready var player_life_bar: ProgressBar = $PlayerLifeBar # Referenz auf den neuen Balken
@onready var end_screen: Panel = $EndScreen
@onready var end_title: Label = $EndScreen/EndTitle # Referenz auf den Titel
@onready var result_label: Label = $EndScreen/ResultLabel
@onready var btn_next_round: Button = $EndScreen/BtnNextRound
@onready var btn_upgrades: Button = $EndScreen/BtnUpgrades # Optional: Upgrades auch sperren

func _ready() -> void:
	# Signale verbinden
	GameState.money_changed.connect(_on_money_changed)
	GameState.player_health_changed.connect(_on_player_health_changed)
	
	# Startwerte beim Laden der Szene initialisieren
	_on_money_changed(GameState.current_money)
	
	# Maximalwert des Balkens anhand der GameState-Variable setzen
	player_life_bar.max_value = GameState.player_max_health
	_on_player_health_changed(GameState.player_health)

# Neue Funktion, die vom MainLevel aufgerufen wird
func show_end_screen(reason: String) -> void:
	if reason == "death":
		if GameState.player_hearts > 0:
			end_title.text = "Gestorben! -1 Herz. Verbleibende Herzen: " + str(GameState.player_hearts)
			btn_next_round.show()
		else:
			end_title.text = "Game Over! Keine Herzen mehr."
			btn_next_round.hide()
			btn_upgrades.hide() # Zwingt den Spieler ins Hauptmenü oder in den Abbruch
			
	elif reason == "timeout":
		end_title.text = "Zeit ist abgelaufen!"
		btn_next_round.show()
		
	result_label.text = "Aktueller Kontostand: " + str(GameState.current_money)
	end_screen.show()

func _on_money_changed(new_amount: float) -> void:
	money_label.text = "Geld: " + str(new_amount)

# Neue Funktion zur Aktualisierung des Lebensbalkens
func _on_player_health_changed(new_health: float) -> void:
	player_life_bar.value = new_health


func _on_btn_next_round_pressed() -> void:
	get_tree().reload_current_scene()


func _on_btn_upgrades_pressed() -> void:
	print("[UPGRADES]: In der Erschaffung")
	get_tree().change_scene_to_file("uid://dfxrhgye6fqpj")
