## Folder Structure

- addons: Third Party Assets
- assets: Assets such as art, shaders, and animations
- globals: Global Autoload scripts e.g. Enums and SignalBus
- src: Main Game Logic
	- game.gd: Player API to take actions in game. Entire game state is stored here
	- card.gd: Base Card Class and other card types that inherit from it
- scenes: UI, Networking, and View logic
	- card_ui: Represents visuals and animations for the Card resource
	- menu_ui: Menus for UI outside of main game flow
	- main: Root node that starts application
- tests: Unit and integration testing 
