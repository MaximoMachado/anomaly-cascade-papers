use super::Faction;
use serde::{Deserialize, Serialize};
use std::cmp::PartialOrd;
use std::ops::{Add, Sub};

#[derive(Clone, Copy, PartialEq, Eq, Hash, Default, Debug, Serialize, Deserialize)]
pub struct Flux {
    pub foundation: i64,
    pub gilded: i64,
    pub veil: i64,
    pub abyssal: i64,
    pub fey: i64,
    pub clockwork: i64,
    pub neutral: i64,
}

impl Flux {
    /// Constructs an empty Flux
    pub fn new() -> Flux {
        Flux::default()
    }

    /// Returns whether or not this could pay for flux_cost
    pub fn can_pay(self, flux_cost: Self) -> bool {
        self.pay(flux_cost).is_some()
    }

    /// Pays for a cost if possible and returns the leftover amount
    /// Any flux can pay for the neutral flux cost but only the
    /// self and flux_cost must hold non-negative values to be successful
    pub fn pay(self, flux_cost: Self) -> Option<Flux> {
        use std::cmp::Ordering;

        if self.into_iter().any(|(_, value)| value < 0)
            || flux_cost.into_iter().any(|(_, value)| value < 0)
        {
            return None;
        }

        match self.partial_cmp(&flux_cost) {
            Some(Ordering::Equal) | Some(Ordering::Greater) => Some(self - flux_cost),
            Some(Ordering::Less) => None,
            None => {
                // Remainder flux is not strictly greater so we must see if any faction flux can pay for the neutral mana
                let mut remainder = self - flux_cost;

                // Early escape if any of the non-neutral flux is negative. This means we can't afford to pay
                if remainder
                    .into_iter()
                    .any(|(faction, value)| faction != Faction::Neutral && value < 0)
                {
                    return None;
                }

                for _ in 0..remainder.foundation {
                    remainder.neutral += 1;
                    remainder.foundation -= 1;
                    if remainder.neutral == 0 {
                        return Some(remainder);
                    }
                }

                for _ in 0..remainder.gilded {
                    remainder.neutral += 1;
                    remainder.gilded -= 1;
                    if remainder.neutral == 0 {
                        return Some(remainder);
                    }
                }

                for _ in 0..remainder.veil {
                    remainder.neutral += 1;
                    remainder.veil -= 1;
                    if remainder.neutral == 0 {
                        return Some(remainder);
                    }
                }

                for _ in 0..remainder.abyssal {
                    remainder.neutral += 1;
                    remainder.abyssal -= 1;
                    if remainder.neutral == 0 {
                        return Some(remainder);
                    }
                }

                for _ in 0..remainder.fey {
                    remainder.neutral += 1;
                    remainder.fey -= 1;
                    if remainder.neutral == 0 {
                        return Some(remainder);
                    }
                }

                for _ in 0..remainder.clockwork {
                    remainder.neutral += 1;
                    remainder.clockwork -= 1;
                    if remainder.neutral == 0 {
                        return Some(remainder);
                    }
                }

                None
            }
        }
    }
}

impl IntoIterator for Flux {
    type Item = (Faction, i64);
    type IntoIter = std::vec::IntoIter<Self::Item>;

    fn into_iter(self) -> Self::IntoIter {
        vec![
            (Faction::Foundation, self.foundation),
            (Faction::Gilded, self.gilded),
            (Faction::Veil, self.veil),
            (Faction::Abyssal, self.abyssal),
            (Faction::Fey, self.fey),
            (Faction::Clockwork, self.clockwork),
            (Faction::Neutral, self.neutral),
        ]
        .into_iter()
    }
}

impl Add for Flux {
    type Output = Flux;

    fn add(self, rhs: Self) -> Self::Output {
        Self {
            foundation: self.foundation + rhs.foundation,
            gilded: self.gilded + rhs.gilded,
            veil: self.veil + rhs.veil,
            abyssal: self.abyssal + rhs.abyssal,
            fey: self.fey + rhs.fey,
            clockwork: self.clockwork + rhs.clockwork,
            neutral: self.neutral + rhs.neutral,
        }
    }
}
impl Sub for Flux {
    type Output = Flux;

