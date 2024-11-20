use crate::effect::Effect;
use crate::permanent::{factory::Factory, follower::Follower};
use serde::{Deserialize, Serialize};

pub mod flux;
pub use flux::Flux;

#[derive(Clone, Copy, Default, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
enum Rarity {
    #[default]
    Common,
    Rare,
    Esoteric,
}

#[derive(Clone, Default, Copy, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
pub enum Speed {
    #[default]
    Slow,
    Fast,
    Reaction,
    Blink,
}

#[derive(Copy, Clone, PartialEq, Default, Eq, Hash, Debug, Serialize, Deserialize)]
pub struct Id(u64);

#[derive(Clone, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
pub struct Info {
    id: Id,
    base_card: Id,
    name: String,
    cost: Flux,
    rarity: Rarity,
    on_play: Effect,
}

#[derive(Clone, Default, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
pub enum Card {
    #[default]
    Hidden,
    Factory {
        info: Info,
        factory: Factory,
    },
    Catalyst {
        info: Info,
    },
    Follower {
        info: Info,
        follower: Follower,
    },
}

impl Card {}

#[cfg(test)]
mod tests {}
