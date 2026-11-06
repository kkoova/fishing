class_name PlayerVisuals
extends CanvasLayer

@export var bite_indicator: Sprite2D
@export var bite_audio: AudioStreamPlayer

# Вызывается из состояния FishingWait
func show_bite_feedback() -> void:
	# 1. Играем звук
	if bite_audio:
		bite_audio.play()
		
	# 2. Показываем "!" с красивой анимацией (Tween)
	if bite_indicator:
		bite_indicator.visible = true
		bite_indicator.scale = Vector2.ZERO
		bite_indicator.modulate.a = 1.0 # Полностью непрозрачный
		
		# Выпрыгивание (как в комиксах)
		var tween = create_tween()
		tween.tween_property(bite_indicator, "scale", Vector2(1.2, 1.2), 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.tween_property(bite_indicator, "scale", Vector2(1.0, 1.0), 0.1)

func hide_bite_feedback() -> void:
	if bite_indicator:
		bite_indicator.visible = false
