use crate::follower;
use serde::{Deserialize, Serialize};

#[derive(Clone, Default, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
pub struct RoundManager {
    follower_order: Vec<follower::Id>,
    current_position: usize,
}

impl RoundManager {
    fn new() -> RoundManager {
        RoundManager::default()
    }

    fn start_new_round(&mut self) {
        self.current_position = 0;
    }

    fn add_to_front(&mut self, id: follower::Id) {
        self.follower_order.insert(0, id);
    }

    fn add_to_back(&mut self, id: follower::Id) {
        self.follower_order.push(id);
    }

    fn remove(&mut self, id: follower::Id) -> Option<usize> {
        let found = self.follower_order.iter().position(|el| *el == id);
        match found {
            Some(position) => {
                if position <= self.current_position {
                    self.current_position -= 1;
                }
                self.follower_order.remove(position);
                Some(position)
            }
            None => None,
        }
    }

    fn current(&self) -> Option<follower::Id> {
        let curr_follower = self.follower_order.get(self.current_position);
        match curr_follower {
            Some(id) => Some(*id),
            None => None,
        }
    }

    fn next(&mut self) -> Option<follower::Id> {
        let curr_follower = self.follower_order.get(self.current_position);
        match curr_follower {
            Some(id) => Some(*id),
            None => None,
        }
    }

    fn round_over(&self) -> bool {
        self.current_position == self.follower_order.len()
    }
}

impl IntoIterator for RoundManager {
    type Item = follower::Id;
    type IntoIter = std::vec::IntoIter<Self::Item>;

    fn into_iter(self) -> Self::IntoIter {
        self.follower_order.into_iter()
    }
}

impl<'a> IntoIterator for &'a RoundManager {
    type Item = &'a follower::Id;
    type IntoIter = std::slice::Iter<'a, follower::Id>;

    fn into_iter(self) -> Self::IntoIter {
        self.follower_order.iter()
    }
}

impl<'a> IntoIterator for &'a mut RoundManager {
    type Item = &'a mut follower::Id;
    type IntoIter = std::slice::IterMut<'a, follower::Id>;

    fn into_iter(self) -> Self::IntoIter {
        self.follower_order.iter_mut()
    }
}
