extends MarginContainer


@onready var index = $VBox/Index
@onready var suitIcon = $VBox/Suit
@onready var rankValue = $VBox/Rank
@onready var chargeIcon = $VBox/Charge/Icon
@onready var chargeValue = $VBox/Charge/Value
@onready var toughnessIcon = $VBox/Toughness/Icon
@onready var toughnessValue = $VBox/Toughness/Value
@onready var bg = $BG

var area = null
var gameboard = null
var charge = {}
var toughness = {}


func set_attributes(input_: Dictionary) -> void:
	#var description = Global.dict.card.index[input_.index]
	index.text = str(0)
	charge.limit = 1
	charge.current = charge.limit
	toughness.limit = 1
	toughness.current = toughness.limit
	
	set_icons(input_)


func set_icons(input_: Dictionary) -> void:
	var input = {}
	input.type = "number"
	input.subtype =  input_.rank
	rankValue.set_attributes(input)
	
	input.subtype = charge.current
	chargeValue.set_attributes(input)
	
	input.subtype = toughness.current
	toughnessValue.set_attributes(input)

	input.type = "suit"
	input.subtype = input_.suit
	suitIcon.set_attributes(input)
	
	input.type = "resource"
	input.subtype = "energy"
	chargeIcon.set_attributes(input)
	
	input.subtype = "spares"
	toughnessIcon.set_attributes(input)
	
