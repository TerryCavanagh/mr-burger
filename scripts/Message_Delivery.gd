extends Area2D

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.Game.showmessage("Thanks for
the burger!

Bonus: +500");
		body.position.x += 16;
		body.Game.preventmovement = true;
		GameGlobal.score += 500;
		GameGlobal.ordernumber += 1;
		body.Game.updateUI();
		queue_free();
