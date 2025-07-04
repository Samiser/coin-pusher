extends Node3D

@export var coin_scene: PackedScene
@onready var machine := $Machine
@onready var coin_label := $CanvasLayer/CoinBalanceLabel
@onready var ui := $UI

var machine_scenes := {
	"first": preload("res://Objects/Machines/FirstMachine/first_machine.tscn"),
	"pinball": preload("res://Objects/Machines/PinballMachine/pinball_machine.tscn"),
	"bowling": preload("res://Objects/Machines/BowlingMachine/bowling_machine.tscn"),
}

var coins := 10:
	set(value):
		ui.set_balance(value)
		coins = value

func update_coin_count(value: int) -> void:
	coins += value

func switch_machine(machine_name: String) -> void:
	if machine:
		machine.queue_free()
	
	if machine_name in machine_scenes:
		var new_machine: CoinMachine = machine_scenes[machine_name].instantiate()
		add_child(new_machine)
		machine = new_machine
		machine.connect("coin_collected", update_coin_count)
	else:
		push_error("Unknown machine name: %s" % machine_name)

func drop_coin() -> void:
	machine.spawn_coin()
	coins -= 1

func _ready() -> void:
	machine.connect("coin_collected", update_coin_count)
	ui.connect("machine_selected", switch_machine)
	ui.connect("drop_triggered", drop_coin)
	ui.set_balance(coins)
