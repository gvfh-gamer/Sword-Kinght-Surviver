extends Node2D

var player: Player
@export var regenerator:int  = 1

func _meat_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		if player.health < player.max_health:
			player.heal(regenerator)
			player.meat_collect.emit()
			queue_free()
