extends CoinMachine

@onready var drop_locations := $DropLocations
@onready var pins := $Pins
@onready var bowling_ball := $BowlingBall

func _get_drop_location() -> Vector3:
	return drop_locations.get_children().pick_random().global_position

func _flash_and_reset_all_pins() -> void:
	for pin in pins.get_children():
		pin.flash_and_reset()

func _on_pin_hit(_pin: Pin) -> void:
	var all_pins_hit := pins.get_children().all(func(pin: Pin) -> bool: return pin.is_hit)
	if all_pins_hit:
		await _flash_and_reset_all_pins()
		bowling_ball.freeze = false
		bowling_ball.position = Vector3(-0.6, 2, 0.1)
		bowling_ball.linear_velocity = Vector3(3, -10, 0)

func _ready() -> void:
	for pin in pins.get_children():
		pin.connect("hit", _on_pin_hit)
