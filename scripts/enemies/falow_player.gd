extends Node

var player_position: Vector2
var enemy: Enemy
var sprite: AnimatedSprite2D

@onready var input_vector

func _ready() -> void:
	enemy = get_parent()
	sprite = enemy.get_node("sprite")
	

func _physics_process(delta: float) -> void:
	#informa que jogo acabou -> Game Over
	if GameControler.is_game_over: return
	
	player_position = GameControler.player_position
	var diference_position = player_position - enemy.position
	input_vector = diference_position.normalized()
	enemy.velocity = input_vector *(enemy.speed * 100) * delta
	
	flip()
	
	if enemy.walk_enemy:
		enemy.move_and_slide()

func flip() -> void:
	# Flip do player
	if input_vector.x > 0:
		sprite.flip_h = false
	elif input_vector.x < 0:
		sprite.flip_h = true
