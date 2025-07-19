extends CanvasLayer

@onready var coin_balance_label := $CoinBalanceLabel
@onready var coin_multi_label := $CoinMultiLabel
@onready var drop_button := $VBoxContainer/DropButton
@onready var swap_button := $SwapBoards
@onready var add_button := $AddButton
@onready var up_button := $UpButton
@onready var down_button := $DownButton
@onready var remove_button := $RemoveButton
@onready var shop := $ShopPanel/Shop
@onready var shop_button := $shop_button
@onready var debug_menu := $DebugPanel/DebugMenu
@onready var menu_button := $menu_button
@onready var multi_particles := $multi_particles
@onready var coin_particles := $coin_particle
@onready var board_container := $VBoxContainer/board_container

@onready var debug_panel := $DebugPanel
@onready var options_panel := $OptionsPanel
@onready var shop_panel := $ShopPanel

@onready var selection_rect := $selection_rect

@onready var board_title := $board_subtitle

var frame_scene: PackedScene = preload("res://UI/board_frame.tscn")
var select_frame_tex := preload("res://UI/Sprites/ui_board_frame_current.png")
var default_frame_tex := preload("res://UI/Sprites/ui_board_frame.png")

var tween : Tween

signal drop_triggered
signal swap_boards
signal add_board
signal remove_board
signal move_up
signal move_down
signal purchase(item_name: String, cost: int)
signal debug_menu_button(option: String)
signal focus_board(index: int)

var coin_count := 0.0

func add_display_board(data: BoardData) -> void:
	var board_frame_button := frame_scene.instantiate()
	board_container.add_child(board_frame_button)
	board_container.move_child(board_frame_button, 0)
	board_frame_button.set_meta("board_name", data.name)
	board_frame_button.set_texture_normal(data.icon)
	board_frame_button.pressed.connect(func() -> void:
		focus_board.emit(data.index)
	)
	
func remove_display_board() -> void:
	if board_container.get_child_count() > 1:
		board_container.get_child(0).queue_free()

func select_display_board(index: int) -> void:
	await get_tree().process_frame
	var move_index := (board_container.get_child_count() - 1) - index
	if move_index == -1:
		move_index = 0
	board_title.text = board_container.get_child(move_index).get_meta("board_name")
	var selected_height : float = board_container.get_child(move_index).global_position.y
	selection_rect.global_position.y = selected_height
	
	var tween := get_tree().create_tween() 
	tween.set_loops(4)
	
	tween.tween_property(selection_rect, "modulate", Color.LIGHT_GRAY, 0.1)
	tween.tween_property(selection_rect, "modulate", Color.WHITE, 0.1)
	
	
func set_balance(value: int) -> void:
	coin_balance_label.set_text(str(value))
	coin_count += float(value)
	
	tween = get_tree().create_tween()
	tween.tween_property(coin_balance_label, "visible_ratio", 1, 0.1).from(0.0) 
	
	coin_particles.emitting = true

func set_multi(value: int) -> void:
	coin_multi_label.set_text(str(value) + "x")
	multi_particles.emitting = true

func _ready() -> void:
	_ToggleMenu() # hides menu by default
	_ToggleShop()
	drop_button.pressed.connect(func() -> void: emit_signal("drop_triggered"))
	swap_button.pressed.connect(func() -> void: emit_signal("swap_boards"))
	add_button.pressed.connect(func() -> void: emit_signal("add_board"))
	remove_button.pressed.connect(func() -> void: emit_signal("remove_board"))
	
	up_button.pressed.connect(func() -> void: emit_signal("move_up"))
	down_button.pressed.connect(func() -> void: emit_signal("move_down"))
	
	shop_button.pressed.connect(func() -> void: _ToggleShop())
	menu_button.pressed.connect(func() -> void: _ToggleMenu())
	
	shop.purchase.connect(func(item_name: String, cost: int) -> void: 
		emit_signal("purchase", item_name, cost)
	)
	
	debug_menu.debug_menu_button.connect(func(option: String) -> void:
		emit_signal("debug_menu_button", option)
	)

func _ToggleMenu() -> void:
		options_panel.visible = !options_panel.visible
		debug_panel.visible = !debug_panel.visible
func _ToggleShop() -> void:
	shop_panel.visible = !shop_panel.visible
