class_name FollowerView extends Area2D
## Handles inputs and displaying a card while it is in the Follower Zone

## When this follower is clicked while deselected
signal select_requested(follower_view: FollowerView)
## When this follower is clicked while selected
signal deselect_requested(follower_view: FollowerView)

var follower: Follower = Follower.new()


@export_subgroup("Hover Properties")
## Whether or not follower moves on mouse hover
@export var hoverable := false
## Amount follower increases in scale on hover
@export var HOVER_SCALE := Vector2(0.05, 0.05)
## Dictates position to return to when hover ends
var original_scale: = Vector2(1, 1)

## Returns visible size, not collider size
var size: Vector2:
	get: return $Background.size
	
var _hovered := false
@onready var follower_texture : Texture2D = load(follower.card_image_path)
func _ready() -> void:
	original_scale = scale
	draw.call_deferred()
	
func _process(delta: float) -> void:
	pass

## Whenever follower is updated, draw will need to be called as well
func draw() -> void:
	%Art.texture = follower_texture
	%Name.text = follower.card_name
	%Health.text = str(follower.stats.health)
	%Influence.text = str(follower.stats.influence)
	%Attack.text = str(follower.stats.attack)


## Hover logic
func _on_mouse_entered() -> void:
	if hoverable:
		_hovered = true
		var tween = get_tree().create_tween()
		tween.tween_property(self, "scale", scale + HOVER_SCALE, 0.2)

## Hover logic
func _on_mouse_exited() -> void:
	if hoverable:
		_hovered = false
		var tween = get_tree().create_tween()
		tween.tween_property(self, "scale", original_scale, 0.2)

## Select Logic
func select():
	$StateChart.send_event("select")

## Select Logic
func deselect():
	$StateChart.send_event("deselect")

## Select Logic
func _on_selected_state_entered() -> void:
	$Highlight.show()

## Select Logic
func _on_deselected_state_entered() -> void:
	$Highlight.hide()

## Select Logic
func _on_selected_state_input(event: InputEvent) -> void:
	if _hovered and Input.is_action_just_pressed("select")  or Input.is_action_just_pressed("deselect"):
		deselect_requested.emit(self)


## Select Logic
func _on_deselected_state_input(event: InputEvent) -> void:
	if _hovered and Input.is_action_just_pressed("select"):
		select_requested.emit(self)
