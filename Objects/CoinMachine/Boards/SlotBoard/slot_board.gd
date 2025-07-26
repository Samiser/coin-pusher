extends Board

@onready var slots := $slots
@onready var slot_trigger := $slot_trigger
@export var slot_images : Array[Texture2D]

func _flash_and_reset_all_slots() -> void:
	for slot in slots.get_children():
		slot.change_texture(slot_images[0])

func _on_slot_hit(_pin: Pin) -> void:
	_flash_and_reset_all_slots()

func _ready() -> void:
	slot_trigger.connect("hit", _on_slot_hit)
