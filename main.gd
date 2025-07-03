extends Node3D

@export var coin_scene: PackedScene
@onready var machine := $Machine
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("drop") && machine.coins > 0:
		var coin := coin_scene.instantiate()
		add_child(coin)
		coin.rotation_degrees = Vector3(90, 0, 0)
		coin.position = machine.get_random_drop_location()
		
		machine.update_coin_count(-1)
