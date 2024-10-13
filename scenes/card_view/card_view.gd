class_name CardView extends Node2D

var card: Card
var starting_position: Vector2
var hovered_position: Vector2:
	get: return starting_position + MAXIMUM_HOVER_MOVEMENT

@export var ANIMATION_DURATION := 0.2
@export var MAXIMUM_HOVER_MOVEMENT := Vector2(0, -50)
@export var card_highlighted: bool = false





# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	card = Follower.new()
	starting_position = position
	
	var card_texture = ImageTexture.create_from_image(card.card_image)
	card_texture.set_size_override(%Art.scale)
	%Art.texture = card_texture
	%Name.text = card.card_name
	%Description.text = card.card_text
	if card is Follower:
		%FollowerStats.show()
		%Health.text = str(card.stats.health)
		%Influence.text = str(card.stats.influence)
		%Attack.text = str(card.stats.attack)
	elif card is Factory:
		%FollowerStats.hide()
	elif card is Catalyst:
		%FollowerStats.hide()
		pass
	else:
		%FollowerStats.hide()
		push_error("Unhandled card type in CardView")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_container_mouse_entered() -> void:
	print_debug("enter")
	var scaled_duration = ANIMATION_DURATION
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", hovered_position, scaled_duration)
	card_highlighted = true


func _on_container_mouse_exited() -> void:
	print_debug("exit")
	var scaled_duration = ANIMATION_DURATION
	
	var tween = get_tree().create_tween() 
	tween.tween_property(self, "position", starting_position, ANIMATION_DURATION)
	card_highlighted = true
