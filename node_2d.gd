extends Node2D

@onready var marker_2d: Marker2D = $Sprite2D/Marker2D
@export var bullet_scene: PackedScene
@export var fire_rate: float = 0.1
@onready var label: Label = %Label

var active_timer: Timer




var can_shoot = true

func _ready() -> void:
	active_timer = Timer.new()
	active_timer.one_shot = true
	active_timer.timeout.connect(shoot_timer_end)
	add_child(active_timer)

func _process(_delta: float) -> void:
	look_at(get_global_mouse_position())
	rotation_degrees = wrap(rotation_degrees, 0, 360)
	if rotation_degrees > 90 && rotation_degrees < 270:
		scale.y = -1
	else:
		scale.y = 1
	if !active_timer.is_stopped():
		label.text = "%.1fs" % active_timer.time_left
	else:
		label.text = "Ready"
		
	if Input.is_action_just_pressed("shoot") && can_shoot:
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
