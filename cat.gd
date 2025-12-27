class_name Cat
extends RigidBody2D

@export var target: Node2D

@export var speed: float = 100.0
@export var jump_velocity: float = -400.0
@export var dead_zone: float = 5.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collider: CollisionShape2D = $CollisionShape2D

var caught: bool = false

var direction: Vector2:
	get:
		return target.global_position - global_position


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _process(_delta: float) -> void:
	if caught:
		sprite.play("tickle")
		return

	_face_target()

	# # Handle jump.
	# if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	# 	velocity.y = jump_velocity

	# if direction.abs().x > dead_zone:
	# 	sprite.play("running")
	# else:
	# 	if is_on_floor():
	# 		velocity.y = jump_velocity
	# 	sprite.play("idle")

	# if not is_on_floor():
	# 	sprite.play("dance")


func _physics_process(_delta: float) -> void:
	pass
	# Add the gravity.
	# if not is_on_floor():
	# 	velocity += get_gravity() * delta

	# if direction.abs().x > 5:
	# 	velocity.x = direction.normalized().x * speed
	# else:
	# 	velocity.x = move_toward(velocity.x, 0, speed)

	# move_and_slide()


func _face_target() -> void:
	if direction.x > 0:
		sprite.flip_h = false
	if direction.x < 0:
		sprite.flip_h = true


func _on_body_entered(body: CollisionShape2D) -> void:
	print("enter", body)
	pass


func _on_body_exited(body: CollisionShape2D) -> void:
	print("exit", body)
	pass
