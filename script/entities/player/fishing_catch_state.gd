extends NodeState

@export var player: Player
@export var animated_sprite: AnimatedSprite2D

func _on_enter() -> void:
	player.velocity = Vector2.ZERO
	
	player.remove_bobber()
	
	if player.player_direction == Vector2.UP:
		animated_sprite.play("fishing_end_back")
	elif player.player_direction == Vector2.LEFT:
		animated_sprite.play("fishing_end_side")
		animated_sprite.flip_h = false
	elif player.player_direction == Vector2.RIGHT:
		animated_sprite.play("fishing_end_side")
		animated_sprite.flip_h = true
	else:
		animated_sprite.play("fishing_end_front")
	
	var caught_fish = player.last_caught_item
	
	if caught_fish:
		await get_tree().create_timer(1.5).timeout
		animated_sprite.play("new_item")
		await get_tree().create_timer(0.8).timeout
		player.show_caught_item(caught_fish.icon)
		await get_tree().create_timer(5.4).timeout

	transition.emit("Idle")

func _on_exit() -> void:
	animated_sprite.stop()
