extends Node2D

@onready var camera: Camera2D = $camera
@onready var player: Player = $player

@export var game_hud: CanvasLayer
@export var game_over_hud: PackedScene


func _ready() -> void:
	player.followCamera(camera)
	GameControler.game_over.connect(trigger_game_over)
	


func trigger_game_over()-> void:
	if game_hud:
		game_hud.queue_free()
		game_hud = null
		
		var game_over: GameOverHud = game_over_hud.instantiate()
		game_over.tempo_vivo = str(GameControler.timer_elapsed)
		game_over.mostros_abatidos = GameControler.score
		game_over.ouro_obitido = GameControler.meat_total
		add_sibling(game_over)


#func _physics_process(_delta: float) -> void:
	#if !player:
		#await get_tree().create_timer(3).timeout
		#get_tree().paused = true
