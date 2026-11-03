class_name GameTimeManager

signal time_period_changed(new_period: String)
signal time_tick(hour: int, minute: int)

static var day_length_in_seconds: float = 600.0
static var current_time: float = 8.0
static var current_period: String = "morning"

var _last_period: String = ""

func _process(delta: float) -> void:
	var time_step = 24.0 / day_length_in_seconds * delta
	current_time = fmod(current_time + time_step, 24.0)
	
	var hour = int(current_time)
	var minute = int((current_time - hour) * 60)
	time_tick.emit(hour, minute)
	
	_update_period()

func _update_period() -> void:
	var new_period = "day"
	
	if current_time >= 5.0 and current_time < 12.0:
		new_period = "morning"
	elif current_time >= 12.0 and current_time < 18.0:
		new_period = "day"
	elif current_time >= 18.0 and current_time < 22.0:
		new_period = "evening"
	else:
		new_period = "night"
		
	if new_period != _last_period:
		current_period = new_period
		_last_period = new_period
		time_period_changed.emit(current_period)
		print("Время сменилось на: ", current_period)
