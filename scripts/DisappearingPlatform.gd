extends Node2D

var state = "ready";
var time:float = 0;

var collisionbit:StaticBody2D = null;

func _ready():
	state = "ready";
	collisionenable();
	
func collisionenable():
	collisionbit = StaticBody2D.new();
	var collisionshape2d:CollisionShape2D = CollisionShape2D.new();
	var rectshape:RectangleShape2D = RectangleShape2D.new();
	rectshape.size = Vector2(16, 3);
	collisionshape2d.shape = rectshape;
	collisionshape2d.position.y = -6.5;
	collisionbit.add_child(collisionshape2d);
	
	add_child(collisionbit)
	
func collisiondisable():
	print("platform dissolved...");
	collisionbit.queue_free();
	
func _process(delta):
	if state == "dissolving":
		time -= delta;
		if time <= 0:
			state = "off";
			collisiondisable();

func reset():
	state = "ready";
	$AnimatedSprite2D.visible = true;
	$AnimatedSprite2D.play("idle");
	collisionenable();

func startdissolve():
	print("dissolving platform...");
	$AnimatedSprite2D.play("disappearing");
	state = "dissolving"
	time = 0.70;

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		if state == "ready":
			startdissolve();
