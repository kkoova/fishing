extends CanvasLayer

signal minigame_finished(success: bool)

@export var green_bar: ColorRect
@export var fish_icon: TextureRect
@export var progress_bar: ProgressBar

var fish_data: ItemData
var current_fish_speed: float = 150.0
var green_bar_velocity: float = 0.0

# Настройки физики
var gravity: float = 1200.0
var jump_force: float = 2000.0
var progress_speed: float = 0.4 # Скорость заполнения шкалы (за ~2.5 сек)

var is_active: bool = false
var progress: float = 0.3 # Начинаем с 30%
var fish_target_y: float = 0.0
var fish_timer: float = 0.0

func setup(data: ItemData) -> void:
	fish_data = data
	fish_icon.texture = data.icon
	
	# Настройка сложности на основе ресурса
	current_fish_speed = data.fish_speed
	var bar_height = max(40.0, 120.0 - (data.difficulty * 10.0))
	green_bar.size.y = bar_height
	
	# Центрируем зеленую зону
	green_bar.position.y = (progress_bar.size.y - bar_height) / 2.0
	fish_icon.position.y = progress_bar.size.y / 2.0

func _ready() -> void:
	# Ждем кадр, чтобы размеры узлов правильно рассчитались
	await get_tree().process_frame
	progress_bar.position.y = green_bar.position.y # Выравниваем полосы
	
	randomize()
	is_active = true
	_pick_new_fish_target()

func _process(delta: float) -> void:
	if not is_active: return
	
	_update_green_bar(delta)
	_update_fish(delta)
	_update_progress(delta)

func _update_green_bar(delta: float) -> void:
	# 1. Гравитация тянет вниз
	green_bar_velocity += gravity * delta
	
	# 2. Управление (ЛКМ)
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or Input.is_action_pressed("ui_accept"):
		green_bar_velocity -= jump_force * delta
		
	# 3. Применяем движение
	green_bar.position.y += green_bar_velocity * delta
	
	# 4. Ограничиваем по краям
	if green_bar.position.y < 0:
		green_bar.position.y = 0
		green_bar_velocity = 0
	elif green_bar.position.y + green_bar.size.y > progress_bar.size.y:
		green_bar.position.y = progress_bar.size.y - green_bar.size.y
		green_bar_velocity = 0

func _update_fish(delta: float) -> void:
	# Рыба плавно движется к цели
	fish_icon.position.y = move_toward(fish_icon.position.y, fish_target_y, current_fish_speed * delta)
	
	# Таймер смены цели
	fish_timer -= delta
	if fish_timer <= 0:
		_pick_new_fish_target()

func _pick_new_fish_target() -> void:
	# Рыба выбирает случайную точку по вертикали
	fish_target_y = randf_range(0, progress_bar.size.y - fish_icon.size.y)
	# Чем сложнее рыба, тем чаще она меняет цель
	fish_timer = randf_range(0.5, 1.5) - (fish_data.difficulty * 0.1)

func _update_progress(delta: float) -> void:
	# Проверяем, находится ли рыба внутри зеленой зоны
	var fish_center_y = fish_icon.position.y + (fish_icon.size.y / 2.0)
	var green_top = green_bar.position.y
	var green_bottom = green_bar.position.y + green_bar.size.y
	
	var is_inside = fish_center_y >= green_top and fish_center_y <= green_bottom
	
	if is_inside:
		progress += progress_speed * delta
	else:
		progress -= progress_speed * delta
		
	progress = clamp(progress, 0.0, 1.0)
	
	# Обновляем визуал полосы прогресса (снизу вверх)
	progress_bar.size.y = progress_bar.get_parent().size.y * progress
	progress_bar.position.y = progress_bar.get_parent().size.y - progress_bar.size.y
	
	# Проверка победы/поражения
	if progress >= 1.0:
		_end_minigame(true)
	elif progress <= 0.0:
		_end_minigame(false)

func _end_minigame(success: bool) -> void:
	is_active = false
	minigame_finished.emit(success)
	queue_free() # Удаляем UI
