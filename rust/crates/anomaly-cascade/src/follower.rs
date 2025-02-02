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
    Beast,
    Vampire,
    Undead,
    Elemental,
    Researcher,
    Military,
    Occult,
    Infohazard,
}

slotmap::new_key_type! { pub struct Id; }

#[derive(Clone, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
pub struct Follower {
    id: Id,
    stats: Stats,
    classification: Vec<Classification>,
    abilities: Vec<()>,
}

impl Follower {
    fn attack(&mut self, follower: &mut Follower) {
        todo!()
    }
    fn influence(&mut self) {
        todo!()
    }
    fn recieve_damage(&mut self) {
        todo!()
    }
    fn deal_damage(&mut self, follower: &mut Follower) {
        todo!()
    }
}
