extends MarginContainer


@onready var cards = $Cards

var capacity = {}
var gameboard = null
var ranks = {}
var suits = {}


func set_attributes(input_: Dictionary) -> void:
	gameboard = input_.gameboard
	
	capacity.current = 6
	capacity.limit = 10


func refill() -> void:
	gameboard.reshuffle_available()
	
	while cards.get_child_count() < capacity.current and gameboard.available.cards.get_child_count() > 0:
		var card = gameboard.pull_random_card()
		add_card(card)
	
	categorize_based_on_rank()


func add_card(card_: MarginContainer) -> void:
	cards.add_child(card_)
	var suit = card_.get_suit()
	var rank = card_.get_rank()
	#print([suit, rank])
	
	if !suits.has(suit):
		suits[suit] = 0
	
	if !ranks.has(rank):
		ranks[rank] = 0
	
	suits[suit] += 1
	ranks[rank] += 1


func refill_based_on_card_indexs(indexs_: Array) -> void:
	for index in indexs_:
		draw_indexed_card(index)


func draw_indexed_card(index_: int) -> void:
	var card = gameboard.pull_indexed_card(index_)
	add_card(card)


func apply() -> void:
	for card in cards.get_children():
		apply_card(card)


func apply_card(card_: MarginContainer) -> void:
	#for token in card_.tokens.get_children():
	#	var value = token.stack.get_number()
	#	gameboard.change_token_value(token.title.subtype, value)
	pass


func discard() -> void:
	while cards.get_child_count() > 0:
		var card = cards.get_child(0)
		discard_card(card)
	
	#print(gameboard.available.cards.get_child_count())


func discard_card(card_: MarginContainer) -> void:
	cards.remove_child(card_)
	#card_.charge.current -= 1
	var suit = card_.get_suit()
	var rank = card_.get_rank()
	suits[suit] -= 1
	ranks[rank] -= 1
	
	if suits[suit] == 0:
		suits.erase(suit)
	
	if ranks[rank] == 0:
		ranks.erase(rank)
	
	if card_.charge.current > 0:
		gameboard.available.cards.add_child(card_)
	else:
		gameboard.discharged.cards.add_child(card_)
		card_.area = gameboard.discharged


func get_all_kits() -> Dictionary:
	var kits = {}
	
	for kit in Global.arr.kit:
		var count = capacity.current
		
		if kit != "chaos":
			kits[kit] = call("get_kits_based_on_type_and_count", kit, count)
	
	return kits


func get_kits_based_on_type_and_count(type_: String, count_: int) -> Array:#args_: Array) -> Array:
	var kits = []
	var datas = {}
	datas[0] = []
	var options = cards.get_children()
	
	for option in options:
		datas[0].append([option])
	
	#var type = args_[0]
	#var count = args_[1]
	
	for _i in count_:
		datas[_i+1] = []
		
		for parents in datas[_i]:
			var childs = []
			
			for option in options:
				if !parents.has(option):
					var flag = call("validate_"+type_, parents, option)
					
					if flag:
						childs.append(option)
			
			for child in childs:
				var parents_ = [child]
				parents_.append_array(parents)
				parents_.sort_custom(func(a, b): return a.get_index_number() < b.get_index_number())
				
				if !datas[_i+1].has(parents_):
					datas[_i+1].append(parents_)
	
	for _i in datas:
		if _i > 0:
			kits.append_array(datas[_i])
#			for cards_ in datas[_i]:
#				print("___",_i+1)
#				for card in cards_:
#					print([card.get_suit(), card.get_rank()])
	
	return kits


func validate_unity(parents_: Array, child_: MarginContainer) -> bool:
	return parents_.front().get_suit() == child_.get_suit()


func validate_harmony(parents_: Array, child_: MarginContainer) -> bool:
	return parents_.front().get_rank() == child_.get_rank()


func validate_order(parents_: Array, child_: MarginContainer) -> bool:
	var rank = child_.get_rank()
	var ranks_ = []
	
	for parent in parents_:
		ranks_.append(parent.get_rank())
	
	if ranks_.has(rank):
		return false
	
	ranks_.sort()
	var first = ranks_.front() == rank + 1
	var last = ranks_.back() + 1 == rank
	
	if !first:
		first = rank == Global.arr.rank.back() and ranks_.front() == Global.arr.rank.front()
	
	if !last:
		last = rank == Global.arr.rank.front() and ranks_.back() == Global.arr.rank.back()
	
	return first or last


func categorize_based_on_suit() -> void:
	var datas = {}
	
	for suit in Global.arr.suit:
		datas[suit] = []
	
	while cards.get_child_count() > 0:
		var card = cards.get_child(0)
		cards.remove_child(card)
		datas[card.get_suit()].append(card)
	
	
	for suit in datas:
		datas[suit].sort_custom(func(a, b): return a.get_rank() < b.get_rank())
		
		for card in datas[suit]:
			cards.add_child(card)


func categorize_based_on_rank() -> void:
	var datas = {}
	
	for rank in Global.arr.rank:
		datas[rank] = []
	
	while cards.get_child_count() > 0:
		var card = cards.get_child(0)
		cards.remove_child(card)
		datas[card.get_rank()].append(card)
	
	
	for suit in datas:
		datas[suit].sort_custom(func(a, b): return Global.arr.suit.find(a.get_suit()) < Global.arr.suit.find(b.get_suit()))
		
		for card in datas[suit]:
			cards.add_child(card)


func check_all_kits() -> Array:
	var kits = []

	for kit in Global.arr.kit:
		if kit != "chaos":
			var _i = 1
			var parents = [cards.get_child(0)]
			var child = cards.get_child(_i)
			var flag = true
			
			while parents.size() < cards.get_child_count():
				flag = call("validate_"+kit, parents, child)
				
				if !flag:
					break
				
				parents.append(child)
				_i += 1
				
				if _i < cards.get_child_count():
					child = cards.get_child(_i)
				else:
					break
			
			if flag:
				kits.append(kit)

	if kits.is_empty():
		kits.append("chaos")

	return kits
