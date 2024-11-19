use crate::card::Speed;
use serde::{Deserialize, Serialize};

#[derive(Clone, Default, Copy, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
pub enum Action {
    #[default]
    Empty,
}

#[derive(Clone, Default, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
pub struct Effect {
    source: Target,
    dest: Target,
    action: Action,
}

#[derive(Clone, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
enum Target {
    Definite(/* Specific targetable entity */),
    Indefinite {
        name: Option<String>,
        filter: i64, /* Fn */
    },
}

impl Default for Target {
    fn default() -> Self {
        Self::Indefinite {
            name: None,
            filter: 0,
        }
    }
}

trait StackEffect: Clone {
    fn speed(&self) -> Speed;
    fn targets(&self) -> bool;
    fn can_resolve(&self) -> bool;
    fn resolve(&mut self) -> bool;
}

#[cfg(test)]
mod tests {}
