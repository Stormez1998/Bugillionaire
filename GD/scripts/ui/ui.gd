extends CanvasLayer

@onready var money_label: Label = $MoneyLabel
@onready var time_label: Label = $TimeLabel
@onready var player_life_bar: ProgressBar = $PlayerLifeBar # Referenz auf den neuen Balken
@onready var end_screen: Panel = $EndScreen
@onready var result_label: Label = $EndScreen/ResultLabel

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
func show_end_screen() -> void:
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
