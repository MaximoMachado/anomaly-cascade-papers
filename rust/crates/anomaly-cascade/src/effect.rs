use super::speed::Speed;

pub trait Effect {
    fn speed(&self) -> Speed;
}

#[cfg(test)]
mod tests {}
