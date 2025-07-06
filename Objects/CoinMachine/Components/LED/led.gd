extends Node3D
@onready var led_sprite : Sprite3D = $Sprite3D

func _ready() -> void:
	toggle_light(0.2)

func toggle_light(brightness:float) -> void:
	var tween := get_tree().create_tween() 
	tween.set_loops(4)
	
	tween.tween_property(led_sprite, "modulate", Color.BLACK, 0.1)
	var flash_color := Color.WHITE * brightness
	flash_color.a = 1
	tween.tween_property(led_sprite, "modulate", flash_color, 0.1)
