extends Node2D
var action_queue: Array = []
var is_battling: bool = false
var index: int = 0
var curr_att: int = 0
var attack_focus: int
var enemy_focus: Array = []
var party_dead: bool = false
var character_selection = true

@onready var adventurer_scene : PackedScene = preload("res://Scenes/adventurer.tscn")
@onready var dwarf_scene : PackedScene = preload("res://Scenes/dwarf.tscn")
@onready var guard_scene : PackedScene = preload("res://Scenes/enemy.tscn")

signal next_player

func _ready():
	pass
	#show_combat_options()
	
func _process(_delta):
	if not character_selection:
		if not $CanvasLayer/combat_options.visible and not is_battling and not $CanvasLayer/attack_options.visible:
			if Input.is_action_just_pressed("up"):
				if index >= 0:
					index -= 1
					if index < 0:
						index = $EnemyGroup.enemies.size() - 1
						switch_focus(index, 0)
					else:
						switch_focus(index, index + 1)
				#if $EnemyGroup.enemies[index].dead == true:
				#index -= 1
			if Input.is_action_just_pressed("down"):
				if index <= $EnemyGroup.enemies.size() - 1:
					index += 1
					if index > $EnemyGroup.enemies.size() - 1:
						index = 0
					#if $EnemyGroup.enemies[index].dead == true:
						#index += 1
					switch_focus(index, index - 1)
			if Input.is_action_just_pressed("accept"):
				if len($"Party".party_target) != len($"Party".party):
					curr_att += 1
					$"Party".party_target.push_back($EnemyGroup.enemies[index])	
				action_queue.push_back(index)
				emit_signal("next_player")
	if not character_selection:
		if action_queue.size() == $"Party".party.size() and not is_battling:
			is_battling = true
			#$"../Party/Player/Focus".hide()
			$"Party".party[0]._focus.hide()
			_action(action_queue)
		
func _action(stack):
	$EnemyGroup.enemies[index].unfocus()
	#for i in stack:
	#	enemies[i].take_damage(1)
	#	await get_tree().create_timer(1.5).timeout
	action_queue.clear()
	is_battling = false
	#$"../Party/Player/Focus".show()
	#show_choice()			
	
func _reset_focus():
	index = 0
	for enemy in $EnemyGroup.enemies:
		enemy.unfocus()

func _start_choosing():
	_reset_focus()
	for i in range(0, $EnemyGroup.enemies.size()):
		if $EnemyGroup.enemies[i].dead == false:
			index = i
			$"EnemyGroup".enemies[i]._focus.show()
			break
	#$EnemyGroup.enemies[0].focus()

func _continue_choosing():
	_reset_focus()
	for i in range(0, $EnemyGroup.enemies.size()):
		if $EnemyGroup.enemies[i].dead == false:
			index = i
			$"EnemyGroup".enemies[i]._focus.show()
			break
	#$EnemyGroup.enemies[0].focus()
	
func _on_attack_pressed():
	if $Party.party[0].dead == true:
		dead_man_turn()
		$CanvasLayer/combat_options.hide()
		return
	for i in range(0, $Party.party.size()):
		if $Party.party[i].dead == false:
			$"Party".party[i]._focus.show()
			break
	$CanvasLayer/combat_options.hide()
	show_attack_options()
			
func switch_focus(x, y):
	$EnemyGroup.enemies[x].focus()
	$EnemyGroup.enemies[y].unfocus()
	
func show_combat_options():
	for i in range(0, $Party.party.size()):
		if $Party.party[i].dead == false:
			break
		if i == $Party.party.size() - 1:
			party_dead = true
	if party_dead == false:
		$CanvasLayer/combat_options.show()
		$CanvasLayer/combat_options.find_child("Attack").grab_focus()
	