    fn sub(self, rhs: Self) -> Self::Output {
        Self {
            foundation: self.foundation - rhs.foundation,
            gilded: self.gilded - rhs.gilded,
            veil: self.veil - rhs.veil,
            abyssal: self.abyssal - rhs.abyssal,
            fey: self.fey - rhs.fey,
            clockwork: self.clockwork - rhs.clockwork,
            neutral: self.neutral - rhs.neutral,
        }
    }
}

impl PartialOrd for Flux {
    fn partial_cmp(&self, other: &Self) -> Option<std::cmp::Ordering> {
        use std::cmp::Ordering;
        use std::iter::zip;

        let fields = zip(self.into_iter(), other.into_iter());

        if self == other {
            Some(Ordering::Equal)
        } else if fields.clone().all(|((_, v1), (_, v2))| v1 >= v2) {
            Some(Ordering::Greater)
        } else if fields.clone().all(|((_, v1), (_, v2))| v1 <= v2) {
            Some(Ordering::Less)
        } else {
            None
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::cmp::Ordering;

    #[test]
    fn pay_successful() {
        let test_data = vec![
            (Flux::new(), Flux::new(), Some(Flux::new())),
            (
                Flux {
                    fey: 2,
                    ..Flux::default()
                },
                Flux {
                    fey: 1,
                    ..Flux::default()
                },
                Some(Flux {
                    fey: 1,
                    ..Flux::default()
                }),
            ),
            (
                Flux {
                    fey: 4,
                    abyssal: 4,
                    foundation: 10,
                    ..Flux::default()
                },
                Flux {
                    fey: 3,
                    abyssal: 4,
                    ..Flux::default()
                },
                Some(Flux {
                    fey: 1,
                    abyssal: 0,
                    foundation: 10,
                    ..Flux::default()
                }),
            ),
            (
                Flux {
                    fey: 4,
                    abyssal: 4,
                    neutral: 2,
                    ..Flux::default()
                },
                Flux {
                    neutral: 5,
                    ..Flux::default()
                },
                Some(Flux {
                    fey: 4,
                    abyssal: 1,
                    neutral: 0,
                    ..Flux::default()
                }),
            ),
            (
                Flux {
                    fey: 40,
                    abyssal: 40,
                    neutral: 40,
                    ..Flux::default()
                },
                Flux {
                    fey: 40,
                    abyssal: 40,
                    neutral: 40,
                    ..Flux::default()
                },
                Some(Flux {
                    fey: 0,
                    abyssal: 0,
                    neutral: 0,
                    ..Flux::default()
                }),
            ),
        ];

        for (available, cost, expected) in test_data.iter() {
            assert_eq!(
                available.pay(*cost),
                *expected,
                "Expected {:?}.pay({:?}) to be equal to {:?}",
                available,
                cost,
                expected,
            );
        }
    }

    #[test]
    fn pay_failure() {
        let test_data = vec![
            (
                Flux::new(),
                Flux {
                    veil: 1,
                    ..Flux::default()
                },
                None,
            ),
            (
                Flux {
                    fey: 1,
                    ..Flux::default()
                },
                Flux {
                    fey: 2,
                    ..Flux::default()
                },
                None,
            ),
            (
                Flux {
                    fey: 4,
                    foundation: 10,
                    ..Flux::default()
                },
                Flux {
                    fey: 3,
                    abyssal: 4,
                    ..Flux::default()
                },
                None,
            ),
            (
                Flux {
                    fey: 4,
                    abyssal: 4,
                    neutral: 2,
                    ..Flux::default()
                },
                Flux {
                    neutral: 100,
                    ..Flux::default()
                },
                None,
            ),
            (
                Flux {
                    clockwork: 40,
                    foundation: 40,
                    neutral: 40,
                    ..Flux::default()
                },
                Flux {
                    fey: 40,
                    abyssal: 40,
                    neutral: 41,
                    ..Flux::default()
                },
                None,
            ),
        ];

        for (available, cost, expected) in test_data.iter() {
            assert_eq!(
                available.pay(*cost),
                *expected,
                "Expected {:?}.pay({:?}) to be equal to {:?}",
                available,
                cost,
                expected,
            );
        }
    }

    #[test]
    fn ordering_comparable() {
        let larger_and_small_pairs = vec![
            (
                Flux {
                    foundation: 2,
                    ..Flux::default()
                },
                Flux::new(),
            ),
            (
                Flux {
                    foundation: 2,
                    abyssal: 1,
                    ..Flux::default()
                },
                Flux {
                    foundation: 2,
                    ..Flux::default()
                },
            ),
            (
                Flux {
                    clockwork: 2,
                    neutral: 3,
                    ..Flux::default()
                },
                Flux {
                    clockwork: 2,
                    ..Flux::default()
                },
            ),
            (
                Flux {
                    neutral: 2,
                    ..Flux::default()
                },
                Flux {
                    neutral: 1,
                    ..Flux::default()
                },
            ),
            (
                Flux {
                    foundation: 0,
                    neutral: 1,
                    clockwork: 2,
                    ..Flux::default()
                },
                Flux {
                    foundation: -2,
                    neutral: 1,
                    clockwork: 2,
                    ..Flux::default()
                },
            ),
        ];

        for (larger_flux, smaller_flux) in larger_and_small_pairs.iter() {
            assert_eq!(
                larger_flux.partial_cmp(&smaller_flux),
                Some(Ordering::Greater),
                "Expected {:?} to be greater than {:?}",
                larger_flux,
                smaller_flux
            );
        }

        for (larger_flux, smaller_flux) in larger_and_small_pairs.iter() {
            assert_eq!(
                smaller_flux.partial_cmp(&larger_flux),
                Some(Ordering::Less),
                "Expected {:?} to be less than {:?}",
                smaller_flux,
                larger_flux
            );
        }
    }

    #[test]
    fn ordering_equal() {
        let equal_pairs = vec![
            (Flux::new(), Flux::new()),
            (
                Flux {
                    foundation: 2,
                    abyssal: 1,
                    ..Flux::default()
                },
                Flux {
                    foundation: 2,
                    abyssal: 1,
                    ..Flux::default()
                },
            ),
            (
                Flux {
                    clockwork: 2,
                    fey: -3,
                    neutral: 3,
                    ..Flux::default()
                },
                Flux {
                    clockwork: 2,
                    fey: -3,
                    neutral: 3,
                    ..Flux::default()
                },
            ),
            (
                Flux {
                    neutral: 2,
                    ..Flux::default()
                },
                Flux {
                    neutral: 2,
                    ..Flux::default()
                },
            ),
        ];

        for (flux_1, flux_2) in equal_pairs.iter() {
            assert_eq!(flux_1.partial_cmp(&flux_2), Some(Ordering::Equal));
        }
    }

    #[test]
    fn ordering_incomparable() {
        let incomparable_pairs = vec![
            (
                Flux {
                    foundation: 2,
                    abyssal: 1,
                    ..Flux::default()
                },
                Flux {
                    foundation: 1,
                    abyssal: 3,
                    ..Flux::default()
                },
            ),
            (
                Flux {
                    clockwork: 20,
                    neutral: 3,
                    ..Flux::default()
                },
                Flux {
                    clockwork: 2,
                    neutral: 30,
                    ..Flux::default()
                },
            ),
            (
                Flux {
                    neutral: 20,
                    ..Flux::default()
                },
                Flux {
                    neutral: -10,
                    foundation: 10,
                    ..Flux::default()
                },
            ),
        ];

        for (flux_1, flux_2) in incomparable_pairs.iter() {
            assert_eq!(
                flux_1.partial_cmp(&flux_2),
                None,
                "Expected {:?} to not be comparable to {:?}",
                flux_1,
                flux_2
            );
        }
    }
}
