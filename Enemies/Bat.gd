class_name Bat extends KinematicBody2D

export var FRICTION = 200
export var ACCELERATION = 300
export var MAX_SPEED = 50

var knockback = Vector2.ZERO
const DeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var animatedSprite = $AnimatedSprite
onready var hurtbox = $Hurtbox
enum {
	IDLE,
	WANDER,
	CHASE
}

var state = IDLE
var velocity = Vector2.ZERO
func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, delta*FRICTION)
			seek_player()
		WANDER:
			pass
		CHASE:
			chase(delta)
			animatedSprite.flip_h = velocity.x > 0
	velocity = move_and_slide(velocity)
	
func chase(delta : float):
	var player = playerDetectionZone.player
	if player != null:
		var directionToPlayer = (player.global_position - global_position).normalized()
		velocity = velocity.move_toward(directionToPlayer * MAX_SPEED, ACCELERATION * delta)
	else:
		state = IDLE

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	if "knockback_vector" in area:
		knockback = area.knockback_vector * 120
	hurtbox.create_hit_effect()
func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func create_death_effect():
	var deathEffect = DeathEffect.instance()
	deathEffect.position = self.position
	
	get_parent().add_child(deathEffect)

func _on_Stats_death():
	create_death_effect()
	queue_free()
