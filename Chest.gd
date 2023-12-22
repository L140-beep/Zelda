extends Node2D
signal opened

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
onready var open: TileMap = $TileMap2
onready var close: TileMap = $TileMap
onready var hurtbox: Area2D = $Hurtbox
var opened = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Hurtbox_area_entered(area: Area2D) -> void:
	if not opened:
		close.visible = false
		open.visible = true
		emit_signal("opened")
