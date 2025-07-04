extends Node3D

@export var coin_scene: PackedScene
@onready var machine := $Machine
@onready var coin_label := $CanvasLayer/coin_label

var coins := 10:
	set(value):
		coin_label.set_text(str("Coins: ", value))
		coins = value

func _ready() -> void:
	machine.connect("coin_collected", update_coin_count)
	coin_label.set_text(str("Coins: ", coins))

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("drop") && coins > 0:
		var coin := coin_scene.instantiate()
		add_child(coin)
		coin.rotation_degrees = Vector3(90, 0, 0)
		coin.position = machine.get_random_drop_location()

		coins -= 1

func update_coin_count(value: int) -> void:
	coins += value
