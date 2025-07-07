@tool
extends Node3D

@onready var glass := $Glass
@onready var bottom_glass := $BottomGlass

func _ready() -> void:
	if get_parent().is_in_group("bottom"):
		glass.visible = false
		bottom_glass.visible = true

func _process(delta: float) -> void:
	if get_parent().is_in_group("bottom"):
		glass.visible = false
		bottom_glass.visible = true
	else:
		glass.visible = true
		bottom_glass.visible = false
