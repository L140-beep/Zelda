extends Node

signal death
signal hp_changed(n)
export var max_health = 1
onready var health = max_health setget set_health

func set_health(value):
	health = value
	if health <= 0:
		emit_signal("death")
	emit_signal("hp_changed", health)
