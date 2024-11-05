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
  text(str: data['flux'], layout: :title_right) do | embed |
    embed.svg key: ':B:', dy: -40, width: 50, height: 50, file: 'images/flux_icons/foundation.svg'
    embed.svg key: ':R:', dy: -40, width: 50, height: 50, file: 'images/flux_icons/gilded.svg'
    embed.svg key: ':W:', dy: -40, width: 50, height: 50, file: 'images/flux_icons/veil_walkers.svg'
    embed.svg key: ':G:', dy: -40, width: 50, height: 50, file: 'images/flux_icons/fey.svg'
    embed.svg key: ':P:', dy: -40, width: 50, height: 50, file: 'images/flux_icons/abyssal.svg'
    embed.svg key: ':O:', dy: -40, width: 50, height: 50, file: 'images/flux_icons/clockwork.svg'
    embed.svg key: ':N:', dy: -40, width: 50, height: 50, file: 'images/flux_icons/neutral.svg'
    embed.svg key: ':#N:', dy: -40, width: 50, height: 50, file: 'images/flux_icons/neutral_blank.svg'
  end

  svg file: data['art'], placeholder: "images/flux_icons/neutral_blank.svg", layout: :art
  text str: combine_text(data['type'], data['class'], ' - '), layout: :type
  text str: data['speed'], layout: :type_right
  text(str: data['desc'], layout: :description) do | embed |
    embed.svg key: ':exhaust:', dy: -50, width: 75, height: 75, file: 'images/icons/exhaust.svg'
    embed.svg key: ':B:', dy: -50, width: 75, height: 75, file: 'images/flux_icons/foundation.svg'
    embed.svg key: ':R:', dy: -50, width: 75, height: 75, file: 'images/flux_icons/gilded.svg'
    embed.svg key: ':W:', dy: -50, width: 75, height: 75, file: 'images/flux_icons/veil_walkers.svg'
    embed.svg key: ':G:', dy: -50, width: 75, height: 75, file: 'images/flux_icons/fey.svg'
    embed.svg key: ':P:', dy: -50, width: 75, height: 75, file: 'images/flux_icons/abyssal.svg'
    embed.svg key: ':O:', dy: -50, width: 75, height: 75, file: 'images/flux_icons/clockwork.svg'
    embed.svg key: ':N:', dy: -50, width: 75, height: 75, file: 'images/flux_icons/neutral.svg'
    embed.svg key: ':#N:', dy: -50, width: 75, height: 75, file: 'images/flux_icons/neutral_blank.svg'
  end

  text str: data['attack'], layout: :attack
  text str: data['influence'], layout: :influence
  text str: data['health'], layout: :health
  save_png prefix: data['name'].map{ |n| 'wsf_' + n.downcase }, count_format: ""
end