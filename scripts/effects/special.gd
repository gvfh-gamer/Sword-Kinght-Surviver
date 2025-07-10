extends Node2D

@export var special_damage: int = 5
@onready var area_dano: Area2D = $area_dano

# função dano com função criada no codigo - não usando mas funcional
func deal_damage():
	var bodies = area_dano.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemy"):
			var enemy: Enemy = body
			enemy.damage(special_damage)


func _on_special_finished(_anim_name: StringName) -> void:
	queue_free()

# função dano com o signal padrão do godot - usando essa
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		var enemy: Enemy = body
		enemy.damage(special_damage)
		
