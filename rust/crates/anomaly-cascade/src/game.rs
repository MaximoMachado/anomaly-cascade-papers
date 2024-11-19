use crate::card::Card;
use crate::collection::{Collection, Deck, COMPLETE_COLLECTION};
use crate::effect::Effect;
use crate::permanent::{Factory, Follower};
use serde::{Deserialize, Serialize};

#[derive(Clone, Copy, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
pub enum GameError {}

/// Represents the possible moves a player can make during the game
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
    Undeclare { follower: Follower },
}

#[derive(Clone, Copy, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
pub enum Phase {
    Mulligan,
    Play,
    Attack,
    Block,
    Reaction,
}

#[derive(Copy, Clone, PartialEq, Default, Eq, Hash, Debug, Serialize, Deserialize)]
pub struct PlayerId(u64);

#[derive(Copy, Clone, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
pub struct TeamId(u64);

#[derive(Clone, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
pub struct Player {
    pub id: PlayerId,
    pub team_id: PlayerId,
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
pub struct Game {
    phase: Phase,
    players: Vec<Player>,
    battles: Vec<Battle>,
    collection: Collection,
}

impl Game {
    fn new() -> Game {
        Game {
            phase: Phase::Mulligan,
            players: vec![],
            battles: vec![],
            collection: COMPLETE_COLLECTION.clone(),
        }
    }

    fn play_move(&mut self) -> Result<(), GameError> {
        todo!()
    }

    fn current_player(&self) -> &Player {
        todo!()
    }

    fn winner(&self) -> Option<&Player> {
        todo!()
    }
}

#[derive(Clone, PartialEq, Eq, Hash, Debug, Serialize)]
pub struct Battle {
    attacking: Vec<Follower>,
    blocking: Vec<Follower>,
    target: Player,
}
