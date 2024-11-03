require 'squib'

data = Squib.csv file: 'cards.csv'

def default_if_empty(value, default)
    return value.map{ |x| x != "" ? x : default }
end

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

Squib::Deck.new(width: 825, height: 1125, cards: data['name'].size, layout: 'card.yml') do
  background color: 'white'
  set font: 'Times New Roman,Serif 10.5'
  hint text: '#333' # show extents of text boxes to demo the layout

  text str: data['name'],       layout: :title
  text str: data['flux'],       layout: :title_right
  text str: "art",       layout: :art
  svg file: default_if_empty(data['art'], "images/lab-coat.svg"),        layout: :art
  text str: combine_text(data['type'], data['class'], ' - '),       layout: :type
  text str: data['desc'],       layout: :description
  text str: data['attack'],     layout: :lower_right
  text str: data['influence'],     layout: :lower_middle
  text str: data['health'],     layout: :lower_left
  save_png prefix: data['name'].map{ |n| 'wsf_' + n.downcase }
end