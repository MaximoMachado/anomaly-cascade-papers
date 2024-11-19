use crate::card::Card;
use crate::collection::{Collection, Deck, COMPLETE_COLLECTION};
use crate::effect::Effect;
use crate::permanent::{Factory, Follower};
use serde::{Deserialize, Serialize};

#[derive(Clone, Copy, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
pub enum GameError {}

/// Represents the possible moves a player can make during the game
#[derive(Clone, PartialEq, Eq, Hash, Debug, Serialize)]
pub enum Move<'a> {
    EndTurn,
    PlayCard { card: Card<'a> },
    Choose { card: Card<'a> },
    Select { cards: Vec<Card<'a>> },
    Activate { ability: Effect },
    DeclareAttacker { attacker: Follower },
    DeclareInfluencer { influencer: Follower },
    DeclareBlocker { blocker: Follower },
    Undeclare { follower: Follower },
}

#[derive(Clone, Copy, Default, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
pub enum Phase {
    #[default]
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

#[derive(Clone, PartialEq, Eq, Hash, Debug, Serialize)]
pub struct Player<'a> {
    pub id: PlayerId,
    pub team_id: TeamId,
    pub hand: Vec<Card<'a>>,
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
    phase: Phase,
    players: Vec<Player<'a>>,
    battles: Vec<Battle<'a>>,
    collection: Collection,
}

impl<'a> Game<'a> {
    fn new() -> Game<'a> {
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
pub struct Battle<'a> {
    attacking: Vec<&'a Follower>,
    blocking: Vec<&'a Follower>,
    target: &'a Player<'a>,
}
