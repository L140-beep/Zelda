class_name Player extends KinematicBody2D

export var MAX_SPEED = 70
export var ACCELERATION = 500
export var FRICTION = 500
export var ROLL_SPEED = 125
enum {
	MOVE,
	ROLL,
	ATTACK
}
var state = MOVE

var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN

var stats = PlayerStats
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var hitboxShape = $HitboxPivot/SwordHitbox/CollisionShape2D
onready var hitboxPivot = $HitboxPivot
onready var hitboxSword = $HitboxPivot/SwordHitbox
onready var hurtbox = $Hurtbox

var enemy_in = false

func _ready():
	stats.connect("death", self, "queue_free")
	animationTree.active = true
	hitboxShape.disabled = true
	emit_signal("hp_changed", stats.health)
	
func _physics_process(delta):
	if enemy_in and not hurtbox.invincible:
		stats.health -= 1
		hurtbox.start_invicible(0.5)
		hurtbox.create_hit_effect()
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state(delta)
		ROLL:
			roll_state(delta)

func attack_state(delta):
	#if velocity.x > 0:
	#	animationPlayer.play("VampireAttackRight")
	#else:
	#	animationPlayer.play("VampireAttackLeft")
	#if velocity.y < 0:
	#	animationPlayer.play("VampireAttackUp")
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func roll_state(delta):
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	move()

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		hitboxSword.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move()
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	elif Input.is_action_just_pressed("roll"):
		state = ROLL

func move():
	velocity = move_and_slide(velocity)

func roll_animation_finished():
	velocity = Vector2.ZERO
	state = MOVE

func attack_animation_finished():
	state = MOVE

func _on_Hurtbox_area_entered(area: Area2D) -> void:
	stats.health -= 1
	enemy_in = true
	hurtbox.start_invicible(0.5)
	hurtbox.create_hit_effect()

func _on_Hurtbox_area_exited(area: Area2D) -> void:
	enemy_in = false
