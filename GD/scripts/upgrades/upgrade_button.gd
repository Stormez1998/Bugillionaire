extends Button

# Speichert die Referenz auf die übergebenen Daten
var upgrade_data: UpgradeData

# Wird vom Haupt-UI aufgerufen, um den Button mit Daten zu füttern
func initialize(data: UpgradeData) -> void:
	upgrade_data = data
	text = data.display_name + "\nKosten: " + str(data.cost)
	tooltip_text = data.description + "\nEffekt: " + str(data.effect_value)
