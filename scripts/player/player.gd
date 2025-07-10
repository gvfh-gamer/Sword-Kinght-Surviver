class_name Player
extends CharacterBody2D

@onready var remoteCamera: RemoteTransform2D = $remoteCamera

@onready var anin_hit: AnimationPlayer = $anin_hit
@onready var anim_knight: AnimationPlayer = $anim_knight
@onready var damage_sword_area: Area2D = $damage_sword_area
@onready var damage_area_enemy: Area2D = $damage_area_enemy
@onready var special_timer: Timer = $special_timer
@onready var healt_progress_bar: ProgressBar = $healt_progress_bar

const HUD = preload("res://scenes/hud/hud.tscn")
var input_vector: Vector2

@export_category("Movement")
@export var speed: float = 3
@export var smoothing: float = .05
@export_category("Damage")
@export var sword_damage: int = 2
@export_category("Life")
@export var health: int = 100
@export var max_health: int = 120
@export_category("Prefabs")
@export var death_prefab: PackedScene
@export_category("Special")
@export var special_damage: int = 1
@export var timer: int = 30
@export var special_prefab: PackedScene

@export_category("Hiting")
var was_running: bool
var running: bool = false
@export var hiting: bool = false
var is_attacking: bool = false
var attack_vez = 1
var hexa_cor = 0x006b16f1
var damage_enemy_cooldown: float = 0
var special_cooldwan: float = 0
var knock_back_vector:= Vector2.ZERO

signal meat_collect()

func _ready() -> void:
	update_bar()
	GameControler.player = self
	meat_collect.connect(func (): GameControler.meat_total += 1)


func _process(delta: float) -> void:
	GameControler.player_position = position
	read_input()
	
	if !is_attacking:
		flip()
	play_animation()
	
	update_damage_enemy(delta)
	
	#update_special(delta)
	

func _physics_process(delta: float) -> void:
	# Modificar a velocidade e mover o player
	var player_velocity = input_vector * (speed * 100) * delta
	if is_attacking:
		player_velocity *= 0.1
	velocity = lerp(velocity, player_velocity, smoothing)
	
	# Move o player
	if knock_back_vector != Vector2.ZERO:
		velocity = knock_back_vector
	move_and_slide()

func read_input()-> void:
	# Obter input vector
	input_vector = Input.get_vector("left", "right", "up", "down")
	
	#Apagar deadzone do input_vector
	var deadzone = 0.15
	if abs(input_vector.x) < deadzone:
		input_vector.x = 0.0
	if abs(input_vector.y) < deadzone:
		input_vector.y = 0.0
	

func flip() -> void:
	damage_sword_area.rotation = 0
	damage_sword_area.position.y =  -35
	# Flip do player
	if input_vector.x > 0:
		$sprite.flip_h = false
		damage_sword_area.position.x = 60
	elif input_vector.x < 0:
		$sprite.flip_h = true
		damage_sword_area.position.x = -60
		

func play_animation()-> void:
	# Muda o running
	was_running = running
	running = not input_vector.is_zero_approx()
	
	# Troca a animação
	if was_running != running and !is_attacking:
		if running:
			anim_knight.play("run")
		else:
			anim_knight.play("idle")
	



func colision_attack_side() -> void:
	if $sprite.flip_h == true:
		damage_sword_area.position.x = -60
	else:
		damage_sword_area.position.x = 60

func apply_enemy_damage():
	var bodies = damage_sword_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemy"):
			body.damage(sword_damage)
	

func update_damage_enemy(delta: float) -> void:
	# Temporizador
	# Diminui o valor de delta da variavel
	damage_enemy_cooldown -= delta
	#  testa para ver se a variavel é maior que zero 
	if damage_enemy_cooldown > 0:
		# Enquanto valor maior que zero não alica dano no player
		return
	# cria o timer com o valor em segundos
	damage_enemy_cooldown = 1
	
	var bodies = damage_area_enemy.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemy") and !hiting:
			hiting = true
			var enemy: Enemy = body
			damage(enemy.damage_player)
	# criar knok down
			if body.position.x < position.x:
				recebeu_dano(Vector2(150,-50))
			else:
				recebeu_dano(Vector2(-150,-50))
		

func damage(amount: int) -> void:
	if health <= 0: return
	health -= amount
	
	# Usando animatiom player para aterar cor
	anin_hit.play("hit")
	
	##criar tween para suavizar volta cor
	#var tween = create_tween()
	#tween.set_trans(Tween.TRANS_BACK)
	#tween.set_ease(Tween.EASE_IN)
	#tween.tween_property(self, "modulate", Color.WHITE, .5)
	
	update_bar()
		#Procssar morte
	if health <= 0: die()
	

func update_bar()-> void:
	# Atualizar barra progresso
	healt_progress_bar.max_value = max_health
	healt_progress_bar.value = health


#criar knok back
func recebeu_dano(knobackForce := Vector2.ZERO, duration:= 1):
	#position = Vector2(position.x - knok, position.y)
	if knobackForce != Vector2.ZERO:
		knock_back_vector = knobackForce
		var knockBackTween := create_tween().set_trans(Tween.TRANS_SPRING)
		knockBackTween.parallel().tween_property(self, "knock_back_vector", Vector2.ZERO, duration)

func die() -> void:
	GameControler.end_game()
	var die_player = death_prefab.instantiate()
	die_player.position = position
	add_sibling(die_player)
	queue_free()
	

# função que determina o tipo do ataque 
# coloca nome no event - não do curso
func _unhandled_input(event):
	var action = what_action_is_event(event)
	if action != null:
		attack(action)

func what_action_is_event(event):
	for action in InputMap.get_actions():
		if event.is_action_pressed(action):
			return action
	return null
	

func attack(action)-> void:
	var attack_name
	match action:
		"fire":
			attack_name = "attack_side_"
			colision_attack_side()
		"button_t":
			attack_name = "attack_up_"
		"button_x":
			attack_name = "attack_down_"
		"button_q" , "button_c":
			attack_name = "attack_side_"
			colision_attack_side()
		_:
			return
			
	# Checa se o player esta atacando impedindo de atacar 2X
	if is_attacking: return
		
	# atualiza a variavel para atacando
	is_attacking = true
	
	# cria as variaveis para diferentes ataques
	var tipo_attack = attack_name + str(attack_vez)
	anim_knight.play(tipo_attack)
	if attack_vez >= 2:
		attack_vez = 1
	else:
		attack_vez = 2
		
	# Conclui a função deixando o player pronto para atacar novamente
	await anim_knight.animation_finished
	anim_knight.play("idle")
	running = false
	is_attacking = false

# Função para recuperar vida(heal)
func heal(amount: int) -> int:
	health += amount
	if health > max_health:
		health = max_health
	update_bar()
	return health

# funções disparo special
# usando coldown
func update_special(delta: float)-> void:
	special_cooldwan -= delta
	if special_cooldwan > 0: return
	
	special_cooldwan = timer
	
	var special = special_prefab.instantiate()
	special.special_damage = special_damage
	add_child(special)


# usando timer do godot
func _on_special_timeout() -> void:
	var special = special_prefab.instantiate()
	special.special_damage = special_damage
	add_child(special)
	
	special_timer.start(timer)

# Funççao que coloca a camera para seguir o player
func followCamera(camera):
	var cameraPath = camera.get_path()
	remoteCamera.remote_path = cameraPath
