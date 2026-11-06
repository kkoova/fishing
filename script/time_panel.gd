extends CanvasLayer

@export var time_label: Label
@export var day_label: Label

func _ready() -> void:
	DayAndNightCycleManager.time_tick.connect(on_time_tick)
	DayAndNightCycleManager.time_tick_day.connect(on_day_tick)

func on_day_tick(day: int) -> void:
	day_label.text = tr("День") + " " + str(day)

func on_time_tick(day: int, hour: int, minute: int) -> void:
	time_label.text = "%02d:%02d" % [hour, minute]
