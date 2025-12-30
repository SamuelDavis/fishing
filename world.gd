class_name World
extends Node2D

@export var pulling_force: float = 20_000.0
@export var loose_force: float = 1_000.0
@export var loose_buffer_multiplier: float = 1.2
@export var min_scoring_distance: float = 100.0

@onready var rope_anchor: RopeAnchor = $RopeAnchor
@onready var rope_end: RopeEnd = $RopeAnchor.rope_end
@onready var cat: Cat = $Cat
@onready var caught: Caught = $Caught

@onready var distance_label: Label = $Control/Label

var _pulling: bool = false
var _caught: bool:
	get:
		return caught.visible

var _distance: float = INF
var distance: float:
	set(value):
		_distance = value
		distance_label.text = "Distance %s" % str(value).to_upper()
	get:
		return _distance


func _ready() -> void:
	distance = INF
	_disenable(cat, true)
	_disenable(caught, false)

	cat.target = rope_end
	caught.global_position = rope_end.global_position
	caught.attached_node = rope_end

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

	if _caught:
		if rope_end.linear_velocity.length() > loose_force:
			_on_loose()
	else:
		var distance_vector: Vector2 = cat.global_position - rope_end.global_position
		distance = min(distance, max(0, distance_vector.length() - cat.collider_shape.radius))


func _on_caught() -> void:
	distance = INF
	caught.global_position = rope_end.global_position
	cat.global_position = rope_end.global_position
	call_deferred("_disenable", cat, false)
	call_deferred("_disenable", caught, true)


func _on_loose() -> void:
	distance = INF
	caught.global_position = rope_end.global_position
	cat.velocity = rope_end.linear_velocity * 1.2
	cat.global_position = (
		rope_end.global_position
		+ Vector2.ONE * (cat.collider_shape.radius * loose_buffer_multiplier)
	)
	call_deferred("_disenable", caught, false)
	call_deferred("_disenable", cat, true)


func _disenable(node: Node, enable: bool) -> void:
	node.visible = enable
	if node is Cat:
		node.collider.disabled = not enable
	if node is Caught:
		node.collider.disabled = not enable
	node.set_physics_process(enable)
	node.set_process(enable)
