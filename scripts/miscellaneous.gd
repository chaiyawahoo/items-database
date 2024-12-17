class_name Miscellaneous
extends Item


@warning_ignore("shadowed_variable")
func _init(name: String="New Miscellaneous Item", value: float=0, weight: float=0, stack_size: int=1) -> void:
	super._init(name, "Misc.", value, weight, stack_size)
