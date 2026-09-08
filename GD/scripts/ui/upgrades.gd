extends Control

@export var tree_parent: Control
var _tree_view: YggdrasilTreeView

func _ready() -> void:
	var tree: YggdrasilTree = YggdrasilLoader.load_tree("BugillionaireProgression/GeneralTree")
	var builder: YggdrasilBuilder = YggdrasilBuilder.new(tree)
	builder.set_parent(tree_parent)
	_tree_view = builder.build()
	
	# Verbindet das Klick-Signal des Yggdrasil-UIs mit unserem Skript.
	# (Hinweis: Der genaue Signalname kann je nach Yggdrasil-Version leicht abweichen, 
	# häufig ist es "node_clicked" oder "skill_activated").
	if _tree_view.has_signal("node_clicked"):
		_tree_view.node_clicked.connect(_on_skill_node_clicked)

# Wird aufgerufen, wenn der Spieler im UI auf einen Skill klickt
func _on_skill_node_clicked(node_id: String) -> void:
	print("Klick auf Upgrade-Node: ", node_id)
	
	# Leitet die Anfrage an das Backend weiter
	var success: bool = UpgradeManager.try_unlock_upgrade(UpgradeManager.TreeType.GENERAL, node_id)
	
	if success:
		print("Upgrade erfolgreich gekauft!")
		# Hier könntest du optional das UI aktualisieren (z.B. Geld-Anzeige erneuern)
	else:
		print("Kauf fehlgeschlagen.")
