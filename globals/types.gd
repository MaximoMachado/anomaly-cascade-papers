## class_name Types <- autoload so commented out
extends RefCounted

## Used for variable setters to signify that this is a read_only variable
## Errors out if it is assigned to
func read_only(old_value: Variant, new_value: Variant) -> Variant:
	if !old_value:
	  return new_value
	else:
	  push_error("read_only: invalid assignment on {old_value}")
	  return null
