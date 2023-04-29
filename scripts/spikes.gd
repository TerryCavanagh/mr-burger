extends Node2D

@onready var collisionshape:CollisionShape2D = get_node("Area2D").get_node("CollisionShape2D");
@onready var shape:RectangleShape2D = collisionshape.shape;

@export_enum("left", "right", "up", "down") var type:String = "up";

func _ready():
	updatespike();
	
func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		body.killplayer();

func updatespike():
	$AnimatedSprite2D.play(type);
	match type:
		"up":
			shape.size = Vector2(16, 8);
			collisionshape.position.x = 0;
			collisionshape.position.y = 4;
		"down":
			shape.size = Vector2(16, 8);
			collisionshape.position.x = 0;
			collisionshape.position.y = -4;
		"left":
			shape.size = Vector2(8, 14);
			collisionshape.position.x = 4;
			collisionshape.position.y = 0;
		"right":
			shape.size = Vector2(8, 16);
			collisionshape.position.x = -4;
			collisionshape.position.y = 0;
