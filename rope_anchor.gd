class_name RopeAnchor
extends RigidBody2D

@export var rope_segments: int = 6
@export var rope_segment_scene: PackedScene
@export var end: RopeEnd
@export var speed: float = 450.0
@export var dead_zone: float = 5.0

@onready var button: Button = $Button
@onready var line: Line2D = $Line2D

var _offset: Vector2 = Vector2.ZERO
var _nodes: Array[Node] = []

var attach_point: Node2D:
	get:
		return self

var direction: Vector2:
	get:
		return get_global_mouse_position() - global_position


func _ready() -> void:
	button.button_down.connect(_on_pressed)
	_nodes = _build_rope()


func _physics_process(delta: float) -> void:
	line.global_position = global_position
	line.points = _get_curve().get_baked_points()

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
	_offset = get_global_mouse_position() - global_position


func _build_rope() -> Array[Node]:
	var nodes: Array[Node] = []

	var previous: Node2D = self
	for i in rope_segments:
		var segment: RopeSegment = rope_segment_scene.instantiate()
		add_child(segment)
		segment.global_position = previous.attach_point.global_position
		segment.pin_joint.node_a = previous.get_path()
		previous = segment
		nodes.append(segment)

	end.global_position = previous.attach_point.global_position
	end.attach_point.node_a = previous.get_path()
	nodes.append(end)

	return nodes


func _get_curve() -> Curve2D:
	var curve: Curve2D = Curve2D.new()
	var prev: Vector2
	var curr: Vector2
	var next: Vector2

	for node in _nodes:
		next = node.position
		if prev and curr and next:
			var tangent = (next - prev) / 10
			curve.add_point(curr, -tangent, tangent)
		prev = curr
		curr = next

	next = end.position
	if prev and curr and next:
		var tangent = (next - prev) / 10
		curve.add_point(curr, -tangent, tangent)

	return curve
