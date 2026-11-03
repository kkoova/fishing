extends NodeState

@export var player: Player
@export var animated_sprite: AnimatedSprite2D
@export var min_wait_time: float = 2.0
@export var max_wait_time: float = 6.0

var wait_timer: float = 0.0

func _on_enter() -> void:
	wait_timer = randf_range(min_wait_time, max_wait_time)
	animated_sprite.play("fishing_idle_front")
	# Здесь можно заспавнить поплавок на воде (используя ваши ассеты воды)

func _on_physics_process(delta: float) -> void:
	wait_timer -= delta
	if wait_timer <= 0.0:
		# Клюнуло!
		transition.emit("FishingCatch")

func _on_next_transitions() -> void:
	# Игрок может отменить рыбалку
	if Input.is_action_just_pressed("interact"):
		transition.emit("Idle")
