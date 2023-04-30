extends Node2D

var Sprite = null;
var direction:int = -1;
var aistyle:String = "pace";
var turntime:float = 3;
var time:float = 0;

var startposition:Vector2;

var commandlist = [];
var command = [];
var commandindex:int = 0;

var state:int = 0;

func _ready():
	Sprite = get_node("Animations/slime");
	match aistyle:
		"pace":
			startposition = position;
			commandlist = [
				["moveleft", "left", 16 * 5, 3], 
				["wait", "idle_left", 0, 1], 
				["moveright", "right", 16 * 5, 1], 
				["wait", "idle_right", 0, 1]
			];
			command = commandlist[0];
			commandindex = 0;
			Sprite.play(command[1]);
			time = command[3];

func _physics_process(delta):
	var cmd:String = command[0];
	var movementrange:float = command[2];
	
	match cmd:
		"moveleft":
			position.x = floor(startposition.x - (movementrange * ((command[3] - time) / command[3])));
		"moveright":
			position.x = floor(startposition.x + (movementrange * ((command[3] - time) / command[3])));
		"wait":
			pass;
	
	time -= delta;
	if time <= 0:
		startposition = position;
		commandindex = (commandindex + 1) % commandlist.size();
		command = commandlist[commandindex];
		time = command[3];
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
