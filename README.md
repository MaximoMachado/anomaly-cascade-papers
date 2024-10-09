## Folder Structure

- addons: Third Party Assets
- assets: Assets such as art, shaders, and animations
- globals: Global Autoload scripts e.g. Enums and SignalBus
- resources: Resources and refcounted objects
	- game: Player API to take actions in game. Entire game state is stored here
	- board: Contains state for player stats, player hands+decks, and summoned followers/lands
	- card: Base Card Class and other card types that inherit from it
	- card_components: Resources combined with Card to make a created_card
	- created_cards: The cards available to put in one's deck
- scenes: UI and View logic
	- board_view: Represents visuals and animations for the board resource
	- card_ui: Represents visuals and animations for the Card resource
	- menu_ui: Menus for UI outside of main game flow
	- main: Root node that starts application
- tests: Unit tests for resources go here
