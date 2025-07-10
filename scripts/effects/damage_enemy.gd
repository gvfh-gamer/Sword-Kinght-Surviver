extends Node2D

@onready var label: Label = $label_anim/Label
var value: int = 0


func _ready() -> void:
	label.text = str(value)
