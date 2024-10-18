class_name CardView extends Node2D

signal on_hovered(hovered_card: CardView)
signal on_selected(selected_card: CardView)
signal on_deselected(deselected_card: CardView)

var input_active: bool:
	set(value):
		if value:
			%StateChart.send_event("set_active")
		else:
			%StateChart.send_event("set_inactive")

var card: Card
var starting_position: Vector2:
	set(value):
		starting_position = value
		position = value
		
var hovered_position: Vector2:
	get: return starting_position + MAXIMUM_HOVER_MOVEMENT

var size: Vector2:
	get: return $Background.size

@export var ANIMATION_DURATION := 0.2
@export var MAXIMUM_HOVER_MOVEMENT := Vector2(0, -50)
@export var card_highlighted: bool = false
@export var dragging_speed = 1.0


# Initialize UI information based on card
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

func _input(event: InputEvent):
	if Input.is_action_pressed("select"):
		%StateChart.send_event("selected")
	elif Input.is_action_just_released("select"):
		%StateChart.send_event("deselected")

func _on_container_mouse_entered() -> void:
	%StateChart.send_event("mouse_entered")

func _on_container_mouse_exited() -> void:
	%StateChart.send_event("mouse_exited")

func _on_dragging_state_processing(delta: float) -> void:
	var mouse_position = get_global_mouse_position()
	position = lerp(position, mouse_position - (size / 2), dragging_speed * delta)
	
	
func _on_transition_from_dragging_to_static() -> void:

	print_debug("deselected")
	on_deselected.emit(self)
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", starting_position, ANIMATION_DURATION)


func _on_transition_from_static_to_hovered() -> void:
	print_debug("hovered")
	on_hovered.emit(self)
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", hovered_position, ANIMATION_DURATION)
	card_highlighted = true


func _on_transition_from_hovered_to_static() -> void:

	
	var tween = get_tree().create_tween() 
	tween.tween_property(self, "position", starting_position, ANIMATION_DURATION)
	card_highlighted = false

func _on_transition_from_hovered_to_dragging() -> void:
	print_debug("selected")
	on_selected.emit(self)
