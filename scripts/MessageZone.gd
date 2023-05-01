extends Area2D

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.Game.showmessage("Order No. " + str(body.Game.ordernumber) + "

Ready for
Delivery!");
		body.Game.ordernumber += 1;
		body.Game.preventmovement = true;
		queue_free();
