class_name GameOverHud
extends CanvasLayer

@onready var tempo_label: Label = %tempo_label
@onready var ouro_label: Label = %ouro_label
@onready var monstros_label: Label = %monstros_label
@onready var game_over: GameOverHud = $"."

var tempo_vivo: String
var mostros_abatidos: int
var ouro_obitido: int

var new_game_text: Array = [
	"Clique  no  guerreiro  pra   iniciar nova  partida",
 	"Click on the warrior to start a new game" 
	]
@onready var new_game_label: Label = $new_game_label
var id_text: int = 0
#timer_label.text = "%02d:%02d" % [minutes, seconds] str("%01d" %  GameControler.score)
func _ready() -> void:
	tempo_label.text = GameControler.timer_elapsed_string
	monstros_label.text = str(mostros_abatidos)
	ouro_label.text = str(ouro_obitido)

func _game_over_animation_finished(anim_name: StringName) -> void:
	if anim_name == "default":
		await get_tree().create_timer(2.5).timeout
		$anim_game_over.play("new_game")

func restart_game()-> void:
	get_tree().reload_current_scene()

func change_label_new_game():
	if id_text == 0:
		new_game_label.text = new_game_text[id_text]
		id_text += 1
	else:
		new_game_label.text = new_game_text[id_text]
		id_text = 0
		

func _restart_button() -> void:
	game_over.queue_free()
	GameControler.reset()
	get_tree().reload_current_scene()
