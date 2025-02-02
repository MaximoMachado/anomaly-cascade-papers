use crate::follower;
use serde::{Deserialize, Serialize};
use std::collections::VecDeque;

#[derive(Clone, Default, PartialEq, Eq, Hash, Debug, Serialize, Deserialize)]
pub struct RoundManager {
    current_round: Vec<follower::Id>,
    next_round: Vec<follower::Id>,
}

impl RoundManager {
    fn new() -> RoundManager {
        RoundManager::default()
    }

    fn start_new_round(&mut self) {
        self.current_round = self.next_round.clone();
        self.next_round = vec![];
    }

    fn push_front(&mut self, id: follower::Id) {
        self.current_round.insert(0, id);
    }

    fn push_back(&mut self, id: follower::Id) {
        self.current_round.push(id);
    }

    fn remove(&mut self, id: follower::Id) -> Option<usize> {
        let found = self.current_round.iter().position(|el| *el == id);
        match found {
            Some(position) => {
                self.current_round.remove(position);
                Some(position)
            }
            None => {
                let found = self.next_round.iter().position(|el| *el == id);
                match found {
                    Some(position) => {
                        self.next_round.remove(position);
                        Some(position)
                    }
                    None => None,
                }
            }
        }
    }

    fn next(&mut self) -> Option<follower::Id> {
        let follower = self.current_round.pop()?;
        self.next_round.push(follower);

        Some(follower)
    }

    fn round_over(&self) -> bool {
        self.current_round.is_empty()
    }
}

impl IntoIterator for RoundManager {
    type Item = follower::Id;
    type IntoIter = std::vec::IntoIter<Self::Item>;

    fn into_iter(self) -> Self::IntoIter {
        self.current_round.into_iter()
    }
}

impl<'a> IntoIterator for &'a RoundManager {
    type Item = &'a follower::Id;
    type IntoIter = std::slice::Iter<'a, follower::Id>;

    fn into_iter(self) -> Self::IntoIter {
        self.current_round.iter()
    }
}

impl<'a> IntoIterator for &'a mut RoundManager {
    type Item = &'a mut follower::Id;
    type IntoIter = std::slice::IterMut<'a, follower::Id>;

    fn into_iter(self) -> Self::IntoIter {
        self.current_round.iter_mut()
    }
}
