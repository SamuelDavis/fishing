class_name Cat
extends CharacterBody2D

@export var speed: float = 200.0
@export var target: Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var lag: float = 0.0

var target_offset: Vector2:
	get:
		return target.global_position - global_position


func _process(_delta: float) -> void:
	velocity = target_offset.sign() * speed

	velocity.y = 0


func _physics_process(_delta: float) -> void:
	move_and_slide()


func _face_target() -> void:
	if target_offset.x > 0:
		sprite.flip_h = false
	if target_offset.x < 0:
		sprite.flip_h = true
