class_name Food
extends Item


var health_restore: float
var stamina_restore: float


@warning_ignore("shadowed_variable")
func _init(name: String="New Food", value: float=0, weight: float=0, stack_size: int=1, health_restore: float=0, stamina_restore: float=0) -> void:
	super._init(name, "Food", value, weight, stack_size)
	if health_restore < 0:
		push_warning("Health Restore must be no less than 0 (tried to set to %.2f). Setting Health Restore to 0." % health_restore)
		health_restore = 0
	if stamina_restore < 0:
		push_warning("Stamina Restore must be no less than 0 (tried to set to %.2f). Setting Stamina Restore to 0." % stamina_restore)
		stamina_restore = 0
	
	self.health_restore = health_restore
	self.stamina_restore = stamina_restore


func insert_into_db(skip_insert: bool=false) -> void:
	super.insert_into_db(skip_insert)
	if skip_insert:
		return
	var row = {
		"ItemID": self.id,
		"HealthRestore": self.health_restore,
		"StaminaRestore": self.stamina_restore,
	}
	
	DBHandler.db.insert_row("Food", row)


func get_display_attributes() -> Dictionary:
	var output: Dictionary = super.get_display_attributes()
	return output.merged({
		"Health Restore": "%.2f hearts" % health_restore,
		"Stamina Restore": "%.2f energy" % stamina_restore,
	})


func _to_string() -> String:
	return "(%d, %s, %s, %.2f, %.2f, %d, %.2f, %.2f)" % [self.id, self.name, self.type, self.value, self.weight, self.stack_size, self.health_restore, self.stamina_restore]
