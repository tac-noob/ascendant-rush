extends Node2D

signal hit_player

@export var speed: int = 500

@export var lifetime: float = 3

func _ready() -> void:
	await get_tree().create_timer(lifetime).timeout
	queue_free()
	
func _process(delta: float) -> void:
	position += transform.x * speed * delta
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		hit_player.emit()
		queue_free()
	

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Sword"):
		queue_free()
