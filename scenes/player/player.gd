class_name Player
extends CharacterBody2D

@export var caught_item: PackedScene
@export var item_spawn_sprite: Sprite2D
@export var player_visual: PlayerVisuals

var player_direction: Vector2
var last_caught_item: ItemData

func show_caught_item(texture: Texture2D) -> void:
	item_spawn_sprite.texture = texture
	item_spawn_sprite.visible = true
	
	await get_tree().create_timer(5.1).timeout
	
	item_spawn_sprite.texture = null
