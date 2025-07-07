extends VBoxContainer

@onready var volume_slider := $Volume/HSlider

func _ready() -> void:
	volume_slider.connect("value_changed", func(value: float) -> void:
		AudioServer.set_bus_volume_linear(0, value)
	)
