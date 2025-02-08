extends Node2D

var enemies: Array = []
var action_queue: Array = []
var is_battling: bool = false
var index: int = 0

signal next_player
@onready var combat_options: HBoxContainer = $"../CanvasLayer/combat_options"

func _ready():
	enemies = get_children()
	if enemies.size() == 1:
		enemies[0].position = $"../Spawn Point/1 Enemy".position
	elif enemies.size() == 2:
		enemies[0].position = $"../Spawn Point/2 Enemies 1".position
		enemies[1].position = $"../Spawn Point/2 Enemies 2".position
	elif enemies.size() == 3:
		enemies[0].position = $"../Spawn Point/3 Enemies 1".position
		enemies[1].position = $"../Spawn Point/3 Enemies 2".position
		enemies[2].position = $"../Spawn Point/3 Enemies 3".position
	elif enemies.size() == 4:		
		enemies[0].position = $"../Spawn Point/4 Enemies 1".position
		enemies[1].position = $"../Spawn Point/4 Enemies 2".position
		enemies[2].position = $"../Spawn Point/4 Enemies 3".position
		enemies[3].position = $"../Spawn Point/4 Enemies 4".position
		
	show_combat_options()
		

func _process(_delta):
	if not combat_options.visible and not is_battling:
		if Input.is_action_just_pressed("up"):
			if index > 0:
				index -= 1
				switch_focus(index, index + 1)
		if Input.is_action_just_pressed("down"):
			if index < enemies.size() - 1:
				index += 1
				switch_focus(index, index - 1)
		if Input.is_action_just_pressed("accept"):
			if len($"../Party".party_target) != len($"../Party".party):
				$"../Party".party_target.push_back(enemies[index])	
			action_queue.push_back(index)
			emit_signal("next_player")
		
	if action_queue.size() == $"../Party".party.size() and not is_battling:
		is_battling = true
		#$"../Party/Player/Focus".hide()
		$"../Party".party[0]._focus.hide()
		_action(action_queue)
		
func _action(stack):
	enemies[index].unfocus()
	#for i in stack:
	#	enemies[i].take_damage(1)
	#	await get_tree().create_timer(1.5).timeout
	action_queue.clear()
	is_battling = false
	#$"../Party/Player/Focus".show()
	#show_choice()
		
			
func switch_focus(x, y):
	enemies[x].focus()
	enemies[y].unfocus()
	
func show_combat_options():
	combat_options.show()
	combat_options.find_child("Attack").grab_focus()
	
func _reset_focus():
	index = 0
	for enemy in enemies:
		enemy.unfocus()

func _start_choosing():
	_reset_focus()
	$"../Party".party[0]._focus.show()
	enemies[0].focus()
	
func _on_attack_pressed():
	combat_options.hide()
	$"../Party".party[0].show_attack_options()
	#_start_choosing()
