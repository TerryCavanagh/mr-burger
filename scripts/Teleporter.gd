extends Area2D
	
func _on_body_entered(body):
	if body.is_in_group("player"):
		var destination = get_node("destination");
		var shape = get_node("CollisionShape2D");
		body.move_by(0, (destination.position.y - shape.position.y) + 16);
