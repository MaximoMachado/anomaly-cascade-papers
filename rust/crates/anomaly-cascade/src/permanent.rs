use crate::effect::Effect;
use crate::game::player;
use crate::game::player::Player;
use crate::game::{Damageable, Game, GameError, Targetable};
use serde::{Deserialize, Serialize};

#[derive(Clone, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
pub enum Permanent {
    Follower(follower::Id),
    Factory(factory::Id),
}

impl Permanent {
    fn abilities(&self) -> impl Iterator<Item = Effect> {
        todo!();
        vec![].into_iter()
    }
    fn activate_ability(&mut self) -> Result<Effect, GameError> {
        todo!();
    }
}

#[derive(Clone, Copy, Default, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
enum Status {
    #[default]
    DeploymentDelay,
    Exhaust,
    Ready,
}

pub mod follower {
    use super::Status;
    use crate::card;
    use crate::collection::deck;
    use crate::effect::Effect;
    use crate::game;
    use crate::game::player::Player;
    use crate::game::{Damageable, Game, GameError, Targetable};
    use serde::{Deserialize, Serialize};

    #[derive(Clone, Copy, PartialEq, Eq, Hash, Default, Debug, Serialize, Deserialize)]
    pub struct Stats {
        pub attack: i64,
        pub influence: i64,
        pub health: i64,
        pub max_health: i64,
    }

    #[derive(Clone, Copy, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
    enum Classification {
        Machine,
        Fairy,
        Animal,
        Vampire,
        Undead,
    }

    #[derive(Copy, Clone, PartialEq, Default, Eq, Hash, Debug, Serialize, Deserialize)]
    pub struct Id(u64);

    #[derive(Clone, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
    pub struct Follower {
        id: Id,
        readiness: Status,
        stats: Stats,
        classification: Vec<Classification>,
        abilities: Vec<Effect>,
    }

    impl Follower {
        fn attack(&mut self, game: &Game) -> Option<Effect> {
            todo!()
        }
        fn influence(&mut self, game: &Game) -> Option<Effect> {
            todo!()
        }
        fn block(&mut self, game: &Game) -> Option<Effect> {
            todo!()
        }
        fn recieve_damage(&mut self, source: &Follower) -> Option<Effect> {
            todo!()
        }
        fn deal_damage(&mut self, target: &Damageable) -> Option<Effect> {
            todo!()
        }
    }
}

pub mod factory {
    use super::Status;
    use crate::card;
    use crate::collection::deck;
    use crate::effect::Effect;
    use crate::game::player::Player;
    use crate::game::{Damageable, Game, GameError, Targetable};
    use serde::{Deserialize, Serialize};

    #[derive(Copy, Clone, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
    enum FactoryType {
        Basic,
        Factory,
    }
    #[derive(Copy, Clone, PartialEq, Default, Eq, Hash, Debug, Serialize, Deserialize)]
    pub struct Id(u64);

    #[derive(Clone, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
    pub struct Factory {
        id: Id,
        readiness: Status,
        basic: FactoryType,
        abilities: Vec<Effect>,
    }
}
