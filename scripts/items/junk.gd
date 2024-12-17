class_name Junk
extends Item


@warning_ignore("shadowed_variable")
func _init(name: String="New Junk", value: float=0, weight: float=0, stack_size: int=1) -> void:
	super._init(name, "Junk", value, weight, stack_size)
