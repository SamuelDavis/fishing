class_name RopeEnd
extends RopeSegment

signal caught


func _on_cat_collision(body: Cat) -> void:
	super._on_cat_collision(body)
	caught.emit()
