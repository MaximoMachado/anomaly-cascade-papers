use serde::{Deserialize, Serialize};

#[derive(Clone, Default, Copy, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
pub enum Speed {
    #[default]
    Slow,
    Fast,
    Reaction,
    Blink,
}
