pub mod effect;
pub mod flux;

use flux::Flux;

struct CardInfo {
    name: String,
    cost: Flux,
}

enum Card {
    Factory {},
    Catalyst {},
    Follower { stats: Stats },
}

impl Card {}

#[derive(Clone, Copy, PartialEq, Eq, Debug)]
struct Stats {
    attack: i64,
    influence: i64,
    health: i64,
    max_health: i64,
}

#[derive(Clone, Copy, PartialEq, Eq, Debug)]
pub enum Faction {
    Foundation,
    Gilded,
    Veil,
    Abyssal,
    Fey,
    Clockwork,
    Neutral,
}

pub enum FactionColor {
    Blue,
    Red,
    White,
    Purple,
    Green,
    Orange,
    Grey,
}

impl Default for Faction {
    fn default() -> Self {
        Faction::Neutral
    }
}

#[cfg(test)]
mod tests {}
