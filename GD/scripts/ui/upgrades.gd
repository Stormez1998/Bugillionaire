extends Control

@export var tree_parent: Control

var _tree_view: YggdrasilTreeView

func _ready():
	var tree: YggdrasilTree = YggdrasilLoader.load_tree("Hand/Stärkerer Schlag")
	var builder: YggdrasilBuilder = YggdrasilBuilder.new(tree)
	builder.set_parent(tree_parent)
	_tree_view = builder.build()
