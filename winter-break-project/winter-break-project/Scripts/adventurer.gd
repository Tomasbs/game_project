extends "res://Scripts/party_member.gd"
@onready var attack_options = $CanvasLayer/attack_options

var attacks: Array = ["attack1"]

func show_attack_options():
	attack_options.show()
	attack_options.find_child("Attack1").hide()
	attack_options.find_child("Attack2").hide()
	attack_options.find_child("Attack3").hide()
	attack_options.find_child("Attack4").hide()
	if len(attacks) >= 1:
		attack_options.find_child("Attack1").show()	
	if len(attacks) >= 2:
		attack_options.find_child("Attack2").show()
	if len(attacks) >= 3:
		attack_options.find_child("Attack3").show()
	if len(attacks) >= 4:
		attack_options.find_child("Attack4").show()
		
	
	
	
