extends Node2D

@onready var shape = $Area2D/CollisionShape2D;

@export var ropelength:int = 48;
@export var speed:float = 1.0;

#number between 0-36000
var angle:int = 0;

var ropedirx:float = 0;
var ropediry:float = 0;
const DEFAULTROPEPOSITION:float = 0.85;
var ropeposition:float = 0.85;

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.speed_scale = 1.5 * speed;
	shape.shape.size = Vector2(4, ropelength);
	@warning_ignore("integer_division")
	shape.position.y = int(floor(ropelength / 2));

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#angle = int(floor((angle + (delta * 1000)))) % 36000;
	@warning_ignore("integer_division")
	ropedirx = cos((angle / 100) * (PI / 180));
	@warning_ignore("integer_division")
	ropediry = sin((angle / 100) * (PI / 180));
	queue_redraw()
	
func _draw():
	draw_line(Vector2(0, 0), Vector2(ropedirx * ropelength, ropediry * ropelength), Palette.WHITE, 2, false);

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		body.grabrope(self);

func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		body.releaserope();
