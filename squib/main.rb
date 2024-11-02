require 'squib'

data = Squib.csv file: 'cards.csv'

Squib::Deck.new(width: 825, height: 1125, cards: data['name'].size) do
  background color: 'purple'
  text str: ['Hello', 'World!']
  save_png prefix: 'wsf_'
end