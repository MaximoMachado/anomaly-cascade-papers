mod flux;

use super::faction::Faction;
use super::follower::Follower;
use flux::Flux;

struct CardInfo {
    name: String,
    cost: Flux,
}

enum Card {
    Factory {},
    Catalyst {},
    Follower { follower: Follower },
}

impl Card {}

impl Default for Faction {
    fn default() -> Self {
        Faction::Neutral
    }
}

#[cfg(test)]
mod tests {}
