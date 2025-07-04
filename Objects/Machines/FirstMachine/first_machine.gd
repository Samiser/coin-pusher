extends CoinMachine

@onready var drop_locations := $DropLocations

func _get_random_drop_location() -> Vector3:
	return drop_locations.get_children().pick_random().global_position

func spawn_coin() -> void:
	var coin := coin_scene.instantiate()
	add_child(coin)
	coin.rotation_degrees = Vector3(90, 0, 0)
	coin.position = _get_random_drop_location()
