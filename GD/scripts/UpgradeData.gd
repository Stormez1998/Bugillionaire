class_name UpgradeData
extends Resource

@export var category: String
@export var id: String
@export var display_name: String
@export var cost: float
@export var effect_type: String
@export var effect_value: float
@export var prerequisite_id: String = "" # Leer lassen, wenn keine Voraussetzung existiert
@export_multiline var description: String
