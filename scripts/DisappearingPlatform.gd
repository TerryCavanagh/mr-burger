extends Node2D

var state = "ready";
var time:float = 0;
const RESETTIME:float = 2.0;

@export_enum("gray", "yellow", "pink", "green", "brown") var colour = "gray";

var animatedsprite:AnimatedSprite2D = null;
var collisionbit:StaticBody2D = null;

func _ready():
	animatedsprite = get_node("sprite");
	match colour:
		"gray":
			animatedsprite.self_modulate = Color("#a7a8a8");
		"yellow":
			animatedsprite.self_modulate = Color("#faea27");
		"pink":
			animatedsprite.self_modulate = Color("#fd3978");
		"green":
			animatedsprite.self_modulate = Color("#6ccd30");
		"brown":
			animatedsprite.self_modulate = Color("#ffa600");
	reset();
	
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
	collisionbit.queue_free();
	
func _process(delta):
	if state == "dissolving":
		time -= delta;
		if time <= 0:
			state = "off"; time = RESETTIME;
			collisiondisable();
	elif state == "off":
		time -= delta;
		if time <= 0:
			state = "appearing"; time = 0.2;
			animatedsprite.play("appearing");
			collisionenable();
	elif state == "appearing":
		time -= delta;
		if time <= 0:
			state = "ready"; time = 0;
			animatedsprite.play("idle");

func reset():
	state = "ready";
	animatedsprite.visible = true;
	animatedsprite.speed_scale = 1.5;
	animatedsprite.play("idle");
	collisionenable();

func startdissolve():
	animatedsprite.play("disappearing");
	state = "dissolving"
	time = 0.4666;

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		if state == "ready":
			startdissolve();
