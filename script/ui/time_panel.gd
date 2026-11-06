extends CanvasLayer

@export var icon: TextureRect
@export var cursor: TextureRect
@export var track: Control
@export var day_label: Label
@export var time_label: Label

@export_group("Time Textures")
@export var day_textures: Texture2D
@export var evening_textures: Texture2D
@export var night_textures: Texture2D

@export_group("Cursor Textures")
@export var cursor_day_textures: Texture2D
@export var cursor_evening_textures: Texture2D
@export var cursor_night_textures: Texture2D

func _ready() -> void:
	DayAndNightCycleManager.time_tick_hora.connect(on_hora_tick)
	DayAndNightCycleManager.time_tick_day.connect(on_day_tick)
	DayAndNightCycleManager.time_tick.connect(on_time_tick)

func on_day_tick(day: int) -> void:
	day_label.text = tr("день: ") + str(day)

func on_time_tick(day: int, hour: int, minute: int) -> void:
	time_label.text = "%02d:%02d" % [hour, minute]

func on_hora_tick(hour: int) -> void:
	match DayAndNightCycleManager.get_period():
		"day":     
			icon.texture = day_textures
			cursor.texture = cursor_day_textures
		"evening": 
			icon.texture = evening_textures
			cursor.texture = cursor_evening_textures
		"night":   
			icon.texture = night_textures
			cursor.texture = cursor_night_textures
