class_name World
extends Node2D

@export var pulling_force: float = 20_000.0
@export var loose_force: float = 1_000.0
@export var loose_buffer_multiplier: float = 1.2

@onready var rope_anchor: RopeAnchor = $RopeAnchor
@onready var rope_end: RopeEnd = $RopeAnchor.rope_end
@onready var cat: Cat = $Cat
@onready var caught: Caught = $Caught

var _pulling: bool = false


func _ready() -> void:
	cat.target = rope_end
	rope_end.body_entered.connect(
		func(body: Node):
			if body is Cat:
				_on_caught()
	)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton or event is InputEventMouseMotion:
		_pulling = event.button_mask & MOUSE_BUTTON_LEFT


func _physics_process(delta: float) -> void:
	if _pulling:
		var force: Vector2 = get_global_mouse_position() - rope_anchor.global_position
		var k: Vector2 = force * delta * pulling_force
		rope_anchor.apply_force(k)

	if caught.visible:
		caught.global_position = rope_end.global_position
		if rope_end.linear_velocity.length() > loose_force:
			_on_loose()


func _on_caught() -> void:
	caught.global_position = rope_end.global_position
	cat.global_position = rope_end.global_position
	call_deferred("_disenable", caught, true)
	call_deferred("_disenable", cat, false)


func _on_loose() -> void:
	caught.global_position = rope_end.global_position
	cat.velocity = rope_end.linear_velocity * 1.2
	cat.global_position = (
		rope_end.global_position
		+ Vector2.ONE * (cat.collider_shape.radius * loose_buffer_multiplier)
	)
	call_deferred("_disenable", cat, true)
	call_deferred("_disenable", caught, false)


func _disenable(node: Node, enable: bool) -> void:
	if enable:
		node.visible = true
		node.process_mode = Node.PROCESS_MODE_INHERIT
		node.collider.disabled = false
	else:
		node.visible = false
		node.process_mode = Node.PROCESS_MODE_DISABLED
		node.collider.disabled = true
