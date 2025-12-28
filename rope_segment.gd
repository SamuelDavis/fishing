class_name RopeSegment
extends RigidBody2D

@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var pin_joint: PinJoint2D = $PinJoint2D

var size: float:
	get:
		if collider.shape is CircleShape2D:
			return (collider.shape as CircleShape2D).radius
		else:
			push_error("(get) unhandled collider shape: %s" % collider.shape)
			return -1.0
	set(value):
		if collider.shape is CircleShape2D:
			(collider.shape as CircleShape2D).radius = value
		else:
			push_error("(set) unhandled collider shape: %s" % collider.shape)

var attached_node: Node2D:
	get:
		return get_node(pin_joint.node_a)
	set(node):
		pin_joint.node_a = node.get_path()


func _ready() -> void:
	body_entered.connect(
		func(body):
			if body is Cat:
				_on_cat_collision(body)
	)


func _on_cat_collision(body: Cat) -> void:
	apply_force(body.velocity * 1000)
