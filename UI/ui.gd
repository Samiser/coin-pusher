extends CanvasLayer

@onready var coin_balance_label := $CoinBalanceLabel
@onready var coin_multi_label := $CoinMultiLabel
@onready var machine_buttons := $MachineButtons
@onready var drop_button := $DropButton
@onready var shop := $Panel/Shop
@onready var debug_menu := $DebugPanel/DebugMenu
@onready var multi_particles := $multi_particles

signal drop_triggered
signal purchase(item_name: String, cost: int)
signal debug_menu_button(option: String)

func set_balance(value: int) -> void:
	coin_balance_label.set_text(str("Coins: ", value))

func set_multi(value: int) -> void:
	coin_multi_label.set_text(str("Coins Mult\nx", value))
	multi_particles.emitting = true

func _ready() -> void:

	drop_button.connect("pressed", func() -> void:
		emit_signal("drop_triggered")
	)
	
	shop.connect("purchase", func(item_name: String, cost: int) -> void:
		emit_signal("purchase", item_name, cost)
	)
	
	debug_menu.connect("debug_menu_button", func(option: String) -> void:
		emit_signal("debug_menu_button", option)
	)
