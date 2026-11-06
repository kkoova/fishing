extends Node
class_name GameFishingDatabase

static var all_items: Array[ItemData] = []

func _ready() -> void:
	_load_all_resources()

static func _load_all_resources() -> void:
	var dir_path = "res://resourse/fish/"
	var dir = DirAccess.open(dir_path)
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".tres"):
				var item: ItemData = load(dir_path + file_name)
				if item:
					all_items.append(item)
			file_name = dir.get_next()
			
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
