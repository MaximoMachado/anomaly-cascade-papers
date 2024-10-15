class_name CardView extends Node2D


var card: Card
var starting_position: Vector2:
	set(value):
		starting_position = value
		position = value
		
var hovered_position: Vector2:
	get: return starting_position + MAXIMUM_HOVER_MOVEMENT
var drag_offset: Vector2 = Vector2(0, 0)

var size: Vector2:
	get: return $Background.size

@export var ANIMATION_DURATION := 0.2
@export var MAXIMUM_HOVER_MOVEMENT := Vector2(0, -50)
@export var card_highlighted: bool = false

# Drag state
var mouse_colliding = false
enum DragState { DRAGGING, STATIC }
var drag_state = DragState.STATIC
@export var dragging_speed = 1.0


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
		%CardType.text = "Follower"
		%FollowerStats.show()
		%Health.text = str(card.stats.health)
		%Influence.text = str(card.stats.influence)
		%Attack.text = str(card.stats.attack)
	elif card is Factory:
		%CardType.text = "Factory"
		%FollowerStats.hide()
	elif card is Catalyst:
		%CardType.text = "Catalyst"
		%FollowerStats.hide()
		pass
	else:
		%FollowerStats.hide()
		push_error("Unhandled card type in CardView")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	if Input.is_action_pressed("left_click") and mouse_colliding:
		drag_state = DragState.DRAGGING
	elif Input.is_action_just_released("left_click"):
		drag_state = DragState.STATIC
		drag_offset = Vector2(0, 0)
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", starting_position, ANIMATION_DURATION)
	
	match drag_state:
		DragState.STATIC:
			pass
		DragState.DRAGGING:
			var mouse_position = get_global_mouse_position()
			position = lerp(position, mouse_position - (size / 2), dragging_speed * delta)

func _on_container_mouse_entered() -> void:
	print_debug("enter")
	mouse_colliding = true
	if drag_state == DragState.STATIC:
		drag_offset = position - get_global_mouse_position()
		var scaled_duration = ANIMATION_DURATION
		
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", hovered_position, scaled_duration)
		card_highlighted = true


func _on_container_mouse_exited() -> void:
	mouse_colliding = false
	print_debug("exit")
	if drag_state == DragState.STATIC:
		var scaled_duration = ANIMATION_DURATION
		
		var tween = get_tree().create_tween() 
		tween.tween_property(self, "position", starting_position, ANIMATION_DURATION)
		card_highlighted = true