func show_attack_options():
	if $Party.party[curr_att].dead == true:
		dead_man_turn()
		$CanvasLayer/combat_options.hide()
		return
	_reset_focus()
	$CanvasLayer/attack_options.show()
	$CanvasLayer/attack_options/Attack1.hide()
	$CanvasLayer/attack_options/Attack2.hide()
	$CanvasLayer/attack_options/Attack3.hide()
	$CanvasLayer/attack_options/Attack4.hide()
	if len($"Party".party[curr_att].attacks) >= 1:
		$CanvasLayer/attack_options/Attack1.show()
		$CanvasLayer/attack_options/Attack1.text = $"Party".party[curr_att].attacks[0]
	if len($"Party".party[curr_att].attacks) >= 2:
		$CanvasLayer/attack_options/Attack2.show()
		$CanvasLayer/attack_options/Attack2.text = $"Party".party[curr_att].attacks[1]
	if len($"Party".party[curr_att].attacks) >= 3:
		$CanvasLayer/attack_options/Attack3.show()
		$CanvasLayer/attack_options/Attack3.text = $"Party".party[curr_att].attacks[2]
	if len($"Party".party[curr_att].attacks) >=4 :
		$CanvasLayer/attack_options/Attack4.show()
		$CanvasLayer/attack_options/Attack4.text = $"Party".party[curr_att].attacks[3]
	$CanvasLayer/attack_options.find_child("Attack1").grab_focus()

func _on_attack_1_pressed() -> void:
	$Party.attack_types.append(0)
	$CanvasLayer/attack_options.hide()
	if curr_att == 0:
		_start_choosing()
	else:
		_continue_choosing()

func _on_attack_2_pressed() -> void:
	$Party.attack_types.append(1)
	$CanvasLayer/attack_options.hide()
	if curr_att == 0:
		_start_choosing()
	else:
		_continue_choosing()

func _on_attack_3_pressed() -> void:
	$Party.attack_types.append(2)
	$CanvasLayer/attack_options.hide()
	if curr_att == 0:
		_start_choosing()
	else:
		_continue_choosing()

func _on_party_starting_enemies():
	for i in len($"EnemyGroup".enemies):
		#enemy_focus.append(randi() % len($"Party".party))
		enemy_focus.append(2)
	$"EnemyGroup".enemies[0].attack_begin(0, $"Party".party[enemy_focus[0]])

func after_enemies_attack(current_att):
	$"EnemyGroup".enemies[current_att].attack_begin(current_att, $"Party".party[enemy_focus[current_att]])
	
func dead_man_turn():
	$Party.party_target.append(0)
	$Party.attack_types.append(0)
	curr_att += 1
	if curr_att <= len($Party.party) - 1:
		emit_signal("next_player")
		show_attack_options()
	else:
		pass
		#print($Party.index)
		#$Party.index = 0
		#print($Party.index)
		
func _on_adventurer_pressed():
	if $Party.party.size() == 0:
		$CanvasLayer/party_options/Finish_party.show()
	var adventurer_temp = adventurer_scene.instantiate()
	$Party.add_child(adventurer_temp)
	$Party.party.append(adventurer_temp)
	if $Party.party.size() == 4:
		$CanvasLayer/party_options.hide()
		$CanvasLayer/enemy_options.show()


func _on_dwarf_pressed():
	if $Party.party.size() == 0:
		$CanvasLayer/party_options/Finish_party.show()
	var dwarf_temp = dwarf_scene.instantiate()
	$Party.add_child(dwarf_temp)
	$Party.party.append(dwarf_temp)
	if $Party.party.size() == 4:
		$CanvasLayer/party_options.hide()
		$CanvasLayer/enemy_options.show()


func _on_finish_party_pressed():
	$CanvasLayer/party_options.hide()
	$CanvasLayer/enemy_options.show()


func _on_guard_pressed():
	if $EnemyGroup.enemies.size() == 0:
		$CanvasLayer/enemy_options/Finish_enemy.show()
	var guard_temp = guard_scene.instantiate()
	$EnemyGroup.add_child(guard_temp)
	$EnemyGroup.enemies.append(guard_temp)
	if $EnemyGroup.enemies.size() == 4:
		$CanvasLayer/enemy_options.hide()
		$Party.character_placement()
		$EnemyGroup.character_placement()
		show_combat_options()
		character_selection = false


func _on_finish_enemy_pressed():
	$CanvasLayer/enemy_options.hide()
	$Party.character_placement()
	$EnemyGroup.character_placement()
	show_combat_options()
	character_selection = false
