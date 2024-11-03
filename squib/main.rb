require 'squib'

data = Squib.csv file: 'cards.csv'

def value_if_cond(value, condition)
    if condition then
        return value
    else
        return nil
    end
end

def combine_text(arr_1=[], arr_2=[], seperator="")
    return arr_1.zip(arr_2).map{ |type, classificaton| classificaton != "" ? type + seperator + classificaton : type}
end

def card_template(type)
    if type.include? "Follower"
        return "images/follower_card_template.svg"
    else
        return "images/card_template.svg"
    end
end

Squib::Deck.new(width: 825, height: 1125, cards: data['name'].size, layout: 'card.yml') do
  background color: 'white'
  set font: 'Times New Roman,Serif 10.5'

  svg file: data['type'].map{ |t| card_template(t) }, layout: :card
  text str: data['name'], layout: :title
  text str: data['flux'], layout: :title_right
  text str: "art", layout: :art
  svg file: data['art'], placeholder: "images/lab_coat.svg", layout: :art
  text str: combine_text(data['type'], data['class'], ' - '), layout: :type
  text str: data['desc'], layout: :description
  text str: data['attack'], layout: :attack
  text str: data['influence'], layout: :influence
  text str: data['health'], layout: :health
  save_png prefix: data['name'].map{ |n| 'wsf_' + n.downcase }
end