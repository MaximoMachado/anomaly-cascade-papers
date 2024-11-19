use super::faction::Faction;
use super::follower::Follower;
use flux::Flux;
use serde::{Deserialize, Serialize};

mod flux;

#[derive(Clone, Copy, Default, PartialEq, Eq, Debug, Serialize, Deserialize)]
enum Rarity {
    #[default]
    Common,
    Rare,
    Anomaly,
    Esoteric,
}

#[derive(Clone, Default, PartialEq, Eq, Debug, Serialize, Deserialize)]
struct Info {
    name: String,
    cost: Flux,
    rarity: Rarity,
}

#[derive(Clone, Default, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
enum Card {
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
