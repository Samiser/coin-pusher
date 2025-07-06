extends CoinMachine

@onready var drop_location_marker := $DropLocation
@onready var boards := $Boards

signal add_combo (value:int)

func _get_drop_location() -> Vector3:
	return drop_location_marker.global_position

func _ready() -> void:
	super._ready()
	for board in boards.get_children():
		board.connect("add_combo", func(value: int) -> void: emit_signal("add_combo", value))
	
