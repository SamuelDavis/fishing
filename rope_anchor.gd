class_name RopeAnchor
extends AnimatableBody2D

@export var rope_segments: int = 6
@export var rope_segment_scene: PackedScene
@export var end: RigidBody2D
@export var speed: float = 450.0
@export var dead_zone: float = 5.0

@onready var button: Button = $Button
@onready var line: Line2D = $Line2D

var offset: Vector2 = Vector2.ZERO

var attach_point: Node2D:
	get:
		return self

var direction: Vector2:
	get:
		return get_global_mouse_position() - global_position


func _ready() -> void:
	button.button_down.connect(_on_pressed)
	_build_rope()


func _physics_process(delta: float) -> void:
	line.global_position = global_position
	line.points = _get_points()

	if not button.is_pressed():
		return

	var step = Vector2.ZERO
	if direction.length() < dead_zone:
		step = lerp(direction, Vector2.ZERO, 0.5)
	else:
		step = direction.normalized() * speed * delta

	var collision: KinematicCollision2D = move_and_collide(step)
	if collision:
		print(collision.get_angle())


func _on_pressed() -> void:
	offset = get_global_mouse_position() - global_position


func _build_rope() -> void:
	var previous: Node2D = self
	for i in rope_segments:
		var segment: RopeSegment = rope_segment_scene.instantiate()
		add_child(segment)
		segment.global_position = previous.attach_point.global_position
		segment.pin_joint.node_a = previous.get_path()
		previous = segment

	end.global_position = previous.attach_point.global_position
	for child in end.get_children():
		if child is PinJoint2D:
			child.node_a = previous.get_path()
			break


func _get_points() -> PackedVector2Array:
	var points: PackedVector2Array = []
	for node in get_children():
		if node is RopeSegment:
			points.append(node.position)
	points.append(end.position)
	return points
