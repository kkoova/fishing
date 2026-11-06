extends NodeState

@export var player: Player
@export var minigame_scene: PackedScene # Перетащите сюда FishingMinigame.tscn

func _on_enter() -> void:
	# 1. Выбираем рыбу заранее (до начала мини-игры)
	var caught_item: ItemData = GameFishingDatabase.get_random_catch()
	
	if not caught_item:
		transition.emit("Idle")
		return
		
	# 2. Создаем мини-игру
	var minigame = minigame_scene.instantiate()
	player.get_tree().root.add_child(minigame)
	
	# Передаем данные о рыбе в UI
	minigame.setup(caught_item)
	
	# 3. Слушаем сигнал окончания
	minigame.minigame_finished.connect(_on_minigame_finished.bind(caught_item))

func _on_minigame_finished(success: bool, caught_item: ItemData) -> void:
	if success:
		# Игрок выиграл! Переходим в состояние демонстрации рыбы
		player.last_caught_item = caught_item
		transition.emit("FishingCatch")
	else:
		# Рыба сорвалась
		print("Рыба сорвалась!")
		transition.emit("Idle")
