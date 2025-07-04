extends CoinMachine

@onready var drop_locations := $DropLocations
@onready var pins := $Pins
@onready var bowling_ball := $BowlingBall

func _get_random_drop_location() -> Vector3:
	return drop_locations.get_children().pick_random().global_position

func spawn_coin() -> void:
	var coin := coin_scene.instantiate()
	add_child(coin)
	coin.rotation_degrees = Vector3(90, 0, 0)
	coin.position = _get_random_drop_location()

func _flash_and_reset_all_pins() -> void:
	for pin in pins.get_children():
		pin.flash_and_reset()

func _on_pin_hit(_pin: Pin) -> void:
	var all_pins_hit := pins.get_children().all(func(pin: Pin) -> bool: return pin.is_hit)
	if all_pins_hit:
		print("all pins hit!!!")
		bowling_ball.freeze = false
		_flash_and_reset_all_pins()

func _ready() -> void:
	for pin in pins.get_children():
		pin.connect("hit", _on_pin_hit)
