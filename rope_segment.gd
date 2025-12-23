class_name RopeSegment
extends RigidBody2D

@export var attachment_node: Node
@onready var pin_joint: PinJoint2D = $PinJoint2D


func _ready() -> void:
	pin_joint.node_b = pin_joint.get_path_to(attachment_node)
