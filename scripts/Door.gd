extends Node2D

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		if GameGlobal.keys > 0:
			GameGlobal.keys -= 1;
			body.Game.updateUI();
			queue_free();
