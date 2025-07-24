extends Board

@onready var slots := $slots
@onready var slot_trigger := $slot_trigger

signal add_combo (value:int)

func _flash_and_reset_all_slots() -> void:
	for slot in slots.get_children():
		slot.toggle_light(1)

func _on_slot_hit(_pin: Pin) -> void:
	_flash_and_reset_all_slots()

func _ready() -> void:
	slot_trigger.connect("hit", _on_slot_hit)
