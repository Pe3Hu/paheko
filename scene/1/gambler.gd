extends MarginContainer


@onready var gameboard = $VBox/Gameboard

var casino = null


func set_attributes(input_: Dictionary) -> void:
	casino = input_.casino
	
	var input = {}
	input.gambler = self
	gameboard.set_attributes(input)
