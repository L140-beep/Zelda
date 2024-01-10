extends Area2D

signal invincibility_started
signal invincibility_ended

const HitEffect = preload("res://Effects/HitEffect.tscn")
onready var timer = $Timer

var invincible = false setget set_invincible

func set_invincible(value : bool):
	invincible = value
	if value:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")

func start_invicible(duration):
	self.invincible = true
	timer.start(duration)

func create_hit_effect():
	var hitEffect = HitEffect.instance()
	hitEffect.global_position = self.global_position
	var main = get_tree().current_scene
	main.add_child(hitEffect)


func _on_Timer_timeout() -> void:
	self.invincible = false

func _on_Hurtbox_invincibility_ended() -> void:
	set_deferred("monitorable", true)

func _on_Hurtbox_invincibility_started() -> void:
	set_deferred("monitorable", false)
