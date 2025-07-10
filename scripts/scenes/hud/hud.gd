extends CanvasLayer

@onready var meat_label: Label = %meat_label
@onready var timer_label: Label = %timer_label
@onready var gold_score: Label = %gold_score

func _ready() -> void:
	update_score()
	GameControler.score_add.connect(update_score)


func _process(_delta: float) -> void:
	timer_label.text = GameControler.timer_elapsed_string
	meat_label.text = str("%01d" %  GameControler.meat_total)

func update_score() -> void:
	gold_score.text = str("%01d" %  GameControler.score)
	
