extends NodeState

@export var player: Player
@export var animated_sprite: AnimatedSprite2D
@export var min_wait_time: float = 2.0
@export var max_wait_time: float = 6.0

var wait_timer: float = 0.0
var is_biting: bool = false

func _on_enter() -> void:
	wait_timer = randf_range(min_wait_time, max_wait_time)
	is_biting = false
	player.velocity = Vector2.ZERO
	
	if player.player_direction == Vector2.UP:
		animated_sprite.play("fishing_idle_back")
	elif player.player_direction == Vector2.LEFT:
		animated_sprite.play("fishing_idle_side")
		animated_sprite.flip_h = false
	elif player.player_direction == Vector2.RIGHT:
		animated_sprite.play("fishing_idle_side")
		animated_sprite.flip_h = true
	else:
		animated_sprite.play("fishing_idle_front")
		
	player.player_visual.hide_bite_feedback()
	# Здесь можно заспавнить поплавок на воде (используя ваши ассеты воды)

func _on_physics_process(delta: float) -> void:
	if is_biting:
		return # Ждем реакции игрока
		
	wait_timer -= delta
	if wait_timer <= 0.0:
		is_biting = true
		player.player_visual.show_bite_feedback()

func _on_next_transitions() -> void:
	if is_biting:
		# Если клюнуло и игрок нажал ЛКМ (или interact) -> запускаем мини-игру
		if Input.is_action_just_pressed("interact") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			transition.emit("FishingGame")
	else:
		# Игрок может отменить рыбалку до поклевки
		if Input.is_action_just_pressed("interact"):
			transition.emit("Idle")

func _on_exit() -> void:
	player.player_visual.hide_bite_feedback()
