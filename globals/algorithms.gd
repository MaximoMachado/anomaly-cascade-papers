## class_name Algorithms <- autoload so commented out
extends Node

## Fisher-yates in-place shuffle
func shuffle(array: Array[Variant]) -> void:
	var rng := RandomNumberGenerator.new()
	var n := array.size()
	for i in range(n-1, 1, -1):
		var j := rng.randi_range(0, i)

		var tmp : Variant = array[i]
		array[i] = array[j]
		array[j] = tmp