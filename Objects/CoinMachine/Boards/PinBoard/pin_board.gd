extends Board

@onready var pins := $Pins

signal add_combo (value:int)

func _flash_and_reset_all_pins() -> void:
	for pin in pins.get_children():
		pin.flash_and_reset()

func _on_pin_hit(_pin: Pin) -> void:
	var all_pins_hit := pins.get_children().all(func(pin: Pin) -> bool: return pin.is_hit)
	if all_pins_hit:
		_flash_and_reset_all_pins()
		emit_signal("add_combo", 1)

func _ready() -> void:
	for pin in pins.get_children():
		pin.connect("hit", _on_pin_hit)
