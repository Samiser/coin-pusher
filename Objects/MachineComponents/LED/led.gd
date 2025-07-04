extends Node3D
@onready var led_sprite : Sprite3D = $Sprite3D

func toggle_light(brightness:float) -> void:
	var tween := get_tree().create_tween() 
	tween.set_loops(4)
	
	tween.tween_property(led_sprite, "modulate", Color.BLACK, 0.1)
	tween.tween_property(led_sprite, "modulate", Color.WHITE * brightness, 0.1)
