extends CharacterBody2D

@onready var _focus: Sprite2D = $Focus
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var anim_state = animation_tree.get("parameters/playback")
@onready var marker_2d: Marker2D = $Marker2D

@export var MAX_HEALTH: float = 7

var attacking: bool = false
var att_cd: bool = false
var walk_back: bool = false
var current_att: int
var att_focus

var home_x: int 
var home_y: int

enum enemy_states {IDLE, HURT, DEATH, WALK_LEFT, WALK_RIGHT, ATTACK}
var current_states = enemy_states.IDLE

var dead: bool = false

var health: float = 7:
	set(value):
		health = value
		_upadate_progress_bar()
		if dead == false:
			current_states = enemy_states.HURT
			
func _ready():
	pass
		
func _process(delta):
	match current_states:
		enemy_states.IDLE:
			idle()
		enemy_states.HURT:
			hurt()
		enemy_states.DEATH:
			death()
		enemy_states.WALK_LEFT:
			walk_left()
		enemy_states.WALK_RIGHT:
			walk_right()
		enemy_states.ATTACK:
			attack()
	if health <= 0:
		dead = true
		current_states= enemy_states.DEATH
	if attacking:
		if $".".position.x <= att_focus.home_x + 160:
			att_cd = false
			current_states = enemy_states.ATTACK
		else:
			if $".".position.x > att_focus.home_x + 160:
				current_states = enemy_states.WALK_LEFT
				$".".position.x -= 400 * get_physics_process_delta_time()
			if $".".position.y < att_focus.home_y:
				current_states = enemy_states.WALK_LEFT
				$".".position.y += 250 * get_physics_process_delta_time()
			if $".".position.y > att_focus.home_y:
				current_states = enemy_states.WALK_LEFT
				$".".position.y -= 250 * get_physics_process_delta_time()
	if walk_back:
		if $".".position.x >= home_x:
			if current_att + 1 < len($"..".enemies):
				if att_cd == false:
					$"..".enemy_attack_over(current_att + 1)
					att_cd = true
					current_states = enemy_states.IDLE
			elif $"..".enemies[-1].position.x >= $"..".enemies[-1].home_x:
				current_states = enemy_states.IDLE
				for i in range(0, len($"..".enemies)):
					$"..".enemies[i].walk_back = false
				$"..".show_combat_options()
				#$"./Focus".show()
		else:
			if $".".position.x < home_x:
				current_states = enemy_states.WALK_RIGHT
				$".".position.x += 420 * get_physics_process_delta_time()
			if $".".position.y > home_y:
				$".".position.y -= 250 * get_physics_process_delta_time()
			if $".".position.y < home_y:
				$".".position.y += 250 * get_physics_process_delta_time()
			
func attack_begin(curr_att, focus):
	current_att = curr_att
	att_focus = focus
	if dead == false:
		if walk_back == false:
			attacking = true
	else:
		$"..".enemy_attack_over(current_att + 1)
		
func _upadate_progress_bar():
	progress_bar.value = (health/MAX_HEALTH) * 100
	
func damage_dealer():
	att_focus.take_damage(1)
	#$'..'.party_target[current_att].take_damage(1)
	
func attack_over():
	if current_att + 1 == len($"..".enemies):
		$"..".clear_array()
	attacking = false
	walk_back = true

func focus():
	_focus.show()
	
func unfocus():
	_focus.hide()
	
func take_damage(value):
	health -= value
	
func on_states_reset() :
	current_states = enemy_states.IDLE
	
func idle():
	animation_tree.set("parameters/Idle/blend_position", Vector2(0, 0))
	anim_state.travel("Idle")	
	
func hurt():
	animation_tree.set("parameters/Hurt/blend_position", Vector2(0, 0))
	anim_state.travel("Hurt")
	
func death():
	animation_tree.set("parameters/Death/blend_position", Vector2(0, 0))
	anim_state.travel("Death")	

func attack():
	animation_tree.set("parameters/Attack/blend_position", Vector2(0, 0))
	anim_state.travel("Attack")	
	
func walk_right():
	animation_tree.set("parameters/Walk/blend_position", Vector2(1, 0))
	anim_state.travel("Walk")	
	
func walk_left():
	animation_tree.set("parameters/Walk/blend_position", Vector2(-1, 0))
	anim_state.travel("Walk")	
