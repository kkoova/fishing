extends CanvasLayer

signal minigame_finished(success: bool)

@export var water_area: Panel
@export var green_bar: ColorRect
@export var fish_icon: TextureRect
@export var progress_bar: TextureProgressBar

var fish_data: ItemData
var current_fish_speed: float = 150.0
var green_bar_velocity: float = 0.0
var edge_padding: float = 7.0

# Физика
var gravity: float = 800.0
var jump_force: float = 1500.0
var max_velocity: float = 400.0 
var progress_speed: float = 0.2 

var is_active: bool = false
var progress: float = 0.3 
var fish_target_y: float = 0.0
var fish_timer: float = 0.0

func setup(data: ItemData) -> void:
	fish_data = data
	
	current_fish_speed = data.fish_speed
	var bar_height = max(30.0, 60.0 - (data.difficulty * 5.0))
	green_bar.size.y = bar_height

	progress_bar.max_value = 100
	progress_bar.value = progress * 100

func _ready() -> void:
	await get_tree().process_frame
	
	# Центрируем в начале
	green_bar.position.y = (water_area.size.y - green_bar.size.y) / 2.0
	fish_icon.position.y = water_area.size.y / 2.0
	
	randomize()
	is_active = true
	_pick_new_fish_target()

func _process(delta: float) -> void:
	if not is_active: return
	
	_update_green_bar(delta)
	_update_fish(delta)
	_update_progress(delta)

func _update_green_bar(delta: float) -> void:
	# Гравитация
	green_bar_velocity += gravity * delta
	
	# Ввод
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or Input.is_action_pressed("ui_accept"):
		green_bar_velocity -= jump_force * delta
		
	# Ограничение скорости
	green_bar_velocity = clamp(green_bar_velocity, -max_velocity, max_velocity)
	
	# Движение
	green_bar.position.y += green_bar_velocity * delta
	
	# Границы (привязаны к WaterArea)
	if green_bar.position.y < edge_padding:
		green_bar.position.y = edge_padding
		green_bar_velocity = 0
	elif green_bar.position.y + green_bar.size.y > water_area.size.y - edge_padding:
		green_bar.position.y = water_area.size.y - green_bar.size.y - edge_padding
		green_bar_velocity = 0

func _update_fish(delta: float) -> void:
	fish_icon.position.y = move_toward(fish_icon.position.y, fish_target_y, current_fish_speed * delta)
	
	fish_timer -= delta
	if fish_timer <= 0:
		_pick_new_fish_target()

func _pick_new_fish_target() -> void:
	# Рыба выбирает цель в пределах WaterArea
	fish_target_y = randf_range(0, water_area.size.y - fish_icon.size.y - edge_padding)
	fish_timer = randf_range(0.5, 1.5) - (fish_data.difficulty * 0.05)

func _update_progress(delta: float) -> void:
	var fish_center_y = fish_icon.position.y + (fish_icon.size.y / 2.0)
	var green_top = green_bar.position.y
	var green_bottom = green_bar.position.y + green_bar.size.y
	
	var is_inside = fish_center_y >= green_top and fish_center_y <= green_bottom
	
	if is_inside:
		progress += progress_speed * delta
	else:
		progress -= (progress_speed * 1.2) * delta 
		
	progress = clamp(progress, 0.0, 1.0)
	
	# Обновляем TextureProgressBar (он сам отрисует снизу вверх)
	progress_bar.value = progress * 100.0
	
	if progress >= 1.0:
		_end_minigame(true)
	elif progress <= 0.0:
		_end_minigame(false)

func _end_minigame(success: bool) -> void:
	is_active = false
	minigame_finished.emit(success)
	queue_free()
