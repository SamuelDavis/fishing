class_name RopeAnchor
extends AnimatableBody2D

@export var rope_segments: int = 6
@export var rope_segment_scene: PackedScene
@export var end: RigidBody2D

@onready var button: Button = $Button

var mouse_offset: Vector2 = Vector2.ZERO

var attach_point: Node2D:
	get:
		return self

var target_position: Vector2:
	get:
		return get_global_mouse_position() + mouse_offset


func _ready() -> void:
	button.button_down.connect(_on_pressed)

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


func _physics_process(_delta: float) -> void:
	if button.is_pressed():
		global_position = target_position


func _on_pressed() -> void:
	mouse_offset = global_position - get_global_mouse_position()
