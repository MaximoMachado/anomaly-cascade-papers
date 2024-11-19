use crate::effect::Effect;
use crate::game::GameError;
use serde::{Deserialize, Serialize};

#[derive(Clone, Copy, PartialEq, Eq, Hash, Default, Debug, Serialize, Deserialize)]
struct Stats {
    attack: i64,
    influence: i64,
    health: i64,
    max_health: i64,
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

#[derive(Clone, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
pub struct Follower {
    readiness: Status,
    stats: Stats,
    classification: Vec<Classification>,
    abilities: Vec<Effect>,
}

impl Follower {
    fn attack(&mut self) -> Result<i64, GameError> {
        todo!()
    }
    fn influence(&mut self) -> Result<i64, GameError> {
        todo!()
    }
    fn block(&mut self) -> Result<i64, GameError> {
        todo!()
    }
    fn recieve_damage(&mut self) -> i64 {
        todo!()
    }
    fn deal_damage(&mut self) -> i64 {
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
    readiness: Status,
    basic: FactoryType,
    abilities: Vec<Effect>,
}

trait Permanent: Clone {
    fn abilities(&self) -> impl Iterator<Item = Effect>;
    fn activate_ability(&mut self) -> Result<Effect, GameError>;
}
