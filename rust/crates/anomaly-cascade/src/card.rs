use crate::permanent::Follower;
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
pub struct CardId(u64);

#[derive(Clone, PartialEq, Eq, Hash, Debug, Serialize)]
struct Info<'a> {
    id: CardId,
    base_card: &'a Card<'a>,
    name: String,
    cost: Flux,
    rarity: Rarity,
}

#[derive(Clone, Default, PartialEq, Eq, Hash, Debug, Serialize)]
pub enum Card<'a> {
    #[default]
    Hidden,
    Factory {
        info: Info<'a>,
    },
    Catalyst {},
    Follower {
        follower: Follower,
    },
}

impl<'a> Card<'a> {}

#[cfg(test)]
mod tests {}
