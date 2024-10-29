extends GutTest


class TestStartingHand extends GutTest:
	const DECK_STARTING_SIZE = 20
	var test_cards : Array[Card] = []
	var deck: Deck

	func before_all():
		for i in range(DECK_STARTING_SIZE):
			var card: Card
			if i % 2:
				card = HiddenCard.new()
			elif i % 3:
				card = Factory.new()
			else:
				card = Follower.new(str(i), str(i), FollowerStats.new(1, 1, 1))

			test_cards.append(card)

	func before_each():
		deck = Deck.new(test_cards.duplicate(), false)
		

	func test_default():
		const num_cards := 7
		const requested_num_factories := 0
		var starting_deck : Array[Card] = deck.cards

		var starting_hand = deck.starting_hand(num_cards, requested_num_factories)
		if DECK_STARTING_SIZE > num_cards:
			assert_eq(starting_hand.size(), num_cards)

		for card: Card in starting_hand:
			assert_ne(starting_deck.find(card), -1, "All cards in hand should be found in starting deck")
			assert_eq(deck.cards.find(card), -1, "All cards in hand should not be found in current deck")
		

	func test_multiple_calls():
		for i in range(3):
			var num_cards := 5 + i
			const requested_num_factories = 2
			var starting_deck : Array[Card] = deck.cards

			var num_factories := 0
			for card in starting_deck:
				if card is Factory:
					num_factories += 1

			var starting_hand : Array[Card] = deck.starting_hand(num_cards, requested_num_factories)
			if DECK_STARTING_SIZE > num_cards:
				assert_eq(starting_hand.size(), num_cards)

			if num_factories >= requested_num_factories:
				var factories_in_hand := 0
				for card in starting_hand:
					if card is Factory:
						factories_in_hand += 1
				assert_eq(factories_in_hand, requested_num_factories)

			for card: Card in starting_hand:
				assert_ne(starting_deck.find(card), -1, "All cards in hand should be found in starting deck")
				assert_eq(deck.cards.find(card), -1, "All cards in hand should not be found in current deck")

	func test_with_factories():
		pending()

	func test_deck_almost_empty():
		pending()

	func test_no_cards():
		pending()

class TestDrawCards extends GutTest:
	func test_default():
		pending()

	func test_multiple_calls():
		pending()

	func test_no_cards():
		pending()

class TestShuffle extends GutTest:
	func test_shuffle_on():
		pending()

	func test_shuffle_off():
		pending()

class TestArrayFunctions extends GutTest:
	func test_iterator():
		pending()

	func test_shallow_duplication():
		pending()
