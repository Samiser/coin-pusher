extends Node3D

@onready var led_parent := $ChargeLeds
@onready var bumper_parent := $Bumpers

var charge_value := 0

func _ready() -> void:
	for bumper in bumper_parent.get_children():
		bumper.connect("bumped", bumper_charge)

func bumper_charge() -> void:
	for i in range(led_parent.get_child_count()):
		if i > charge_value:
			break
		led_parent.get_child(i).toggle_light(1)
	
	charge_value += 1
	if(charge_value >= 4):
		#coin_rain()
		charge_value = 0
		for led in led_parent.get_children():
			led.toggle_light(0.2)
