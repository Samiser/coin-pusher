extends VBoxContainer

@onready var coin_follow_button := $CoinFollowButton

signal debug_menu_button(option: String)

func _ready() -> void:
	coin_follow_button.connect("pressed", func() -> void: emit_signal("debug_menu_button", "coin_follow"))
