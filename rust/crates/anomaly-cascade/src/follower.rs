use super::effect::Effect;
use serde::{Deserialize, Serialize};

#[derive(Clone, Copy, PartialEq, Eq, Hash, Default, Debug, Serialize, Deserialize)]
struct Stats {
    attack: i64,
    influence: i64,
    health: i64,
    max_health: i64,
}

#[derive(Clone, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
pub struct Follower {
    stats: Stats,
    classification: Vec<Classification>,
    effects: Vec<Effect>,
}

#[derive(Clone, Copy, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
enum Classification {
    Machine,
    Fairy,
    Beast,
}
