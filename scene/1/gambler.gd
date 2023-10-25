extends MarginContainer


@onready var gameboard = $VBox/Gameboard

var casino = null
var datas = {}


func set_attributes(input_: Dictionary) -> void:
	casino = input_.casino
	
	var input = {}
	input.gambler = self
	gameboard.set_attributes(input)
	detect_hand_kits()


func detect_hand_kits() -> void:
	var indexs = [0,1,2,3]
	gameboard.hand.refill()
	#gameboard.hand.refill_based_on_card_indexs(indexs)
	var kits = gameboard.hand.get_all_kits()
	#gameboard.hand.get_kits_based_on_type_and_count("harmony", 4)
	
	for kit in kits:
		print("___",kit,"___")
		for cards_ in kits[kit]:
			print("_",cards_.size(),"_")
			for card in cards_:
				print([card.get_suit(), card.get_rank()])


func find_all_combinations() -> void:
	var n = gameboard.hand.capacity.current
	var m = gameboard.available.cards.get_child_count()
	var k = 0
	datas.index = {}
	datas.combination = {}
	
	for _i in pow(m, 5):
		var indexs = get_indexs(_i)
		
		if indexs.size() == n:
			indexs.sort()
			
			if !datas.index.has(indexs):
				datas.index[indexs] = {}
				datas.index[indexs].k = k
				gameboard.hand.refill_based_on_card_indexs(indexs)
				datas.index[indexs].combination = gameboard.hand.check_all_combinations()
				gameboard.hand.discard()
				gameboard.resort_available()
				#print([k, indexs, datas.index[indexs].combination])
				
				if !datas.combination.has(datas.index[indexs].combination):
					datas.combination[datas.index[indexs].combination] = []
				
				datas.combination[datas.index[indexs].combination].append(indexs)
				k += 1
				
				#print([datas.index[indexs].combination, datas.combination[datas.index[indexs].combination].size()])
	
	for combination in datas.combination:
		print([combination, datas.combination[combination].size()])
	var a = null


func get_indexs(index_: int) -> Array:
	var n = gameboard.hand.capacity.current
	var m = gameboard.available.cards.get_child_count()
	var indexs = []
	
	var _i = 0
	
	while index_ >= m:
		var index = index_ % m
		
		if !indexs.has(index):
			indexs.append(index)
		else:
			return []
		
		index_ /= m
		_i += 1
	
	if !indexs.has(index_):
		indexs.append(index_)
	else:
		return []
	
	return indexs
