class_name Cat
extends CharacterBody2D

@export var target: Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collider: CollisionShape2D = $CollisionShape2D

@export var speed: float = 300.0
@export var jump_velocity: float = -400.0
@export var chase_dead_zone: float = 10.0
@export var jump_dead_zone: float = 64.0

var direction: Vector2:
	get:
		return target.global_position - global_position if target else global_position

var distance: float:
	get:
		return max(0, direction.length() - collider.shape.radius)


func _process(_delta: float) -> void:
	if is_on_floor():
		if distance < jump_dead_zone:
			velocity.y = jump_velocity
			if abs(velocity.x) < chase_dead_zone:
				velocity.x = chase_dead_zone * direction.sign().x

		if distance > chase_dead_zone:
			velocity.x = speed * direction.normalized().x
		else:
			velocity.x = move_toward(velocity.x, 0, speed)

	if velocity.is_zero_approx():
		sprite.play("idle")
	else:
		sprite.play("running")

	if not is_on_floor():
		sprite.play("dance")


func _physics_process(delta: float) -> void:
	if direction.x > chase_dead_zone:
		sprite.flip_h = true
	elif direction.x < -chase_dead_zone:
		sprite.flip_h = false

	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()
