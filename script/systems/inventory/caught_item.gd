extends Sprite2D


func setup(fish_texture: Texture2D, start_pos: Vector2):
	texture = fish_texture
	
	# Начальная позиция (смещение вниз, чтобы выпрыгнуть вверх)
	position = start_pos + Vector2(0, 20) 
	scale = Vector2.ZERO
	modulate.a = 0.0
	
	# Красивая анимация выпрыгивания (Tween)
	var tween = create_tween().set_parallel(true)
	
	# Появление
	tween.tween_property(self, "modulate:a", 1.0, 0.3)
	tween.tween_property(self, "scale", Vector2(1, 1), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position:y", start_pos.y, 0.5).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	
	# Подвешивание в воздухе (легкое покачивание)
	tween.chain().tween_callback(func():
		var float_tween = create_tween().set_loops()
		float_tween.tween_property(self, "position:y", start_pos.y - 5, 0.5).set_trans(Tween.TRANS_SINE)
		float_tween.tween_property(self, "position:y", start_pos.y, 0.5).set_trans(Tween.TRANS_SINE)
	)
	
	# Исчезновение через 2 секунды
	await get_tree().create_timer(2.0).timeout
	var hide_tween = create_tween()
	hide_tween.tween_property(self, "modulate:a", 0.0, 0.3)
	hide_tween.tween_callback(queue_free)
