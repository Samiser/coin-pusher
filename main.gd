extends Node3D

@export var coin_scene: PackedScene
@onready var machine := $CoinMachine
@onready var ui := $UI
@onready var vine_audio := $vine_stream
@onready var money_audio := $money_stream
@onready var camera: Camera3D = $Camera3D

var latest_coin: Coin

var coin_follow: bool = false

var round_goal: int = 100

var coins := 10:
	set(value):
		ui.set_balance(value)
		coins = value

var coin_multi := 1:
	set(value):
		ui.set_multi(value)
		coin_multi = value
		
func _on_add_combo(value: int) -> void:
	coin_multi += value
	vine_audio.play()

func update_coin_count(value: int) -> void:
	if coins >= round_goal:
		print("win!!!!")
	else:
		coins += value * coin_multi
		money_audio.play()

func drop_coin() -> void:
	if coins <= 0:
		print("out of coins!!")
		return

	latest_coin = machine.spawn_coin([])
	coins -= 1

func _physics_process(_delta: float) -> void:
	if latest_coin and coin_follow:
		camera.look_at(latest_coin.position)

func purchase(item_name: String, cost: int) -> void:
	print("purchasing ", item_name, " for ", cost)
	coins -= cost
	
	match item_name:
		"rain", "bomb":
			machine.spawn_ability_coin(item_name)

func debug_option(option: String) -> void:
	match option:
		"coin_follow":
			coin_follow = !coin_follow
			var tween := create_tween()
			if coin_follow == false:
				tween.tween_property(camera, "fov", 75, 1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
				tween.parallel().tween_property(camera, "rotation_degrees", Vector3(-3, 0, 0), 1)
			else:
				tween.tween_property(camera, "fov", 20, 1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func _ready() -> void:
	machine.connect("coin_collected", update_coin_count)
	machine.connect("add_combo", _on_add_combo)
	ui.connect("drop_triggered", drop_coin)
	ui.connect("swap_boards", func() -> void: machine.change_board(0, ["pinball", "bowling", "pin"].pick_random()))
	ui.connect("purchase", purchase)
	ui.connect("debug_menu_button", debug_option)
	ui.set_balance(coins)
	ui.set_multi(coin_multi)
