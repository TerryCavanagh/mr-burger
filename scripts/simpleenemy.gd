extends Node2D

var Sprite = null;

@export var image:String = "slime";

var behaviour:String;
var direction:String;
var progress:int = 0;
var speed:int = 0;
var movementrange:int = 1;
var waitdelayframes:int = 0;
var wait:int = 0;

var offset:int = 0;

const TILESIZE:int = 16;

func _ready():
	Sprite = get_node("Animations/" + image);
	Sprite.visible = true;
	
	offset = offset * TILESIZE;
	direction = behaviour;
	playanimation();

func playanimation():
	if direction == "up" || direction == "left":
		Sprite.play("left");
	elif direction == "down" || direction == "right":
		Sprite.play("right");

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if wait > 0:
		wait -= 1;
		if wait <= 0:
			playanimation();
	
	if wait <= 0:
		if direction == "nothing":
			#Just sit there
			pass
		elif direction == "left":
			position.x = position.x - speed;
			offset = offset + speed;
			
			if offset >= TILESIZE * movementrange:
				#Correct the position now
				while offset > TILESIZE * movementrange:
					offset -= 1;
					position.x += 1;
				
				direction = "right";
				offset = 0;
				if waitdelayframes > 0:
					wait = waitdelayframes;
				else:
					playanimation();
		elif direction == "right":
			position.x = position.x + speed;
			offset = offset + speed;
			
			if offset >= TILESIZE * movementrange:
				#Correct the position now
				while offset > TILESIZE * movementrange:
					offset -= 1;
					position.x -= 1;
				
				direction = "left";
				offset = 0;
				if waitdelayframes > 0:
					wait = waitdelayframes;
				else:
					playanimation();
		elif direction == "up":
			position.y = position.y - speed;
			offset = offset + speed;
			
			if offset >= TILESIZE * movementrange:
				#Correct the position now
				while offset > TILESIZE * movementrange:
					offset -= 1;
					position.y += 1;
				
				direction = "down";
				offset = 0;
				if waitdelayframes > 0:
					wait = waitdelayframes;
				else:
					playanimation();
		elif direction == "down":
			position.y = position.y + speed;
			offset = offset + speed;
			
			if offset >= TILESIZE * movementrange:
				#Correct the position now
				while offset > TILESIZE * movementrange:
					offset -= 1;
					position.y -= 1;
				
				direction = "up";
				offset = 0;
				if waitdelayframes > 0:
					wait = waitdelayframes;
				else:
					playanimation();
	
func stopenemy():
	pass
	
func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		body.killplayer();
		stopenemy();
		await get_tree().create_timer(1.0).timeout
		queue_free();
