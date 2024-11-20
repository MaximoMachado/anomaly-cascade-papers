use crate::card;
use crate::card::Card;
use crate::collection::deck::Deck;
use crate::collection::{deck, Collection, COMPLETE_COLLECTION};
use crate::effect::{Effect, EffectId};
use crate::permanent::factory;
use crate::permanent::factory::Factory;
use crate::permanent::follower;
use crate::permanent::follower::Follower;
use player::Player;
use serde::{Deserialize, Serialize};

#[derive(Clone, PartialEq, Eq, Hash, Debug, Serialize)]
pub enum Damageable {
    Follower(follower::Id),
    Player(player::Id),
}

#[derive(Clone, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
pub enum Targetable {
    Follower(follower::Id),
    Factory(factory::Id),
    Player(player::Id),
    Deck(deck::Id),
    Card(card::Id),
    Effect(EffectId),
}

#[derive(Clone, PartialEq, Eq, Hash, Debug, Serialize)]
pub enum Activatable<'a> {
    Follower(&'a Follower),
    Factory(&'a Factory),
}

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

#[derive(Clone, Copy, Default, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
pub enum Phase {
    #[default]
    Mulligan,
    Play,
    Attack,
    Block,
    Reaction,
}

pub mod player {
    use super::*;
    use serde::{Deserialize, Serialize};

    #[derive(Copy, Clone, PartialEq, Default, Eq, Hash, Debug, Serialize, Deserialize)]
    pub struct Id(u64);

    #[derive(Copy, Clone, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
    pub struct TeamId(u64);

    #[derive(Clone, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
    pub struct Player {
        pub id: Id,
        pub team_id: TeamId,
        pub hand: Vec<Card>,
        pub deck: Deck,
        pub influence_deck: Deck,
        pub graveyard: Deck,
        pub followers: Vec<follower::Id>,
        pub factories: Vec<factory::Id>,
        pub health: i64,
        pub max_health: i64,
        pub influence: i64,
    }
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
    attacking: Vec<follower::Id>,
    blocking: Vec<follower::Id>,
    target: Player,
}
