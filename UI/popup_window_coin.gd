extends Window
class_name CoinPopup

@onready var window_title : RichTextLabel = $title

@onready var coin_info := $info
@onready var coin_height_slider := $slider_bg/height_slider
@onready var track_button := $track_button
@onready var coin_cam := $SubViewportContainer/SubViewport/coin_track_camera

var coin : Coin

func _ready() -> void:
	await get_tree().process_frame # coin is set a frame late
	
	coin_height_slider.min_value = 0
	coin_height_slider.max_value = coin.spawn_height
	window_title.text = "Coin (" + str(coin.id) + ")"
	
	var tween := get_tree().create_tween()
	tween.tween_property(window_title, "visible_ratio", 1, 0.4).from(0.0) 

func _process(delta: float) -> void:
	if !is_instance_valid(coin):
		queue_free()
		return

	coin_cam.global_position.x = coin.global_position.x
	coin_cam.global_position.y = coin.global_position.y
	
	var coin_alive_time := (Time.get_ticks_msec() - coin.spawn_time) / 1000
	coin_info.text = "Location\n" + str(coin_alive_time) + "s"
	
	coin_height_slider.value = coin.global_position.y
		
func _on_track_button_pressed() -> void:
	pass # Replace with function body.


func _on_close_requested() -> void:
	queue_free()
