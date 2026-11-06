class_name ItemData extends Resource

@export_group("General")
@export var item_name: String
@export var icon: Texture2D

@export_group("Fishing Logic")
@export var drop_weight: float = 10.0 
@export var allowed_time_periods: Array[int] = [] 
var fish_speed: float = drop_weight * 15
var difficulty: int = drop_weight / 10 
