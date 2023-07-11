extends Area2D

func _ready():
	set_collision_mask_value(1, false)
	set_collision_mask_value(2, true)

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.victory();
