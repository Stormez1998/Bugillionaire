extends Node

# Speichert die IDs aller bisher gekauften Upgrades (das "Inventar" des Spielers)
var unlocked_upgrades: Array[String] = []

# Erhält nun direkt das Daten-Objekt vom UI
func try_purchase(upgrade: UpgradeData) -> bool:
	# 1. Prüfen: Wurde dieses Upgrade bereits gekauft?
	if unlocked_upgrades.has(upgrade.id):
		print("[UpgradeManager] Bereits gekauft: ", upgrade.id)
		return false
		
	# 2. Prüfen: Ist die Vorbedingung erfüllt? (Wenn eine existiert)
	if upgrade.prerequisite_id != "" and not unlocked_upgrades.has(upgrade.prerequisite_id):
		print("[UpgradeManager] Vorbedingung fehlt. Benötigt: ", upgrade.prerequisite_id)
		return false
		
	# 3. Prüfen: Genug Geld vorhanden?
	if GameState.current_money < upgrade.cost:
		print("[UpgradeManager] Zu wenig Geld für ", upgrade.display_name)
		return false
		
	# 4. Transaktion durchführen
	GameState.current_money -= upgrade.cost
	unlocked_upgrades.append(upgrade.id) # In die Liste der gekauften Upgrades aufnehmen
	
	_apply_effect(upgrade)
	return true

func _apply_effect(upgrade: UpgradeData) -> void:
	match upgrade.effect_type:
		"max_health":
			GameState.player_max_health += upgrade.effect_value
			GameState.reset_round()
			print("Max HP erhöht!")
		"damage":
			# Zukünftige Verknüpfung mit der Waffe
			print("Schaden erhöht um: ", upgrade.effect_value)
		"unlock_spike":
			GameState.spiked_insect_unlocked = true
			print("Dornenkäfer freigeschaltet!")
