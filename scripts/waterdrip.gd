extends CharacterBody2D

var Sprite = null;
@export var repeat_time:float = 1.5;
@export var offset_time:float = 0;

var state:String = "ready";
var time:float = 0.0;
const GRAVITY = 22
const MAXFALLSPEED = 160;

var originalposition:float = 0.0;

func _ready() -> void:
	Sprite = get_node("dripsprite");
	Sprite.play("wait");
	Sprite.visible = true;
	velocity.y = 0.0;
	originalposition = position.y;
	
	time = repeat_time + offset_time;
	state = "ready";

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state == "ready":
		time -= delta;
		if time <= 0:
			Sprite.play("drip");
			state = "drip";
	elif state == "drop":
		velocity.y += GRAVITY;
		if velocity.y > MAXFALLSPEED:
			velocity.y = MAXFALLSPEED;
			
		move_and_slide();

func _on_dripsprite_animation_finished() -> void:
	if state == "splash":
		reset();
	elif state == "drip":
		Sprite.play("drop");
		state = "drop";
	
func stopenemy():
	state = "stop";
	pass
	
func reset():
	Sprite.play("wait");
	state = "ready";
	position.y = originalposition;
	Sprite.visible = true;
	velocity.y = 0.0;
	
	time = repeat_time;
	state = "ready";
	
func splash():
	Sprite.play("splash");
	state = "splash";

func _on_collision_body_entered(body: Node2D) -> void:
	if body.name == "TileMap":
		splash();
	elif body.is_in_group("player"):
		if state == "drop":
			body.killplayer();
			stopenemy();
			await get_tree().create_timer(1.0).timeout
			queue_free();
