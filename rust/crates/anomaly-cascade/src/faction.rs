use serde::{Deserialize, Serialize};

#[derive(Clone, Copy, Default, PartialEq, Eq, Debug, Serialize, Deserialize)]
pub enum Faction {
    Foundation,
    Gilded,
    Veil,
    Abyssal,
    Fey,
    Clockwork,
    #[default]
    Neutral,
}

#[derive(Clone, Copy, PartialEq, Eq, Debug, Serialize, Deserialize)]
pub enum Color {
    Blue,
    Red,
    White,
    Purple,
    Green,
    Orange,
    Gray,
}

impl From<Color> for Faction {
    fn from(value: Color) -> Self {
        match value {
            Color::Blue => Self::Foundation,
            Color::Red => Self::Gilded,
            Color::White => Self::Veil,
            Color::Purple => Self::Abyssal,
            Color::Green => Self::Fey,
            Color::Orange => Self::Clockwork,
            Color::Gray => Self::Neutral,
        }
    }
}

impl From<Faction> for Color {
    fn from(value: Faction) -> Self {
        match value {
            Faction::Foundation => Self::Blue,
            Faction::Gilded => Self::Red,
            Faction::Veil => Self::White,
            Faction::Abyssal => Self::Purple,
            Faction::Fey => Self::Green,
            Faction::Clockwork => Self::Orange,
            Faction::Neutral => Self::Gray,
        }
    }
}
