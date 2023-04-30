extends Node2D

@export var direction:float = 1;
var force:float = 50;

func _ready():
	if direction == -1:
		$AnimatedSprite2D.play("reverse");

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		body.addtreadmill(self);


func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		body.removetreadmill(self);
