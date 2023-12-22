class_name GameUI extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

onready var heart_container: HBoxContainer = $HBoxContainer
onready var heart = preload("res://UI/Heart.tscn")

var stats = PlayerStats

func set_hearts(n):
	var hearts = heart_container.get_children()
	if n > hearts.size():
		for i in range(0, n - hearts.size()):
			var nheart = heart.instance()
			heart_container.add_child(nheart)
			print(heart_container.get_child_count())
	else:
		var del_heart = hearts.pop_back()
		heart_container.remove_child(del_heart)
		

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stats.connect("hp_changed", self, "set_hearts")
	set_hearts(stats.health)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
