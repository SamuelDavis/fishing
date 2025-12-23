class_name RopeAnchor
extends StaticBody2D

var mouse_offset: Vector2 = Vector2.ZERO
@onready var button: Button = $Button


func _ready() -> void:
	button.button_down.connect(_on_pressed)


func _physics_process(_delta: float) -> void:
	if button.is_pressed():
		global_position = get_global_mouse_position() + mouse_offset


func _on_pressed() -> void:
	mouse_offset = global_position - get_global_mouse_position()
	print(mouse_offset)
