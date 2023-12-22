class_name Transition extends Area2D

signal save_state

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

export var locate: PackedScene
export var current_scene_name = ""
export var path_to_next_scene = ""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_Transition_body_entered(body: Node) -> void:
	emit_signal("save_state")
	get_tree().change_scene(path_to_next_scene)
