use crate::permanent::Follower;
use serde::{Deserialize, Serialize};

pub mod flux;
pub use flux::Flux;

#[derive(Clone, Copy, Default, PartialEq, Eq, Debug, Serialize, Deserialize)]
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

#[derive(Clone, Default, PartialEq, Eq, Debug, Serialize, Deserialize)]
struct Info {
    name: String,
    cost: Flux,
    rarity: Rarity,
}

#[derive(Clone, Default, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
pub enum Card {
    #[default]
    Hidden,
    Factory {},
    Catalyst {},
    Follower {
        follower: Follower,
    },
}

impl Card {}

#[cfg(test)]
mod tests {}
