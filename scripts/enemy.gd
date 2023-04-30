extends Node2D

var Sprite = null;
var direction:int = -1;
@export var aistyle:String = "pace";
@export var movespeed:int = 1;
@export var image:String = "slime";
var turntime:float = 3;
var time:float = 0;

var commandlist = [];
var command = [];
var commandindex:int = 0;

var state:int = 0;

func _ready():
	Sprite = get_node("Animations/" + image);
	Sprite.visible = true;
	# 0: command
	# 1: animation
	# 2: speed
	# 3: distance
	match aistyle:
		"pace":
			commandlist = [
				["left", "left", movespeed, 16 * 5], 
				#["wait", "idle_left", 1, 10], 
				["right", "right", movespeed, 16 * 5]#,
				#["wait", "idle_right", 1, 10]
			];
			command = commandlist[0];
			commandindex = 0;
			Sprite.play(command[1]);
			time = command[3];
			time = int(floor(time / command[2]));

func _physics_process(_delta):
	var cmd:String = command[0];
	var movementspeed:float = command[2];
	
	match cmd:
		"left":
			position.x = position.x - movementspeed;
		"right":
			position.x = position.x + movementspeed;
		"wait":
			pass;
	
	time -= 1;
	if time <= 0:
		commandindex = (commandindex + 1) % commandlist.size();
		command = commandlist[commandindex];
		time = command[3];
		time = int(floor(time / command[2]));
		Sprite.play(command[1]);

func stopenemy():
	commandlist = [
		["wait", command[1], 0, 100]
	];
	command = commandlist[0];

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		body.killplayer();
		stopenemy();
		await get_tree().create_timer(1.0).timeout
		queue_free();
