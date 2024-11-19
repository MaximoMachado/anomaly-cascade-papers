use super::effect::Effect;

enum GameError {}

struct Player {}

struct Collection {}

struct Game {}

trait Permanent: Clone {
    fn attack(&mut self) -> Result<i64, GameError>;
    fn influence(&mut self) -> Result<i64, GameError>;
    fn block(&mut self) -> Result<i64, GameError>;
    fn abilities(&self) -> impl Iterator<Item = Effect>;
    fn activate_ability(&mut self) -> Result<Effect, GameError>;
}

trait Health: Clone {
    fn recieve_damage(&mut self) -> i64;
}

trait Damage: Clone {
    fn deal_damage(&mut self) -> i64;
}
