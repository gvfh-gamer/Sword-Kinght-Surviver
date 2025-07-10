extends Node

var player: Player
var player_position: Vector2
var is_game_over: bool = false
signal game_over

var timer_elapsed: float = 0.0
var timer_elapsed_string: String
var meat_total: int = 0
var score = 0
signal  score_add

func _ready() -> void:
	score_add.emit()

func _process(delta: float) -> void:
	#informa que jogo acabou -> Game Over
	if GameControler.is_game_over: return
	#criando timer
	GameControler.timer_elapsed += delta
	var time_elapse_in_seconds: int = floori(GameControler.timer_elapsed)
	var seconds: int = time_elapse_in_seconds % 60
	@warning_ignore("integer_division") var minutes: int = time_elapse_in_seconds / 60
	timer_elapsed_string = "%02d:%02d" % [minutes, seconds]
	
func end_game():
	if is_game_over: return
	is_game_over = true
	game_over.emit()
	
func reset()-> void:
	player = null
	#player.position = Vector2.ZERO
	is_game_over = false
	timer_elapsed = 0.0
	timer_elapsed_string = ""
	meat_total = 0
	score = 0
	for connection in game_over.get_connections():
		game_over.disconnect(connection.callable)
