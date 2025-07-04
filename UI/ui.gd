extends CanvasLayer

@onready var coin_balance_label := $CoinBalanceLabel
@onready var machine_buttons := $MachineButtons
@onready var drop_button := $DropButton
@onready var shop := $Panel/Shop

signal machine_selected(machine: String)
signal drop_triggered
signal purchase(item_name: String, cost: int)

func set_balance(value: int) -> void:
	coin_balance_label.set_text(str("Coins: ", value))

func _ready() -> void:
	for button in machine_buttons.get_children():
		button.connect("pressed", func() -> void:
			emit_signal("machine_selected", button.text.to_lower())
		)

	drop_button.connect("pressed", func() -> void:
		emit_signal("drop_triggered")
	)
	
	shop.connect("purchase", func(item_name: String, cost: int) -> void:
		emit_signal("purchase", item_name, cost)
	)
