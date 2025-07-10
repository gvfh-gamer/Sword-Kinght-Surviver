extends Node2D

@onready var camera: Camera2D = $camera
@onready var player: Player = $player

const GOBLIN = preload("res://prefabs/enemies/goblin.tscn")


func _ready() -> void:
	player.followCamera(camera)
	

func _input(event: InputEvent) -> void:
	if event.is_action_released("goblin"):
		spaw_goblin()
		

func spaw_goblin()-> void:
	var goblin = GOBLIN.instantiate()
	goblin.position = Vector2(player.position.x + 100, player.position.y + 100)
	add_sibling(goblin)
