extends Node3D

@onready var drop_locations = $DropLocations

func get_random_drop_location() -> Vector3:
	return drop_locations.get_children().pick_random().global_position
