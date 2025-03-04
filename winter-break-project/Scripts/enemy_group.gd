extends Node2D

@onready var combat_options: HBoxContainer = $"../CanvasLayer/combat_options"

var enemies: Array = []


func _ready():
	enemies = get_children()
	if enemies.size() == 1:
		enemies[0].position = $"../Spawn Point/1 Enemy".position
		enemies[0].MAX_HEALTH = 13
		enemies[0].health = 13
	elif enemies.size() == 2:
		enemies[0].position = $"../Spawn Point/2 Enemies 1".position
		enemies[1].position = $"../Spawn Point/2 Enemies 2".position
		for i in range(0, enemies.size()):
			enemies[i].MAX_HEALTH = 10
			enemies[i].health = 10
	elif enemies.size() == 3:
		enemies[0].position = $"../Spawn Point/3 Enemies 1".position
		enemies[1].position = $"../Spawn Point/3 Enemies 2".position
		enemies[2].position = $"../Spawn Point/3 Enemies 3".position
		for i in range(0, enemies.size()):
			enemies[i].MAX_HEALTH = 8
			enemies[i].health = 10
	elif enemies.size() == 4:		
		enemies[0].position = $"../Spawn Point/4 Enemies 1".position
		enemies[1].position = $"../Spawn Point/4 Enemies 2".position
		enemies[2].position = $"../Spawn Point/4 Enemies 3".position
		enemies[3].position = $"../Spawn Point/4 Enemies 4".position
		for i in range(0, enemies.size()):
			enemies[i].MAX_HEALTH = 6
			enemies[i].health = 6
	
	for i in range(len(enemies)):
		enemies[i].home_x = enemies[i].position.x
		enemies[i].home_y = enemies[i].position.y
		
func enemy_attack_over(current_att):
	$"..".after_enemies_attack(current_att)

func show_combat_options():
	combat_options.show()
	combat_options.find_child("Attack").grab_focus()

func clear_array():
	$"..".enemy_focus.clear()

		
	
