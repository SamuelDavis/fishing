class_name RopeAnchor
extends RigidBody2D

@export var rope_segment_scene: PackedScene = preload("res://RopeSegment.tscn")

@export var rope_segment_count: int = 6
@export var rope_segment_length: float = 10.0
@export var rope_width: float = 2.0

@onready var line: Line2D = $Line2D
@onready var rope_end: RopeEnd = $RopeEnd

var _rope_segments: Array[RopeSegment] = []
var _curve: Curve2D:
	get:
		var curve: Curve2D = Curve2D.new()
		curve.add_point(line.to_local(global_position))
		for node in _rope_segments:
			curve.add_point(line.to_local(node.global_position))
		return curve


func _ready() -> void:
	# initialize children
	for i in rope_segment_count:
		var node: RopeSegment = rope_segment_scene.instantiate()
		node.name = "RopeSegment%s" % i
		add_child(node)
		_rope_segments.append(node)
	_rope_segments.append(rope_end)
	move_child(rope_end, -1)

	# position children
	var previous: Node2D = self
	for node in _rope_segments:
		node.global_position.y = previous.global_position.y + rope_segment_length + 10
		node.pin_joint.node_a = previous.get_path()
		node.size = rope_width
		node.freeze = false
		previous = node

	# initialize line
	line.width = rope_width


func _physics_process(_delta: float) -> void:
	line.clear_points()
	line.points = _curve.get_baked_points()
