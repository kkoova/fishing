extends NodeState

@export var player: Player
@export var animated_sprite: AnimatedSprite2D

func _on_enter() -> void:
	# 1. Анимация подсечки
	animated_sprite.play("fishing_end_front")
	
	var caught_item: ItemData = GameFishingDatabase.get_random_catch()
	if caught_item:
		print("Поймано: ", caught_item.item_name, " (Редкость: ", caught_item.rarity, ")")
	
	await get_tree().create_timer(1.5).timeout
	animated_sprite.play("new_item")
	await get_tree().create_timer(0.8).timeout
	player.show_caught_item(caught_item.icon)
	await get_tree().create_timer(5.4).timeout
	transition.emit("Idle")

func _on_exit() -> void:
	animated_sprite.stop()
