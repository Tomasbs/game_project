extends Node2D


@export var dwarf_scene: PackedScene = preload("res://Scenes/dwarf.tscn")
@export var enemy_scene: PackedScene = preload("res://Scenes/enemy.tscn")
@export var adventurer_scene: PackedScene = preload("res://Scenes/adventurer.tscn")

var done = false

func _ready() -> void:
	var enemy = enemy_scene.instantiate()
	var enemy2 = enemy_scene.instantiate()
	var enemy3 = enemy_scene.instantiate()
	var enemy4 = enemy_scene.instantiate()
	$"BattleScene/EnemyGroup".add_child(enemy)
	$"BattleScene/EnemyGroup".add_child(enemy2)
	$"BattleScene/EnemyGroup".add_child(enemy3)
	$"BattleScene/EnemyGroup".add_child(enemy4)
	$"BattleScene/EnemyGroup".battle_setup()

func _process(delta: float) -> void:
	if $"BattleScene/Party".get_child_count() == 4 and not done:
		$"BattleScene".character_selection_done()
		done = true 
	

func _on_button_pressed() -> void:
	var adventurer = adventurer_scene.instantiate()
	$"BattleScene/Party".add_child(adventurer)
	$"BattleScene/Party".battle_setup()


func _on_button_2_pressed() -> void:
	var dwarf = dwarf_scene.instantiate()
	$"BattleScene/Party".add_child(dwarf)
	$"BattleScene/Party".battle_setup()


func _on_button_3_pressed() -> void:
	$"BattleScene".character_selection_done()
	done = true
