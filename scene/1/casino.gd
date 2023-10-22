extends MarginContainer


@onready var gamblers = $Gamblers


var sketch = null


func set_attributes(input_: Dictionary) -> void:
	sketch = input_.sketch
	
	init_gamblers()


func init_gamblers() -> void:
	for _i in 1:
		var input = {}
		input.casino = self
	
		var gambler = Global.scene.gambler.instantiate()
		gamblers.add_child(gambler)
		gambler.set_attributes(input)
