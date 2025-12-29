class_name Caught
extends RigidBody2D

@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var pin_joint: PinJoint2D = $PinJoint2D

var attached_node: PhysicsBody2D:
	get:
		return get_node(pin_joint.node_a)
	set(node):
		pin_joint.node_a = node.get_path()
