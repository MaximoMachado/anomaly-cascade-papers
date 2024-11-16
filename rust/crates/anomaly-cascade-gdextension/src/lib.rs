extern crate anomaly_cascade;

use godot::classes::IResource;
use godot::prelude::*;

struct CardGameExtension;

#[gdextension]
unsafe impl ExtensionLibrary for CardGameExtension {}

#[derive(GodotClass)]
#[class(base=Resource)]
struct Game {
    base: Base<Resource>,
}

#[godot_api]
impl IResource for Game {
    fn init(base: Base<Resource>) -> Self {
        Self { base }
    }
}
