class_name RopeEnd
extends RigidBody2D

@onready var attach_point: PinJoint2D = $PinJoint2D1
@onready var catch_point: PinJoint2D = $PinJoint2D2
@onready var collider: CollisionShape2D = $CollisionShape2D

var pinned: Node2D


func _ready() -> void:
	body_entered.connect(_on_collision)


func _physics_process(_delta: float) -> void:
	if pinned:
		global_position = pinned.global_position
		attach_point.global_position = global_position


func _on_collision(body: CollisionObject2D) -> void:
	if not body is Cat:
		return
	var cat: Cat = body
	cat.caught = true
	catch_point.reparent(cat)
	global_position = cat.global_position
	catch_point.global_position = cat.global_position
	catch_point.node_a = get_path()
	catch_point.node_b = cat.get_path()
