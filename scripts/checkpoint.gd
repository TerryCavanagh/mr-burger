extends Node2D

var currentcheckpoint:bool = false;

func deactivate():
	$AnimatedSprite2D.play("ready");

func activate():
	$AnimatedSprite2D.play("active");
	
func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		get_tree().call_group("checkpoints", "deactivate");
		activate();
		
		body.activatecheckpoint(position);
