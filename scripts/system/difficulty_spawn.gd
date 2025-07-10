extends Node

@export var mob_spawn: MobSpawn
@export var initial_spawn_rate: float = 60
@export var spawn_rate_minuts: float = 10
@export var wave_duration: float = 10
@export var break_intensity: float = .30


var time: float = 0

#func _process(delta: float) -> void:
	#informa que jogo acabou -> Game Over
	#if GameControler.is_game_over: return
	#time += delta
	#
	## Dificuldade linear - continua$Timer
	#var spawn_rate = initial_spawn_rate + spawn_rate_minuts * (time / 60)
	#
	## Sistema de ondas - sinusal
	#var sin_wave = sin((time * TAU) / wave_duration)
	#var wave_factor = remap(sin_wave, -1, 0, break_intensity, 1)
	#spawn_rate *= wave_factor
	#
	## Aplica a dificuldade variavel
	#mob_spawn.mobs_per_minute = spawn_rate

func _process(delta: float) -> void:
	time += delta


func _timer_timeout() -> void:
	#informa que jogo acabou -> Game Over
	if GameControler.is_game_over: return
	
	# Dificuldade linear - continua
	var spawn_rate = initial_spawn_rate + spawn_rate_minuts * (time / 60)
	
	# Sistema de ondas - sinusal
	var sin_wave = sin((time * TAU) / wave_duration)
	var wave_factor = remap(sin_wave, -1, 1, break_intensity, 1)
	spawn_rate *= wave_factor
	
	# Aplica a dificuldade variavel
	mob_spawn.mobs_per_minute = spawn_rate
