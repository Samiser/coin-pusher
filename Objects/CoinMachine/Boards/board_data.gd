extends Resource
class_name BoardData

var index: int
var name: String
var icon: Texture2D

func _init(_index: int, _name: String, _icon: Texture2D) -> void:
	index = _index
	name = _name
	icon = _icon
