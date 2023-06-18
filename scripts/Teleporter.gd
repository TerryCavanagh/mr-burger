extends Area2D

@export var movex:bool = false;
@export var movey:bool = true;
	
func _on_body_entered(body):
	if body.is_in_group("player"):
		var destination = get_node("destination");
		var shape = get_node("CollisionShape2D");
		if movex:
			body.move_by((destination.position.x - shape.position.x), (destination.position.y - shape.position.y) + 16);
		else:
			body.move_by(0, (destination.position.y - shape.position.y) + 16);
