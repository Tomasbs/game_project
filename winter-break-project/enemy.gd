extends CharacterBody2D

@onready var _focus: Sprite2D = $Focus
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var anim_state = animation_tree.get("parameters/playback")
@onready var marker_2d: Marker2D = $Marker2D

@export var MAX_HEALTH: float = 7

enum enemy_states {IDLE, HURT, DEATH}
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
	if health <= 0:
		dead = true
		current_states= enemy_states.DEATH
			
	
		
func _upadate_progress_bar():
	progress_bar.value = (health/MAX_HEALTH) * 100

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
