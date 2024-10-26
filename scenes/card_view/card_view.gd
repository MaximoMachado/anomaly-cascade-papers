class_name CardView extends Area2D

## When this card is clicked while deselected
signal select_requested(card_view: CardView)
## When this card is clicked while selected
signal deselect_requested(card_view: CardView)

var card: Card = HiddenCard.new()


@export_subgroup("Hover Properties")
## Whether or not card moves on mouse hover
@export var hoverable := false
## Distance from starting_postion to move to on hover
@export var HOVER_DISTANCE := Vector2(0, -50)
## Dictates position to return to when hover ends
var starting_position: = Vector2(0, 0)

## Returns visible size, not collider size
var size: Vector2:
	get: return %Background.size
	
var _hovered := false
@onready var _hover_timer := get_tree().create_timer(0)
@onready var card_texture := load(card.card_image_path)
func _ready() -> void:
	starting_position = position
	draw.call_deferred()
	
func _process(delta: float) -> void:
	pass

## Whenever card is updated, draw will need to be called as well
func draw() -> void:
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
	elif card is HiddenCard:
		for child in $Background.get_children():
			child.hide()
	else:
		%FollowerStats.hide()
		push_error("Unhandled card type in CardView")


## Hover logic
func _on_mouse_entered() -> void:
	if hoverable:
		_hovered = true
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", starting_position + HOVER_DISTANCE, 0.2)

## Hover logic
func _on_mouse_exited() -> void:
	if hoverable:
		_hovered = false
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", starting_position, 0.2)

## Select Logic
func select():
	%StateChart.send_event("select")

## Select Logic
func deselect():
	%StateChart.send_event("deselect")

## Select Logic
func _on_selected_state_entered() -> void:
	%Highlight.show()

## Select Logic
func _on_deselected_state_entered() -> void:
	%Highlight.hide()

## Select Logic
func _on_selected_state_input(event: InputEvent) -> void:
	if _hovered and Input.is_action_just_pressed("select")  or Input.is_action_just_pressed("deselect"):
		deselect_requested.emit(self)


## Select Logic
func _on_deselected_state_input(event: InputEvent) -> void:
	if _hovered and Input.is_action_just_pressed("select"):
		select_requested.emit(self)
