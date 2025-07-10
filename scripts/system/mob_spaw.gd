class_name MobSpawn
extends Node2D

@export var enemies: Array[PackedScene]
@export var mobs_per_seconds: float = 1.0
var mobs_per_minute: float = 30.0
@export var time_wait: float = 20

@onready var path_follow_2d: PathFollow2D = %PathFollow2D
@onready var timer: Timer = $Timer

var colldown: float = 0.0


func _process(delta: float) -> void:
	#informa que jogo acabou -> Game Over
	if GameControler.is_game_over: return
	
	spawn_enemies(delta)

func get_point() -> Vector2:
	path_follow_2d.progress_ratio = randf()
	return path_follow_2d.global_position
	

# função usando colldown
func spawn_enemies(delta) -> void:
	# timer
	colldown -= delta
	if colldown > 0: return
	
	# Frequencia
	var iterval = 60.0 / mobs_per_minute
	colldown = iterval
	
	var turn_enemy : int
	var i =  randi_range(0,100)
	if i < 50:
		turn_enemy = 0
	elif i < 80:
		turn_enemy = 1
	else:
		turn_enemy = 2
		
		# checa se ponto de instancia é valido
	var  point = get_point()
	var world_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = point
	var result: Array = world_state.intersect_point(parameters,1)
	#if not result.is_empty(): return
	# Instancia o inimigo selecionado
	if result.is_empty():
		var spaw_enemy = enemies[turn_enemy].instantiate()
		spaw_enemy.global_position = point
		get_parent().call_deferred("add_sibling", spaw_enemy)
		
	

# Função usando signal timer
func spawn_enemies_timer() -> void:
	
	# escolhe o inimigo
	var turn_enemy : int
	var i =  randi_range(0,100)
	if i <= 50:
		turn_enemy = 0
	elif i <= 80 and i > 50:
		turn_enemy = 1
	else:
		turn_enemy = 2
		
	# checa se ponto de instancia é valido
	var  point = get_point()
	var world_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = point
	var result: Array = world_state.intersect_point(parameters,1)
	
	
	if result.is_empty():
		# Instancia o inimigo selecionado
		var spaw_enemy = enemies[turn_enemy].instantiate()
		get_parent().call_deferred("add_sibling", spaw_enemy)
		spaw_enemy.global_position = point
	
	# liga o timer para instanciar novo inimigo
	timer.start()
	

func _on_timer_timeout() -> void:
	timer.wait_time = mobs_per_seconds
	spawn_enemies_timer()
