class_name AttributeEditContainer
extends HBoxContainer


signal value_changed(attribute_name: String, attribute_value: Variant)

var attribute_name: String:
	set(value):
		attribute_name = value
		$AttributeName.text = "%s:" % attribute_name
var attribute_value: Variant
var type_hint: String
var last_text_value: String


func _ready() -> void:
	$EditValue.placeholder_text = type_hint
	$EditValue.text_submitted.connect(_on_text_submitted)
	$EditValue.text_changed.connect(_on_text_changed)
	$EditValue.focus_exited.connect(_on_focus_exited)


func correct_value(value: String, submitted: bool=false) -> void:
	last_text_value = value
	if type_hint == "int":
		correct_int_value(value)
	if type_hint == "float":
		correct_float_value(value)
	else:
		attribute_value = value
		value_changed.emit(attribute_name, attribute_value)


func correct_int_value(value: String) -> void:
	var corrected_text: String = "%d" % int(value)
	var corrected_int: int = int(corrected_text)
	$EditValue.text = corrected_text
	attribute_value = corrected_int
	value_changed.emit(attribute_name, attribute_value)


func correct_float_value(value: String) -> void:
	var corrected_text: String = "%.2f" % float(value)
	var corrected_float: float = float(corrected_text)
	$EditValue.text = corrected_text
	attribute_value = corrected_float
	value_changed.emit(attribute_name, attribute_value)


func _on_text_changed(value: String) -> void:
	last_text_value = value


func _on_text_submitted(value: String) -> void:
	correct_value(value)


func _on_focus_exited() -> void:
	correct_value(last_text_value)
