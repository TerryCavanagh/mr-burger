extends Area2D

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.Game.showmessage("Thanks for
the burger!

Bonus: +500");
		body.Game.preventmovement = true;
		body.Game.score += 500;
		body.Game.updateUI();
		queue_free();
