extends Node

func integer(from_inclusive:int, to_excluding:int):
	return randi_range(from_inclusive, to_excluding - 1);

func pick(array):
	if array.size() == 0:
		return null;
		
	return array[randi() % array.size()];
	
func shuffle(arr:Array) -> Array:
	arr.shuffle();
	return arr;
