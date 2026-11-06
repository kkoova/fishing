class_name DayNightCycleComponent
extends CanvasModulate

@export var initial_day: int = 1:
	set(id):
		initial_day = id
		DayAndNightCycleManager.initial_day = id
		DayAndNightCycleManager.set_initial_time()

@export var initail_hour: int = 6:
	set(ih):
		initail_hour = ih
		DayAndNightCycleManager.initial_hour = ih
		DayAndNightCycleManager.set_initial_time()

@export var initail_minute: int = 0:
	set(im):
		initail_minute = im
		DayAndNightCycleManager.initial_minute = im
		DayAndNightCycleManager.set_initial_time()

@export var day_and_night_gradient_texture: GradientTexture1D

func _ready() -> void:
	DayAndNightCycleManager.initial_day = initial_day
	DayAndNightCycleManager.initial_hour = initail_hour
	DayAndNightCycleManager.initial_minute = initail_minute
	DayAndNightCycleManager.set_initial_time()
	
	DayAndNightCycleManager.game_time.connect(on_game_time)

func on_game_time(time: float) -> void:
	var sample_value = 0.5 * (sin(time - PI * 0.5) + 1.0)
	color = day_and_night_gradient_texture.gradient.sample(sample_value)
	
	update_window_lights(sample_value)

func update_window_lights(sample_value: float) -> void:
	var lights = get_tree().get_nodes_in_group("window_light")
	
	for light in lights:
		if light is ColorRect:
			light.color = Color(1.0, 0.9, 0.6, sample_value * 0.8)
