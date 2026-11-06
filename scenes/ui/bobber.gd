extends Node2D

@export var sprite: AnimatedSprite2D 

func _ready() -> void:
	sprite.play("splash")
	await sprite.animation_finished
	sprite.play("idle")
