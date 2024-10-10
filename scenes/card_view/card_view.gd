extends Container

var startPosition: Vector2
var card_highlighted: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var card_front := $CardFront
	var card_front_size : Vector2 = card_front.texture.get_size()
	custom_minimum_size = Vector2(card_front_size.x / card_front.hframes, \
									card_front_size.y / card_front.vframes)
	print(custom_minimum_size)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mouse_entered() -> void:
	$AnimationPlayer.play("Select")
	card_highlighted = true


func _on_mouse_exited() -> void:
	$AnimationPlayer.play("Deselect")
	card_highlighted = false


func _on_gui_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton):
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			pass
			
			
