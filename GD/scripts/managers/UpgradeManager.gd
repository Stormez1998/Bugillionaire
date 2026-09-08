extends Node

@export var general_tree: Resource 
@export var weapon_tree: Resource

enum TreeType { GENERAL, WEAPON }

# Der Parameter 'cost' wurde entfernt, da wir ihn dynamisch auslesen
func try_unlock_upgrade(type: TreeType, node_id: String) -> bool:
	var target_tree: Resource = _get_tree_resource(type)
	
	if target_tree == null:
		push_error("[UpgradeManager] Ziel-Tree nicht gefunden.")
		return false
		
	# Holt den Knoten aus dem Yggdrasil-Tree
	var skill_node: Resource = target_tree.get_node(node_id)
	if skill_node == null:
		return false
	
	# Extrahiert die Kosten aus den Yggdrasil-Attributes ("costs" laut deinem Screenshot)
	var upgrade_cost: float = 0.0
	for attr in skill_node.attributes:
		if attr.name == "costs" and attr.values.size() > 0:
			upgrade_cost = attr.values[0]
			break
		
	if GameState.current_money < upgrade_cost:
		print("[UpgradeManager] Zu wenig Geld. Benötigt: ", upgrade_cost)
		return false
		
	# Yggdrasil API-Aufruf
	if target_tree.has_method("can_allocate") and not target_tree.can_allocate(node_id):
		print("[UpgradeManager] Vorbedingungen im Tree nicht erfüllt.")
		return false
		
	# Transaktion
	GameState.current_money -= upgrade_cost
	if target_tree.has_method("allocate"):
		target_tree.allocate(node_id)
		
	# Effekte anwenden
	_apply_upgrade_effects(skill_node.attributes)
	return true

func _get_tree_resource(type: TreeType) -> Resource:
	match type:
		TreeType.GENERAL:
			return general_tree
		TreeType.WEAPON:
			return weapon_tree
	return null

# Verarbeitet nun alle Attribute, die im Editor angelegt wurden
func _apply_upgrade_effects(attributes: Array) -> void:
	for attr in attributes:
		var effect_name: String = attr.name
		var effect_value: float = 0.0
		if attr.values.size() > 0:
			effect_value = attr.values[0]
			
		match effect_name:
			"player_max_health": # Dein Attribut-Name aus dem Screenshot
				GameState.player_max_health += effect_value
				GameState.reset_round() 
				print("Max HP erhöht um ", effect_value)
			"dmg_up":
				print("Waffenschaden erhöht!")
			"unlock_spiked":
				GameState.spiked_insect_unlocked = true
