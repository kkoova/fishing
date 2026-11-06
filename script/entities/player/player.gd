class_name Player
extends CharacterBody2D

@export var caught_item: PackedScene
@export var item_spawn_sprite: Sprite2D
@export var player_visual: PlayerVisuals

@export_group("Interaction Settings")
@export var interaction_distance: float = 16.0
@export var tilemap_container: Node2D

var player_direction: Vector2
var last_caught_item: ItemData
var active_bobber: Node2D = null

func show_caught_item(texture: Texture2D) -> void:
	item_spawn_sprite.texture = texture
	item_spawn_sprite.visible = true
	
	await get_tree().create_timer(5.1).timeout
	
	item_spawn_sprite.texture = null

func get_target_position() -> Vector2:
	var dir = player_direction if player_direction != Vector2.ZERO else Vector2.DOWN
	return global_position + (dir * interaction_distance)

func check_tilemap_at(target_pos: Vector2) -> bool:
	for i in range(tilemap_container.get_children().size() - 1, -1, -1):
		var layer = tilemap_container.get_children()[i]
		
		if layer is TileMapLayer:
			var local_pos = layer.to_local(target_pos)
			var map_pos = layer.local_to_map(local_pos)
			var tile_data = layer.get_cell_tile_data(map_pos)
			
			if tile_data:
				return tile_data.get_custom_data("is_water")
				
	return false

func spawn_bobber(bobber_scene: PackedScene, pos: Vector2) -> void:
	remove_bobber() 
	active_bobber = bobber_scene.instantiate()
	get_tree().current_scene.add_child(active_bobber)
	active_bobber.global_position = pos

func remove_bobber() -> void:
	if active_bobber and is_instance_valid(active_bobber):
		active_bobber.queue_free()
		active_bobber = null
