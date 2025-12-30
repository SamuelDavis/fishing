class_name Cat
extends CharacterBody2D

@export var target: Node2D
@export var speed: float = 300.0
@export var jump_velocity: float = -ProjectSettings.get_setting("physics/2d/default_gravity") / 3
@export var chase_dead_zone: float = 10.0
@export var jump_dead_zone: float = 128.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var collider_shape: CircleShape2D = $CollisionShape2D.shape

var direction: Vector2:
	get:
		return target.global_position - global_position if target else global_position

var distance: float:
	get:
		return max(0, direction.length() - collider_shape.radius)


func _process(_delta: float) -> void:
	# decide movement
	if is_on_floor():
		if distance < jump_dead_zone:
			# jump
			velocity.y = jump_velocity

		if distance > chase_dead_zone:
			# chase
			velocity.x = speed * direction.normalized().x
		else:
			# stop
			velocity.x = move_toward(velocity.x, 0, speed)

	# decide state
	if not is_on_floor():
		sprite.play("dance")
	elif not velocity.is_zero_approx():
		sprite.play("running")
	else:
		sprite.play("idle")


func _physics_process(delta: float) -> void:
	# face target
	if direction.x > chase_dead_zone:
		sprite.flip_h = true
	elif direction.x < -chase_dead_zone:
		sprite.flip_h = false

	# fall
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()
