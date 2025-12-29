class_name World
extends Node2D

@export var pulling_force: float = 20_000.0

@onready var rope_anchor: RopeAnchor = $RopeAnchor
@onready var rope_end: RopeEnd = $RopeAnchor.rope_end
@onready var cat: Cat = $Cat
@onready var caught: Caught = $Caught

var _pulling: bool = false
var _caught: bool = false
var _max_velocity: float = 0.0


func _ready() -> void:
	cat.target = rope_end
	rope_end.body_entered.connect(_on_caught)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton or event is InputEventMouseMotion:
		_pulling = event.button_mask & MOUSE_BUTTON_LEFT


func _physics_process(delta: float) -> void:
	if _pulling:
		var force: Vector2 = get_global_mouse_position() - rope_anchor.global_position
		var k: Vector2 = force * delta * pulling_force
		rope_anchor.apply_force(k)

	if _caught:
		cat.global_position = rope_end.global_position
		cat.sprite.play("tickle")
		_max_velocity = max(_max_velocity, rope_end.linear_velocity.length())
		if rope_end.linear_velocity.length() > 1000.0:
			cat.collider.disabled = false
			cat.process_mode = Node.PROCESS_MODE_INHERIT
			_caught = false


func _on_caught(body: Node) -> void:
	if body is Cat:
		cat.visible = false
		cat.process_mode = Node.PROCESS_MODE_DISABLED
		cat.collider.disabled = true

		caught.global_position = rope_end.global_position
		caught.visible = true
		caught.process_mode = Node.PROCESS_MODE_INHERIT
		caught.collider.disabled = false
	else:
		print(body)


func _on_loose() -> void:
	cat.process_mode = Node.PROCESS_MODE_INHERIT
	cat.visible = true
