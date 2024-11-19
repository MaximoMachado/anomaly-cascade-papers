use crate::card::Card;
use crate::collection::{Collection, Deck, COMPLETE_COLLECTION};
use crate::effect::Effect;
use crate::permanent::{Factory, Follower};
use serde::{Deserialize, Serialize};

#[derive(Clone, Copy, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
pub enum GameError {}

#[derive(Clone, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
pub enum Move {
    EndTurn,
    PlayCard { card: Card },
    Choose { card: Card },
    Select { cards: Vec<Card> },
    Activate { ability: Effect },
    DeclareAttacker { attacker: Follower },
    DeclareInfluencer { influencer: Follower },
    DeclareBlocker { blocker: Follower },
}

#[derive(Clone, Copy, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
pub enum Phase {
    Mulligan,
    Play,
    DeclareAttacker,
    DeclareBlocker,
    Reaction,
}

#[derive(Clone, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
pub struct Player {
    pub hand: Vec<Card>,
    pub deck: Deck,
    pub influence_deck: Deck,
    pub graveyard: Deck,
    pub followers: Vec<Follower>,
    pub factories: Vec<Factory>,
    pub health: i64,
    pub max_health: i64,
    pub influence: i64,
}

#[derive(Clone, PartialEq, Eq, Hash, Debug, Serialize)]
pub struct Game<'a> {
    players: Vec<Player>,
    battles: Vec<Battle<'a>>,
    collection: Collection,
}

impl<'a> Game<'a> {
    fn new() -> Game<'a> {
        Game {
            players: vec![],
            battles: vec![],
            collection: COMPLETE_COLLECTION.clone(),
        }
    }
}

#[derive(Clone, PartialEq, Eq, Hash, Debug, Serialize)]
struct Battle<'a> {
    attacking: Vec<&'a Follower>,
    blocking: Vec<&'a Follower>,
    target: &'a Player,
}
