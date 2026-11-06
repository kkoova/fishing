extends NodeState

@export var player: Player
@export var animated_sprite: AnimatedSprite2D

func _on_enter() -> void:
	player.velocity = Vector2.ZERO
	
	if player.player_direction == Vector2.UP:
		animated_sprite.play("fishing_start_back")
	elif player.player_direction == Vector2.LEFT:
		animated_sprite.play("fishing_start_side")
		animated_sprite.flip_h = false
	elif player.player_direction == Vector2.RIGHT:
		animated_sprite.play("fishing_start_side")
		animated_sprite.flip_h = true
	else:
		animated_sprite.play("fishing_start_front")
		
	await animated_sprite.animation_finished
	transition.emit("FishingWait")

func _on_exit() -> void:
	animated_sprite.flip_h = false
