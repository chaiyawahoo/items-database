class_name Potion
extends Item


var effect: String
var duration: float


@warning_ignore("shadowed_variable")
func _init(name: String="New Potion", value: float=0, weight: float=0, stack_size: int=1, effect: String="Random Effect", duration: float=0) -> void:
	super._init(name, "Potion", value, weight, stack_size)
	if duration < 0:
		push_warning("Duration must be no less than 0 (tried to set to %.2f). Setting Duration to 0." % duration)
		duration = 0
	
	self.effect = effect
	self.duration = duration


func insert_into_db(skip_insert: bool=false) -> void:
	super.insert_into_db(skip_insert)
	if skip_insert:
		return
	var row = {
		"ItemID": self.id,
		"Effect": self.effect,
		"Duration": self.duration,
	}
	
	DBHandler.db.insert_row("Potion", row)


func get_display_attributes() -> Dictionary:
	var output: Dictionary = super.get_display_attributes()
	return output.merged({
		"Effect": effect,
		"Duration": "%.2f seconds" % duration
	})


func _to_string() -> String:
	return "(%d, %s, %s, %.2f, %.2f, %d, %s, %.2f)" % [self.id, self.name, self.type, self.value, self.weight, self.stack_size, self.effect, self.duration]
