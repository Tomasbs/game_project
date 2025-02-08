extends Node2D

var enemies: Array = []


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
		
	
