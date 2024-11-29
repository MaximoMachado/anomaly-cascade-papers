use crate::card::Speed;
use crate::game::Targetable;
use serde::{Deserialize, Serialize};
use slotmap;

#[derive(Clone, Default, Copy, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
pub enum Action {
    #[default]
    Empty,
    ModifyFlux,
    ModifyFollower,
    DrawCards,
    Manifest,
    DiscardCards,
    DealDamage,
}

slotmap::new_key_type! { pub struct Id; }

/// An effect is made up of a cost and an action
/// If the cost can be paid, the effect goes onto the stack and the action is queued to resolve
/// When the action resolves, it will attempt to perform its action
#[derive(Clone, Default, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
pub struct Effect {
    id: Id,
    source: Target,
    dest: Target,
    cost: Action,
    action: Action,
}

#[derive(Clone, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
enum Target {
    Definite(Targetable),
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
