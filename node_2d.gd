
extends Node2D

@export var player_number = 2
@onready var marker_2d: Marker2D = $Sprite2D/Marker2D
@export var bullet_scene: PackedScene
@export var fire_rate: float = 0.1
@onready var label: Label = %Label

@export var direction_grace_time: float = 0.12

var active_timer: Timer
var can_shoot = true

var last_direction = Vector2.RIGHT
var direction_timer = 0.0

func _ready() -> void:
	active_timer = Timer.new()
	active_timer.one_shot = true
	active_timer.timeout.connect(shoot_timer_end)
	add_child(active_timer)

func _process(_delta: float) -> void:
	var direction = Vector2.ZERO

	if player_number == 1:
		direction = Input.get_vector("left_p1", "right_p1", "up_p1", "down_p1")
	elif player_number == 2:
		direction = Input.get_vector("left_p2", "right_p2", "up_p2", "down_p2")

	if direction != Vector2.ZERO:
		if abs(direction.x) > 0.5 and abs(direction.y) > 0.5:
			last_direction = direction.normalized()
			direction_timer = direction_grace_time
		elif direction_timer <= 0.0:
			last_direction = direction.normalized()
		else:
			direction_timer -= _delta
	else:
		direction_timer -= _delta

	global_rotation = last_direction.angle()
	$Sprite2D.flip_v = last_direction.x < 0

	if !active_timer.is_stopped():
		label.text = "%.1fs" % active_timer.time_left
	else:
		label.text = "Ready"

	var shoot_action = "shoot_p1" if player_number == 1 else "shoot_p2"

	if Input.is_action_just_pressed(shoot_action) && can_shoot:
		shoot()

func shoot():
	can_shoot = false

	var bullet_instance = bullet_scene.instantiate()
	bullet_instance.hit_player.connect(shoot_timer_reload)

	get_tree().root.add_child(bullet_instance)
	bullet_instance.global_position = marker_2d.global_position
	bullet_instance.rotation = marker_2d.global_rotation

	active_timer.start(fire_rate)

func shoot_timer_reload():
	active_timer.stop()
	can_shoot = true

func shoot_timer_end():
	can_shoot = true
