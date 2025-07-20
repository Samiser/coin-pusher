extends TextureRect # should add base window script eventually

@onready var window_title : RichTextLabel = $title
@onready var window_close_button := $close_button

@onready var coin_info := $info
@onready var coin_height_slider := $slider_bg/height_slider
@onready var track_button := $track_button
@onready var coin_cam := $SubViewportContainer/SubViewport/coin_track_camera

var coin : Coin

var dragging := false
var highlighted := false

func _ready() -> void:
	await get_tree().process_frame
	
	coin_height_slider.min_value = 0
	coin_height_slider.max_value = coin.spawn_height
	window_title.text = "Coin (" + str(coin.id) + ")"

func _process(delta: float) -> void:
	if !is_instance_valid(coin):
		queue_free()
		return
	
	coin_cam.global_position.x = coin.global_position.x
	coin_cam.global_position.y = coin.global_position.y
	
	var coin_alive_time := Time.get_ticks_msec() - coin.spawn_time
	coin_info.text = "Location\n" + str(coin_alive_time) + "t"
	
	coin_height_slider.value = coin.global_position.y
		
	if Input.is_action_pressed("click"):
		if highlighted:
			global_position = get_global_mouse_position()
		
func _on_area_2d_mouse_entered() -> void:
	highlighted = true
	print("window hightlighted")

func _on_area_2d_mouse_exited() -> void:
	if !Input.is_action_pressed("click"):
		highlighted = false

func _on_close_button_pressed() -> void:
	var tween := get_tree().create_tween()
	tween.tween_property(self, "global_position:y", 1200, 0.1)
	await tween.finished
	queue_free()

func _on_track_button_pressed() -> void:
	pass # Replace with function body.
