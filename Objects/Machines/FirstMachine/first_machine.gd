extends CoinMachine

@onready var drop_locations := $DropLocations

func _get_drop_location() -> Vector3:
	return drop_locations.get_children().pick_random().global_position
