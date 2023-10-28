extends Sprite2D


var altar = null


func set_attributes(input_: Dictionary) -> void:
	altar = input_.altar
	position = input_.position
