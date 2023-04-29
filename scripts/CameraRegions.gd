extends Node2D

func _on_body_entered(body):
	if body.is_in_group("player"):
		var cameraposition:Vector2 = get_node("CollisionShape2D").position - (get_node("CollisionShape2D").shape.size / 2);
		var camerabounds:Vector2 = get_node("CollisionShape2D").shape.size;
		var camerazone:Rect2 = Rect2(cameraposition, camerabounds)
		body.addcamerazone(camerazone);

func _on_body_exited(body):
	if body.is_in_group("player"):
		var cameraposition:Vector2 = get_node("CollisionShape2D").position - (get_node("CollisionShape2D").shape.size / 2);
		var camerabounds:Vector2 = get_node("CollisionShape2D").shape.size;
		var camerazone:Rect2 = Rect2(cameraposition, camerabounds)
		body.removecamerazone(camerazone);
