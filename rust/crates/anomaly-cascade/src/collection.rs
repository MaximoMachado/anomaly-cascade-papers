use crate::card::Card;
use serde::{Deserialize, Serialize};

/// Represents a collection of cards that is unordered
/// e.g. The complete collection of cards, singular
/// Allows efficient querying of cards for use in-game and during deck-building
#[derive(Clone, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
pub struct Collection {}

impl Collection {
    fn new() -> Collection {
        Collection {}
    }

    fn cards(&self) -> impl Iterator<Item = Card> {
        todo!();
        vec![].into_iter()
    }

    fn filter(&self) -> Collection {
        todo!()
    }
}
const fn make_complete_collection() -> Collection {
    Collection {}
}

pub const COMPLETE_COLLECTION: Collection = make_complete_collection();

pub mod deck {
    use serde::{Deserialize, Serialize};

    #[derive(Copy, Clone, PartialEq, Default, Eq, Hash, Debug, Serialize, Deserialize)]
    pub struct Id(u64);

    /// Represents a deck of cards that can be ordered
    #[derive(Clone, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
    pub struct Deck {
        id: Id,
    }
}
