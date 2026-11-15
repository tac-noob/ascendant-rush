extends CharacterBody2D
#this is the template one and it works so im using it :shrug:

const SPEED = 400.0
const JUMP_VELOCITY = -500.0
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var Spawn: Marker2D = $"../Spawn"

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()

	if direction > 0:
		animated_sprite.flip_h = false
		animated_sprite.play("run")
	elif direction < 0:
		animated_sprite.flip_h = true
		animated_sprite.play("run")
	else:
		animated_sprite.play("default")
	if 


func _on_oob_body_entered(body: Node2d) -> void:
	if body is CharacterBody2D:
		body.global_position = $Spawn.global_position
		body.velocity = Vector2.ZERO
