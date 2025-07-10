extends AnimatedSprite2D

func _animation_finished() -> void:
	await get_tree().create_timer(1).timeout
	queue_free()
