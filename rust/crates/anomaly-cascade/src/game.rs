use crate::follower;
use crate::follower::Follower;
use crate::round_manager::RoundManager;
use itertools;
use player::Player;
use serde::{Deserialize, Serialize};
use slotmap;
use slotmap::SlotMap;
use std::hash::{Hash, Hasher};

#[derive(Copy, Clone, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
pub struct Position {
    row: i64,
    col: i64,
}
#[derive(Clone, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
struct Card {}

#[derive(Clone, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
struct Deck {
    cards: Vec<Card>,
}

/// Represents the possible moves a player can make during the game
#[derive(Clone, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
pub enum Move {
    EndTurn,
    PlayCard {
        card: Card,
    },
    Move {
        start_pos: Position,
        end_pos: Position,
    },
    Attack {
        start_pos: Position,
        end_pos: Position,
    },
    Influence {
        position: Position,
    },
}

#[derive(Clone, Copy, Default, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
pub enum Phase {
    #[default]
    Mulligan,
    RoundStart,
    PlayCard,
    FollowerAction,
    RoundEnd,
}

pub mod player {
    use super::*;
    use serde::{Deserialize, Serialize};

    slotmap::new_key_type! { pub struct Id; }
    slotmap::new_key_type! { pub struct TeamId; }

    #[derive(Clone, Default, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
    pub struct Player {
        pub id: Id,
        pub team_id: TeamId,
        // pub hand: Vec<Card>,
        // pub deck: Deck,
        // pub graveyard: Deck,
        pub followers: Vec<follower::Id>,
        pub num_factories: i64,
        pub influence: i64,
        pub control_points: i64,
    }
}

#[derive(Clone, Default, Copy, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
enum Authority {
    #[default]
    Server,
    Client,
}

#[derive(Clone, Default, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
struct Board {
    rows: i64,
    cols: i64,
    board: Vec<Option<follower::Id>>,
}

#[derive(Clone, Copy, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
pub enum Error {}

#[derive(Clone, Default, Debug, Serialize, Deserialize)]
pub struct GameState {
    /// Whether the game state acts in server-mode (complete information) or client-mode (hidden information)
    authority: Authority,
    phase: Phase,
    players: SlotMap<player::Id, Player>,
    followers: SlotMap<follower::Id, Follower>,
    round_manager: RoundManager,
    board: Board,
}

impl PartialEq for GameState {
    fn eq(&self, other: &Self) -> bool {
        self.phase == other.phase
            && itertools::equal(self.players.iter(), other.players.iter())
            && itertools::equal(self.followers.iter(), other.followers.iter())
    }
}

impl Eq for GameState {}

impl Hash for GameState {
    fn hash<H: Hasher>(&self, state: &mut H) {
        self.authority.hash(state);
        self.phase.hash(state);
        {
            self.players.iter().for_each(|(k, v)| {
                k.hash(state);
                v.hash(state);
            });
            self.followers.iter().for_each(|(k, v)| {
                k.hash(state);
                v.hash(state);
            });
        }
    }
}

impl GameState {
    fn new() -> GameState {
        GameState::default()
    }

    fn play_move(&mut self, mv: Move) -> Result<(), Error> {
        match mv {
            Move::EndTurn => todo!(),
            Move::PlayCard { card } => todo!(),
            Move::Attack { start_pos, end_pos } => todo!(),
            Move::Move { start_pos, end_pos } => todo!(),
            Move::Influence { position } => todo!(),
        }
    }

    fn current_player(&self) -> &Player {
        todo!()
    }

    fn winner(&self) -> Option<&Player> {
        todo!()
    }
}
