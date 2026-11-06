extends Node
class_name GameFishingDatabase

static var all_items: Array[ItemData] = []

func _ready() -> void:
	_load_all_resources()

# fishing_database.gd

func _load_all_resources() -> void:
	var dir_path = "res://resources/fish/"
	
	var file_list = ResourceLoader.list_directory(dir_path)
	
	for file_name in file_list:
		if file_name.ends_with(".tres"):
			var full_path = dir_path.path_join(file_name)
			var item: ItemData = load(full_path)
			if item:
				all_items.append(item)
				
	print("Загружено предметов для рыбалки: ", all_items.size())

# ГЛАВНАЯ ФУНКЦИЯ: Выбор рыбы с учетом времени и веса
static func get_random_catch() -> ItemData:
	var valid_items: Array[ItemData] = []
	var total_weight: float = 0.0
	
	for item in all_items:
		if item.allowed_time_periods.is_empty() or DayAndNightCycleManager.initial_hour in item.allowed_time_periods:
			valid_items.append(item)
			total_weight += item.drop_weight
			
	if valid_items.is_empty():
		return null # На всякий случай
		
	# 2. Взвешенный рандом (Weighted Random)
	# Кидаем кубик от 0 до общего веса
	var random_roll = randf() * total_weight
	var current_weight: float = 0.0
	
	for item in valid_items:
		current_weight += item.drop_weight
		if random_roll <= current_weight:
			return item
			
	return valid_items.back() # Фолбэк
