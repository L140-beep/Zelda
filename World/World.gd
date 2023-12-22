extends Node2D

export var level_name = ""
onready var ui: GameUI = $UI
onready var player: KinematicBody2D = $YSort/Player
var transitionData = TransitionData
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player_pos = transitionData.positions.get(level_name).get(transitionData.last_level)
	player.global_position = Vector2(player_pos.get("x"), player_pos.get("y"))
	transitionData.last_level = level_name
	var state = transitionData.states.get(level_name)
	if state != null:
		var saved_grass = state.get("Grass")
		var grasses = get_tree().get_nodes_in_group("Grass")
		for grass in grasses:
			if grass.name in saved_grass.keys():
				pass
			else:
				print('here')
				grass.queue_free()
				
		var saved_enemies = state.get("Enemies")
		var enemies = get_tree().get_nodes_in_group("Enemies")
		for enemy in enemies:
			if enemy.name in saved_enemies.keys():
				enemy.global_position = saved_enemies[enemy.name]["position"]
			else:
				print('here')
				enemy.queue_free()


func _save_object(objects):
	for obj in objects:
		print(obj.name)
		var childs = obj.get_children()
		_save_object(childs)

func _on_Transition_save_state() -> void:
	print('hereee')
	var bushes = get_tree().get_nodes_in_group("Grass")
	var state: Dictionary = {}
	state["Grass"] = {}
	for bush in bushes:
		# state[level_name] = {}
		state["Grass"][bush.name] = {
			"position": bush.global_position
		}
	
	var enemies = get_tree().get_nodes_in_group("Enemies")
	state["Enemies"] = {}
	for enemy in enemies:
		# state[level_name] = {}
		state["Enemies"][enemy.name] = {
			"position": enemy.global_position
		}
	transitionData.states[level_name] = state
	print(state)
