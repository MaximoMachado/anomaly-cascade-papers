use super::speed::Speed;
use serde::{Deserialize, Serialize};

#[derive(Clone, Default, Copy, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
pub enum Effect {
    #[default]
    Empty,
}

trait StackEffect: Clone {
    fn speed(&self) -> Speed;
    fn targets(&self) -> bool;
    fn can_resolve(&self) -> bool;
    fn resolve(&mut self) -> bool;
}

#[cfg(test)]
mod tests {}
