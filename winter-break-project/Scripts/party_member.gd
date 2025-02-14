extends CharacterBody2D

@onready var _focus: Sprite2D = $Focus
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var anim_state = animation_tree.get("parameters/playback")
@export var MAX_HEALTH: float = 7

enum player_states {IDLE, WALK_RIGHT, WALK_LEFT, ATTACK_1, ATTACK_2, ATTACK_3, HURT, DEATH}
var current_states = player_states.IDLE


signal enemy_turn

var attacking: bool = false
var walk_back: bool = false
var current_att: int
var attack_type: int
var dead = false

var home_x: int 
var home_y: int

var health: float = 7:
	set(value):
		health = value
		_upadate_progress_bar()
		if dead == false:
			current_states = player_states.HURT

func focus():
	_focus.show()
	
func unfocus():
	_focus.hide()
	
func _ready():
	pass
	
func _process(delta):
	match current_states:
		player_states.IDLE:
			idle()
		player_states.WALK_RIGHT:
			walk_right()
		player_states.WALK_LEFT:
			walk_left()
		player_states.ATTACK_1:
			attack_1()
		player_states.ATTACK_2:
			attack_2()
		player_states.ATTACK_3:
			attack_3()
		player_states.HURT:
			hurt()
		player_states.DEATH:
			death()
	if health <= 0:
		dead = true
		current_states = player_states.DEATH
	if attacking:
		if $".".position.x >= $"..".party_target[current_att].position.x - 160:
			if attack_type == 0:
				current_states = player_states.ATTACK_1
			elif attack_type == 1:
				current_states = player_states.ATTACK_2
			elif attack_type == 2:
				current_states = player_states.ATTACK_3
		else:
			if $".".position.x < $"..".party_target[current_att].position.x - 160:
				current_states = player_states.WALK_RIGHT
				$".".position.x += 400 * get_physics_process_delta_time()
			if $".".position.y < $"..".party_target[current_att].position.y:
				current_states = player_states.WALK_RIGHT
				$".".position.y += 250 * get_physics_process_delta_time()
			if $".".position.y > $"..".party_target[current_att].position.y:
				current_states = player_states.WALK_RIGHT
				$".".position.y -= 250 * get_physics_process_delta_time()
	if walk_back:
		if $".".position.x <= home_x:
			if current_att + 1 < len($"..".party_target):
				$"..".party[current_att + 1].attack_begin(current_att + 1, $"..".attack_types[current_att]) 
				current_states = player_states.IDLE
			elif $"..".party[-1].position.x <= $"..".party[-1].home_x:
				current_states = player_states.IDLE
				walk_back = false
				if $"." == $"..".party[-1]:
					emit_signal("enemy_turn")
				$"..".party_attack_over()
				#$"..".show_combat_options()
				#$"./Focus".show()
		else:
			if $".".position.x > home_x:
				current_states = player_states.WALK_LEFT
				$".".position.x -= 420 * get_physics_process_delta_time()
			if $".".position.y > home_y:
				$".".position.y -= 250 * get_physics_process_delta_time()
			if $".".position.y < home_y:
				$".".position.y += 250 * get_physics_process_delta_time()
				
func _upadate_progress_bar():
	progress_bar.value = (health/MAX_HEALTH) * 100
	
func attack_begin(target, type):
	current_att = target
	attack_type = type
	if walk_back == false:
		attacking = true
	
func damage_dealer():
	$'..'.party_target[current_att].take_damage(1)
	
func attack_over():
	if current_att + 1 == len($"..".party_target):
		$"..".party_target.clear()
	attacking = false
	walk_back = true
	
func take_damage(value):
	health -= value
	
func on_states_reset() :
	current_states = player_states.IDLE
	

func idle():
	animation_tree.set("parameters/Idle/blend_position", Vector2(0, 0))
	anim_state.travel("Idle")	
	
func walk_right():
	animation_tree.set("parameters/Walk/blend_position", Vector2(1, 0))
	anim_state.travel("Walk")	
	
func walk_left():
	animation_tree.set("parameters/Walk/blend_position", Vector2(-1, 0))
	anim_state.travel("Walk")	

func attack_1():
	animation_tree.set("parameters/Attack_1/blend_position", Vector2(1, 0))
	anim_state.travel("Attack_1")	
	
func attack_2():
	animation_tree.set("parameters/Attack_2/blend_position", Vector2(1, 0))
	anim_state.travel("Attack_2")	

func attack_3():
	animation_tree.set("parameters/Attack_3/blend_position", Vector2(1, 0))
	anim_state.travel("Attack_3")	
	
func hurt():
	animation_tree.set("parameters/Hurt/blend_position", Vector2(1, 0))
	anim_state.travel("Hurt")	
	
func death():
	animation_tree.set("parameters/Death/blend_position", Vector2(1, 0))
	anim_state.travel("Death")	
