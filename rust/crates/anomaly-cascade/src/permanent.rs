use crate::collection::Deck;
use crate::effect::Effect;
use crate::game::{Game, GameError, Player};
use serde::{Deserialize, Serialize};

#[derive(Clone, Copy, PartialEq, Eq, Hash, Default, Debug, Serialize, Deserialize)]
pub struct Stats {
    pub attack: i64,
    pub influence: i64,
    pub health: i64,
    pub max_health: i64,
}

#[derive(Clone, Copy, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
enum Classification {
    Machine,
    Fairy,
    Beast,
}

#[derive(Clone, Copy, Default, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
enum Status {
    #[default]
    DeploymentDelay,
    Exhaust,
    Ready,
}

#[derive(Copy, Clone, PartialEq, Default, Eq, Hash, Debug, Serialize, Deserialize)]
pub struct PermanentId(u64);

#[derive(Clone, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
pub struct Follower {
    id: PermanentId,
    readiness: Status,
    stats: Stats,
    classification: Vec<Classification>,
    abilities: Vec<Effect>,
}

#[derive(Clone, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
pub enum Damageable {
    Follower(Follower),
    Player(Player),
}

#[derive(Clone, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
pub enum Targetable {
    Follower(Follower),
    Factory(Factory),
    Player(Player),
    Deck(Deck),
}

#[derive(Clone, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
pub enum Activatable {
    Follower(Follower),
    Factory(Factory),
}

impl Follower {
    fn attack(&mut self, game: &Game) -> Option<Effect> {
        todo!()
    }
    fn influence(&mut self, game: &Game) -> Option<Effect> {
        todo!()
    }
    fn block(&mut self, game: &Game) -> Option<Effect> {
        todo!()
    }
    fn recieve_damage(&mut self, source: &Follower) -> Option<Effect> {
        todo!()
    }
    fn deal_damage(&mut self, target: &Damageable) -> Option<Effect> {
        todo!()
    }
}

#[derive(Copy, Clone, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
enum FactoryType {
    Basic,
    Factory,
}

#[derive(Clone, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
pub struct Factory {
    id: PermanentId,
    readiness: Status,
    basic: FactoryType,
    abilities: Vec<Effect>,
}

trait Permanent: Clone {
    fn abilities(&self) -> impl Iterator<Item = Effect>;
    fn activate_ability(&mut self) -> Result<Effect, GameError>;
}
