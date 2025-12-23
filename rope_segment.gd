class_name RopeSegment
extends RigidBody2D

@export var attachment_node: Node
@onready var pin_joint: PinJoint2D = $PinJoint2D
@onready var attach_point: Marker2D = $Marker2D


func _ready() -> void:
	attach_to(attachment_node)


func attach_to(node: Node) -> void:
	pin_joint.node_b = pin_joint.get_path_to(node)
