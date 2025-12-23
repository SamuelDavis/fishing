class_name RopeAnchor
extends StaticBody2D

@onready var button: Button = $Button
@onready var start: Marker2D = $Start
@onready var end: Marker2D = $End

@export var segment_scene: PackedScene
@export var segment_count: int = 3

var mouse_offset: Vector2 = Vector2.ZERO


func _ready() -> void:
	button.button_down.connect(_on_pressed)
	build_rope()


func _physics_process(_delta: float) -> void:
	if button.is_pressed():
		global_position = get_global_mouse_position() + mouse_offset


func _on_pressed() -> void:
	mouse_offset = global_position - get_global_mouse_position()
	print(mouse_offset)


func build_rope() -> void:
	var previous: Node = self
	for i in segment_count:
		var segment: RopeSegment = segment_scene.instantiate()
		add_child(segment)
		if previous is RopeAnchor:
			segment.global_position = previous.start.global_position
		elif previous is RopeSegment:
			segment.global_position = previous.attach_point.global_position
		else:
			push_error("previous is neither a RopeAnchor or RopeSegment")

		segment.attach_to(previous)
		previous = segment

	if previous is RopeSegment:
		end.reparent(previous)
		end.position = previous.attach_point.position
