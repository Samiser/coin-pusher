extends Node3D

@onready var pins := $Pins
@onready var bowling_ball := $BowlingBall
@onready var strike_audio := $StrikeAudio

signal add_combo (value:int)

func _flash_and_reset_all_pins() -> void:
	for pin in pins.get_children():
		pin.flash_and_reset()

func _on_pin_hit(_pin: Pin) -> void:
	var all_pins_hit := pins.get_children().all(func(pin: Pin) -> bool: return pin.is_hit)
	if all_pins_hit:
		_flash_and_reset_all_pins()
		bowling_ball.freeze = false
		bowling_ball.position = Vector3(-0.6, 2, 0.1)
		bowling_ball.linear_velocity = Vector3(3, -10, 0)
		emit_signal("add_combo", 1)
		strike_audio.play()
		await get_tree().create_timer(1)
		

func _ready() -> void:
	for pin in pins.get_children():
		pin.connect("hit", _on_pin_hit)
