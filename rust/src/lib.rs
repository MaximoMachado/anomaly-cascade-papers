use godot::prelude::*;
use godot::classes::IResource;

struct WinterStarlingTcgExtension;

#[gdextension]
unsafe impl ExtensionLibrary for WinterStarlingTcgExtension {}

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