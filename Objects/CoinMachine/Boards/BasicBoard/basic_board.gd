@tool
extends Node3D

@onready var glass := $Glass
@onready var bottom_glass := $BottomGlass

func _ready() -> void:
	if get_parent().is_in_group("bottom"):
		glass.visible = false
		bottom_glass.visible = true

func set_disabled(node: StaticBody3D, value: bool) -> void:
	node.visible = !value
	node.get_child(1).disabled = value

func _process(_delta: float) -> void:
	if get_parent().is_in_group("bottom"):
		set_disabled(glass, true)
		set_disabled(bottom_glass, false)
	else:
		set_disabled(glass, false)
		set_disabled(bottom_glass, true)
