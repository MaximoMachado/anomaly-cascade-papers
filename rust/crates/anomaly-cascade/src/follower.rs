use super::effect::Effect;

struct Stats {
    attack: i64,
    influence: i64,
    health: i64,
    max_health: i64,
}
pub struct Follower {
    name: String,
    stats: Stats,
    classification: Vec<Classification>,
    effects: Vec<Box<dyn Effect>>,
}

enum Classification {
    Machine,
    Fairy,
    Beast,
}
