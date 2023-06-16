extends Area2D

@export var movex:int = 0;
@export var movey:int = 0;

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.move_by(movex, movey);
