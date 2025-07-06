extends CoinMachine

@onready var drop_location_marker := $DropLocation

func _get_drop_location() -> Vector3:
	return drop_location_marker.global_position
