extends CharacterBody2D

@onready var _focus: Sprite2D = $Focus
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var anim_state = animation_tree.get("parameters/playback")

enum player_states {IDLE, WALK_RIGHT, WALK_LEFT, ATTACK}
var current_states = player_states.IDLE

var attacking: bool = false
var walk_back: bool = false
var current_att: int

var home_x: int 
var home_y: int

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
		player_states.ATTACK:
			attack()
	if attacking:
		if $".".position.x >= $"..".party_target[current_att].position.x - 160:
				current_states = player_states.ATTACK
		else:
			if $".".position.x < $"..".party_target[current_att].position.x - 160:
				current_states = player_states.WALK_RIGHT
				print($".".position.x)
				$".".position.x += 400 * get_physics_process_delta_time()
			if $".".position.y < $"..".party_target[current_att].position.y:
				current_states = player_states.WALK_RIGHT
				$".".position.y += 250 * get_physics_process_delta_time()
			if $".".position.y > $"..".party_target[current_att].position.y:
				current_states = player_states.WALK_RIGHT
				$".".position.y -= 250 * get_physics_process_delta_time()
	if walk_back:
		if $".".position.x <= home_x:
			print($".")
			if current_att + 1 < len($"..".party_target):
				$"..".party[current_att + 1].attack_begin(current_att + 1) 
				current_states = player_states.IDLE
			else:
				current_states = player_states.IDLE
				walk_back = false
				$"..".show_choice()
				#$"./Focus".show()
		else:
			if $".".position.x > home_x:
				print($".".position.x)
				current_states = player_states.WALK_LEFT
				$".".position.x -= 420 * get_physics_process_delta_time()
			if $".".position.y > home_y:
				$".".position.y -= 250 * get_physics_process_delta_time()
			if $".".position.y < home_y:
				$".".position.y += 250 * get_physics_process_delta_time()
	
func attack_begin(target):
	current_att = target
	if walk_back == false:
		attacking = true
	
func damage_dealer():
	$'..'.party_target[current_att].take_damage(1)
	
func attack_over():
	if current_att + 1 == len($"..".party_target):
		$"..".party_target.clear()
	attacking = false
	walk_back = true
	

func idle():
	animation_tree.set("parameters/Idle/blend_position", Vector2(0, 0))
	anim_state.travel("Idle")	
	
func walk_right():
	animation_tree.set("parameters/Walk/blend_position", Vector2(1, 0))
	anim_state.travel("Walk")	
	
func walk_left():
	animation_tree.set("parameters/Walk/blend_position", Vector2(-1, 0))
	anim_state.travel("Walk")	

func attack():
	animation_tree.set("parameters/Attack/blend_position", Vector2(1, 0))
	anim_state.travel("Attack")	
