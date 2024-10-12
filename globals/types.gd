## class_name Types <- autoload so commented out
extends Node

## Used for variable setters to signify that this is a readonly variable
## Errors out if it is assigned to
static func const_var(old_value, new_value) -> void:
    if !old_value:
      old_value = new_value
    else:
      push_error("const_var: invalid assignment on {old_value}")