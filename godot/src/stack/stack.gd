
class_name Stack 
extends Resource
## Mutable Stack similar to Magic the Gathering's Stack system
##
## During the Reaction phase, abilities (whether through played by a card or a permanent has an ability activated) go onto the stack
## No modifications occur until the stack is resolved, in which case 


@export var abilities: Array[Ability] = []