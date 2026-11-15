extends Node2D

@export var player_number = 2

@onready var label: Label = $"../Label"
@export var swing_rate: float = 0.1
var can_swing = true
var active_timer: SceneTreeTimer

func _ready() -> void:
	$AnimationPlayer.play("Idle")

func _process(_delta: float) -> void:
	var shoot_action = "shoot_p1" if player_number == 1 else "shoot_p2"

	if Input.is_action_just_pressed(shoot_action) && can_swing:
		$AnimationPlayer.play("Sword_swing")
		$AnimationPlayer.queue("Idle")
		swing()

	if active_timer && active_timer.time_left > 0.0:
		label.text = "%.1fs" % active_timer.time_left
	else:
		label.text = "Ready"

func swing():
	can_swing = false
	active_timer = get_tree().create_timer(swing_rate)
	await active_timer.timeout
	can_swing = true
