extends MarginContainer


@onready var title = $Title
@onready var stack = $Stack

var spell = null


func set_attributes(input_: Dictionary) -> void:
	spell = input_.spell
	
	var input = {}
	input.type = input_.type
	input.subtype = input_.subtype
	title.set_attributes(input)
	title.custom_minimum_size = Vector2(Global.vec.size.aspect)
	
	input = {}
	input.type = "number"
	input.subtype = input_.value
	stack.set_attributes(input)
	stack.custom_minimum_size = Vector2(Global.vec.size.aspect)
	custom_minimum_size = Vector2(Global.vec.size.aspect)


func hide_icons() -> void:
	title.visible = false
	stack.visible = false


func show_icons() -> void:
	title.visible = true
	stack.visible = true
