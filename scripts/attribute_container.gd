class_name AttributeContainer
extends HBoxContainer


@export var attribute_name: String:
	set(value):
		attribute_name = value
		$AttributeLabel.text = "%s:" % value
@export var attribute_value: String:
	set(value):
		attribute_value = value
		$ValueLabel.text = value
