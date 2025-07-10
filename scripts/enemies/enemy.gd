class_name Enemy
extends Node2D


const MARKED_DAMAGE_PREFAB = preload("res://prefabs/itens/damage_enemy.tscn")
const HUD = preload("res://scenes/hud/hud.tscn")
const SKRULL = preload("res://prefabs/effects/skrull_02.tscn")

@onready var collision: CollisionShape2D = $collision
@onready var sprite: AnimatedSprite2D = $sprite

@export_category("Life")
@export var damage_player: int
@export var health: int = 10
@export var score_add: int = 0


@export_category("configurações")
@export var speed: int = 80
var hexa_cor = 0xff0914de
var walk_enemy: bool = true
var suffre_damage: bool = true
var hud

@export_category("Drops")
@export var drop_chance: float = .1
@export var drop_items: Array[PackedScene]
@export var drop_chances: Array[float]

func _ready() -> void:
	hud = HUD.instantiate()

func damage(amount: int) -> void:
	if suffre_damage:
		display_digit_damage(amount)
		suffre_damage = false
		health -= amount
		walk_enemy = false
		#collision.disabled = true
		sprite.play("idle")
		
		# alterar cor por danos
		var cor = hexa_cor
		modulate = Color.hex(cor)
		
		#criar tween para suavizar volta cor
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_BACK)
		tween.set_ease(Tween.EASE_IN)
		tween.tween_property(self, "modulate", Color.WHITE, .8)
		
		# Procssar morte
		if health <= 0:
			set_deferred("collision_layer", false)
			#collision.disabled = true
			placar()
			die()
			
		# aguarda tempo dano
		await get_tree().create_timer(.8).timeout
		walk_enemy = true
		sprite.play("run")
		suffre_damage = true

func die() -> void:
	var skrull = SKRULL.instantiate()
	skrull.position = position
	await get_tree().create_timer(.8).timeout
	add_sibling(skrull)
	
	# Drop
	if randf() <= drop_chance: drop_item()
	#drop_item()
	# Remove o prefab do jogo
	queue_free()
	

func display_digit_damage(amount):
		# damage digit
		var digit = MARKED_DAMAGE_PREFAB.instantiate()
		digit.value = amount
		add_child(digit)
		if $marker_digit:
			digit.position = $marker_digit.position
		else:
			digit.position = position
			

func placar()-> void:
	GameControler.score += score_add
	GameControler.score_add.emit()


func drop_item()-> void:
	var drop = get_ramdom_drop_item().instantiate()
	drop.position = position
	add_sibling(drop)
	

# funçãp que cria porcentagem de cada item
func get_ramdom_drop_item() -> PackedScene:
	# se lista so tiver um item
	if drop_items.size() == 1:
		return drop_items[0]
	
	var max_chance: float = 0.0 
	
	for  _drop_chance in drop_chances:
		max_chance += _drop_chance
	var random_value =  randf_range(0, max_chance)   # randf() #* max_chance
	
	#Gira roleta
	var needle: float = 0
	for i in drop_items.size():
		var _drop_item  = drop_items[i]
		var _drop_chance = drop_chances[i] if i < drop_chances.size()  else  1.0
		if random_value <= _drop_chance + needle:
			return _drop_item
		needle += _drop_chance
		
	return drop_items[0]
		
