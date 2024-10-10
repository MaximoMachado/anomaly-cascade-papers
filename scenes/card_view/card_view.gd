extends Node2D

var startPosition: Vector2
var card_highlighted: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var container := $Container
	var card_front := $CardTemplate
	var card_front_size : Vector2 = card_front.texture.get_size()
	container.custom_minimum_size = Vector2(card_front_size.x / card_front.hframes, \
									card_front_size.y / card_front.vframes)
	print(container.custom_minimum_size)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_container_mouse_entered() -> void:
	$AnimationPlayer.play("Select")
	card_highlighted = true


func _on_container_mouse_exited() -> void:
	$AnimationPlayer.play("Deselect")
	card_highlighted = false
