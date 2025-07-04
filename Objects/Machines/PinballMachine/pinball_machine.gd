extends CoinMachine

@onready var drop_locations := $DropLocations
@onready var led_parent := $ChargeLeds
@onready var bumper_parent := $Bumpers

var charge_value := 0

func _ready() -> void:
	for bumper in bumper_parent.get_children():
		bumper.connect("bumped", bumper_charge)

func _get_random_drop_location() -> Vector3:
	return drop_locations.get_children().pick_random().global_position

func spawn_coin() -> void:
	var coin := coin_scene.instantiate()
	add_child(coin)
	coin.rotation_degrees = Vector3(90, 0, 0)
	coin.position = _get_random_drop_location()

func bumper_charge() -> void:
	for i in range(led_parent.get_child_count()):
		if i > charge_value:
			break
		led_parent.get_child(i).toggle_light(1)
	
	charge_value += 1
	if(charge_value >= 4):
		coin_rain()
		charge_value = 0
		for led in led_parent.get_children():
			led.toggle_light(0.2)
