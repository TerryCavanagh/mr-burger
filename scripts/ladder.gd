extends Node2D

@onready var area:Area2D = get_node("Area2D");

@export var height:int = 1;
@export var usetreetexture:bool = false;
var laddertexture:Texture2D = preload("res://graphics/ladder.png")
var treetexture:Texture2D = preload("res://graphics/laddertree.png")

var collisionshape2d:CollisionShape2D;
var rectangleshape2d:RectangleShape2D;

func _ready():
	collisionshape2d = CollisionShape2D.new();
	rectangleshape2d = RectangleShape2D.new();
	rectangleshape2d.size = Vector2(4, 16);
	collisionshape2d.shape = rectangleshape2d;
	area.add_child(collisionshape2d);
	
	if usetreetexture:
		get_node("Ladder").visible = false;
		get_node("LadderTree").visible = true;
	
	collisionshape2d.shape.size.y = (16 * height);
	collisionshape2d.position.y = (8 * (height - 1));
	
func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		body.touchingladder = true;

func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		body.touchingladder = false;

func _draw():
	var offset:Vector2 = Vector2(0, 16);
	var i:int = 0;
	while i < height:
		if usetreetexture:
			draw_texture(treetexture, Vector2(-8, -8) + (offset * i));
		else:
			draw_texture(laddertexture, Vector2(-8, -8) + (offset * i));
		i += 1;
