extends Node2D

@onready var combat_options: HBoxContainer = $"../CanvasLayer/combat_options"

var party: Array = []
var index: int = 0
var party_target = []
var attack_types: Array = []

signal starting_enemies

func _ready():
	pass
	#party = get_children()
	#party[0].focus()
	
func character_placement():
	if party.size() == 1:
		party[0].position = $"../Spawn Point/1 Party Member".position
	elif party.size() == 2:
		party[0].position = $"../Spawn Point/2 Party Member 1".position
		party[1].position = $"../Spawn Point/2 Party Member 2".position
	elif party.size() == 3:
		party[0].position = $"../Spawn Point/3 Party Member 1".position
		party[1].position = $"../Spawn Point/3 Party Member 2".position
		party[2].position = $"../Spawn Point/3 Party Member 3".position
	elif party.size() == 4:		
		party[0].position = $"../Spawn Point/4 Party Member 1".position
		party[1].position = $"../Spawn Point/4 Party Member 2".position
		party[2].position = $"../Spawn Point/4 Party Member 3".position
		party[3].position = $"../Spawn Point/4 Party Member 4".position
		
	for i in range(len(party)):
		party[i].home_x = party[i].position.x
		party[i].home_y = party[i].position.y
	
func _process(delta):
	if not $"..".character_selection:
		if len(party_target) == len(party):
			index = 0
			#for target in len(party):
			#$"../EnemyGroup".enemies[-1].unfocus()
			for i in range(0, len(party)):
				party[i].unfocus()
			for i in range(0, len($"../EnemyGroup".enemies)):
				if party_target[-1] is not int:
					$"../EnemyGroup".enemies[i].unfocus()
				else:
					party_target[-2].unfocus()
			party[0].attack_begin(0, attack_types[0]) 

func _on_battle_scene_next_player() -> void:
	if index < party.size() - 1:
		$"..".show_attack_options()
		index += 1
		switch_focus(index, index - 1)
	else:
		#index = 0
		switch_focus(index, party.size() -1)
	

func switch_focus(x, y):
	party[x].focus()
	party[y].unfocus()
	
func party_attack_over():
	attack_types.clear()
	$"..".curr_att = 0
	#combat_options.show()
	#combat_options.find_child("Attack").grab_focus()	

func _on_adventurer_enemy_turn():
	emit_signal("starting_enemies")

func _on_dwarf_enemy_turn():
	emit_signal("starting_enemies")
