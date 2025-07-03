extends Node3D

@onready var drop_locations := $DropLocations
@onready var coin_detector: Area3D = $CoinDetector
@onready var coin_label: RichTextLabel

var coins := 10

func _ready() -> void:
	var parent_node: Node3D = get_parent_node_3d()
	coin_label = parent_node.get_node("CanvasLayer/coin_label") # this feels stinky
	update_coin_count(0)
	
	coin_detector.connect("body_entered", _coin_detected)

func get_random_drop_location() -> Vector3:
	return drop_locations.get_children().pick_random().global_position

func _coin_detected(body:Node3D) -> void:
	update_coin_count(1)

func update_coin_count(change:int) -> void:
	coins += change
	coin_label.set_text(str("Coins: ", coins))
