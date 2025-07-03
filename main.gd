extends Node3D

@export var coin_scene: PackedScene

@onready var machine = $Machine

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("drop"):
		var coin: Node3D = coin_scene.instantiate()
		add_child(coin)
		coin.rotation = Vector3(0, 90, 0)
		coin.position = machine.get_random_drop_location()
