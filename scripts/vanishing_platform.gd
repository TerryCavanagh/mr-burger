extends Node2D

var state = "ready";
var time:float = 0;
const TOGGLETIME_ON:float = 1.25;
const TOGGLETIME_OFF:float = 1.25;
const TOGGLETIME_CHANGE:float = 0.5;

@export_enum("gray", "yellow", "pink", "green", "brown", "white") var colour = "gray";
@export_enum("on", "off") var startingstate = "on";

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
		"white":
			animatedsprite.self_modulate = Palette.WHITE;
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
	time -= delta;
	
	if state == "on":
		if time <= 0:
			startdisappear();
	elif state == "disappearing":
		if time <= 0:
			turnoff();
	elif state == "off":
		if time <= 0:
			startappear();
	elif state == "appearing":
		if time <= 0:
			turnon();

func reset():
	animatedsprite.speed_scale = 2 / TOGGLETIME_CHANGE;
	if startingstate == "on":
		state = "on"; time = TOGGLETIME_ON;
		animatedsprite.visible = true;
	
		animatedsprite.play("idle_on");
		collisionenable();
	else:
		state = "off"; time = TOGGLETIME_OFF;
		animatedsprite.play("idle_off");
		animatedsprite.visible = true;

func turnon():
	animatedsprite.play("idle_on");
	
	state = "on";
	time = TOGGLETIME_ON;

func turnoff():
	animatedsprite.play("idle_off");
	collisiondisable();
	
	state = "off";
	time = TOGGLETIME_OFF;

func startdisappear():
	animatedsprite.play("disappearing");
	state = "disappearing";
	time = TOGGLETIME_CHANGE;
	
func startappear():
	animatedsprite.play("appearing");
	collisionenable();
	
	state = "appearing";
	time = TOGGLETIME_CHANGE;

