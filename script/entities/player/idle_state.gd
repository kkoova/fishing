extends NodeState

@export var player: Player
@export var animated_sprite: AnimatedSprite2D

var direction: Vector2


func _on_process(_delta: float) -> void:
	pass


func _on_physics_process(_delta: float) -> void:
	direction = GameInputEvent.movement_input()

	if player.player_direction == Vector2.UP:
		animated_sprite.play("idle_back")
	elif player.player_direction == Vector2.DOWN:
		animated_sprite.play("idle_front")
	elif player.player_direction == Vector2.LEFT:
		animated_sprite.play("idle_left")
	elif player.player_direction == Vector2.RIGHT:
		animated_sprite.play("idle_right")
	else:
		animated_sprite.play("idle_front")


func _on_next_transitions() -> void:
	if Input.is_action_just_pressed("interact"):
		transition.emit("FishingStart")
	elif GameInputEvent.is_movement_input():
		transition.emit("Walk")

func _on_enter() -> void:
	player.remove_bobber()
	animated_sprite.flip_h = false

func _on_exit() -> void:
	animated_sprite.stop()
