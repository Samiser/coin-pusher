extends VBoxContainer

@onready var rain_coin_button := $RainCoin/Button
@onready var bomb_coin_button := $BombCoin/Button

signal purchase(item_name: String, cost: int)

func _ready() -> void:
	rain_coin_button.connect("pressed", func() -> void: emit_signal("purchase", "rain_coin", 10))
	bomb_coin_button.connect("pressed", func() -> void: emit_signal("purchase", "bomb_coin", 20))
