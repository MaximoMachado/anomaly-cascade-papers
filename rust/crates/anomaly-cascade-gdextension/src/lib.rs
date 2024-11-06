use godot::prelude::*;
use godot::classes::IResource;

struct CardGameExtension;

#[gdextension]
unsafe impl ExtensionLibrary for CardGameExtension {}

#[derive(GodotClass)]
#[class(base=Resource)]
struct Game {
    base: Base<Resource>
}

#[godot_api]
impl IResource for Game {
    fn init(base: Base<Resource>) -> Self { 
        Self { base }
    }
}