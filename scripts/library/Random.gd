extends Node

func integer(from:int, to:int):
	return randi_range(from, to);

func pick(array):
	if array.size() == 0:
		return null;
		
	return array[randi() % array.size()];
	
func shuffle(arr:Array) -> Array:
	arr.shuffle();
	return arr;
