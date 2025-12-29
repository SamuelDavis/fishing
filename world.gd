class_name World
extends Node2D

@export var pulling_force: float = 20_000.0
@export var caught_scene: PackedScene

@onready var rope_anchor: RopeAnchor = $RopeAnchor
@onready var cat: Cat = $Cat

var _pulling: bool = false


func _ready() -> void:
	cat.target = rope_anchor.rope_end
	rope_anchor.rope_end.caught.connect(_on_caught)
	rope_anchor.rope_end.loose.connect(_on_loose)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton or event is InputEventMouseMotion:
		_pulling = event.button_mask & MOUSE_BUTTON_LEFT


func _physics_process(delta: float) -> void:
	if _pulling:
		var force: Vector2 = get_global_mouse_position() - rope_anchor.global_position
		var k: Vector2 = force * delta * pulling_force
		rope_anchor.apply_force(k)


func _on_caught() -> void:
	cat.process_mode = Node.PROCESS_MODE_DISABLED
	cat.visible = false


func _on_loose() -> void:
	cat.process_mode = Node.PROCESS_MODE_INHERIT
	cat.visible = true
