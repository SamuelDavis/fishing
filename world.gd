class_name World
extends Node2D

@export var pulling_force: float = 20_000.0

@onready var rope_anchor: RopeAnchor = $RopeAnchor

var _pulling: bool = false


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton or event is InputEventMouseMotion:
		_pulling = event.button_mask & MOUSE_BUTTON_LEFT


func _physics_process(delta: float) -> void:
	if _pulling:
		var force: Vector2 = get_global_mouse_position() - rope_anchor.global_position
		var k: Vector2 = force * delta * pulling_force
		rope_anchor.apply_force(k)
