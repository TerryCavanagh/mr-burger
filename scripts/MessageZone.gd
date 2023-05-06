extends Area2D

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.Game.showmessage("Order No. " + str(GameGlobal.ordernumber) + "

Ready for
Delivery!");
		body.position.x += 16;
		body.Game.preventmovement = true;
		queue_free();
