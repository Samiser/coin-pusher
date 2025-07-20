extends Window
class_name CoinPopup

@onready var coin_info := $info
@onready var coin_height_slider := $slider_bg/height_slider
@onready var track_button := $track_button
@onready var coin_cam := $preview_image/SubViewportContainer/SubViewport/coin_track_camera
@onready var preview_image := $preview_image

var coin : Coin
var tween : Tween
var mouse_inside := false
var mouse_timer := 0.0

func _ready() -> void:
	await get_tree().process_frame # coin is set a frame late
	
	coin_height_slider.min_value = 0
	coin_height_slider.max_value = coin.spawn_height
	title =  "Coin (" + str(coin.id) + ")"

func _process(delta: float) -> void:
	if !is_instance_valid(coin):
		queue_free()
		return

	coin_cam.global_position.x = coin.global_position.x
	coin_cam.global_position.y = coin.global_position.y
	
	var coin_alive_time := (Time.get_ticks_msec() - coin.spawn_time) / 1000
	coin_info.text = "Location\n" + str(coin_alive_time) + "s"
	
	coin_height_slider.value = coin.global_position.y
	
	if mouse_inside:
		mouse_timer += delta
		if mouse_timer > 0.4 && !preview_image.visible:
			preview_image.visible = true
			var tween : Tween = get_tree().create_tween()
			tween.tween_property(self, "size:x", 430, 0.1)
		
func _on_track_button_pressed() -> void:
	pass # Replace with function body.


func _on_close_requested() -> void:
	queue_free()


func _on_mouse_entered() -> void:
	mouse_inside = true

func _on_mouse_exited() -> void:
	mouse_inside = false
	mouse_timer = 0.0
	preview_image.visible = false
	
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(self, "size:x", 256, 0.1)
