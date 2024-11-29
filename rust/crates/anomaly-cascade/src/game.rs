use crate::card;
use crate::card::Card;
use crate::collection::deck::Deck;
use crate::collection::{deck, Collection, COMPLETE_COLLECTION};
use crate::effect;
use crate::effect::Effect;
use crate::permanent::factory;
use crate::permanent::factory::Factory;
use crate::permanent::follower;
use crate::permanent::follower::Follower;
use itertools;
use player::Player;
use serde::{Deserialize, Serialize};
use slotmap;
use slotmap::SlotMap;

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
    Effect(effect::Id),
}

#[derive(Clone, PartialEq, Eq, Hash, Debug, Serialize)]
pub enum Activatable {
    Follower(follower::Id),
    Factory(factory::Id),
}

#[derive(Clone, Copy, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
pub enum Error {}

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

    slotmap::new_key_type! { pub struct Id; }
    slotmap::new_key_type! { pub struct TeamId; }

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

#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct GameState {
    phase: Phase,
    players: SlotMap<player::Id, Player>,
    followers: SlotMap<follower::Id, Follower>,
    factories: SlotMap<factory::Id, Factory>,
    battles: SlotMap<slotmap::DefaultKey, Battle>,
    collection: Collection,
}

impl PartialEq for GameState {
    fn eq(&self, other: &Self) -> bool {
        self.phase == other.phase
            && itertools::equal(self.battles.iter(), other.battles.iter())
            && itertools::equal(self.players.iter(), other.players.iter())
            && itertools::equal(self.followers.iter(), other.followers.iter())
            && itertools::equal(self.factories.iter(), other.factories.iter())
            && self.collection == other.collection
    }
}

impl Eq for GameState {}

impl GameState {
    fn new() -> GameState {
        GameState {
            phase: Phase::Mulligan,
            players: SlotMap::with_key(),
            followers: SlotMap::with_key(),
            factories: SlotMap::with_key(),
            battles: SlotMap::with_key(),
            collection: COMPLETE_COLLECTION.clone(),
        }
    }

    fn play_move(&mut self) -> Result<(), Error> {
        todo!()
    }

    fn current_player(&self) -> &Player {
        todo!()
    }

    fn winner(&self) -> Option<&Player> {
        todo!()
    }
}

#[derive(Clone, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
pub struct Battle {
    attacking: Vec<follower::Id>,
    blocking: Vec<follower::Id>,
    target: player::Id,
}
