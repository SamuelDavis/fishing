class_name RopeEnd
extends RopeSegment

signal caught
signal loose

@export var lost_grip_velocity: float = 500.0

@onready var _caught: RigidBody2D = $Caught


func _on_cat_collision(body: Cat) -> void:
	super._on_cat_collision(body)
	caught.emit()

	_caught.process_mode = Node.PROCESS_MODE_INHERIT
	_caught.visible = true


func _process(_delta: float) -> void:
	if _caught.visible and linear_velocity.length() >= lost_grip_velocity:
		loose.emit()

		_caught.visible = false
		_caught.process_mode = Node.PROCESS_MODE_DISABLED
