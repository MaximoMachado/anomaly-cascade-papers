## class_name Enums <- autoload so commented out
extends Node

enum GamePhase { MULLIGAN, PLAY, DECLARE_ATTACKERS, DECLARE_BLOCKERS, REACTION }

enum CardRarity { COMMON, RARE, MYTHIC }

enum FluxType { FOUNDATION, WORSHIPPERS, INVESTIGATORS, FEY, ABYSSAL, CLOCKWORK, NEUTRAL }

enum Faction { FOUNDATION, WORSHIPPERS, INVESTIGATORS, FEY, ABYSSAL, CLOCKWORK, NEUTRAL }

## Maps faction to their respective color
const FactionColors: Dictionary = { Faction.FOUNDATION: "black",
									Faction.WORSHIPPERS: "red", 
									Faction.INVESTIGATORS: "white", 
									Faction.FEY: "green", 
									Faction.ABYSSAL: "purple", 
									Faction.CLOCKWORK: "orange", 
									Faction.NEUTRAL: "grey" }

enum GameAction { 
				MULLIGAN, ## Mulligan only occurs once at start of game
				PLAY_CARD,
				ACTIVATE_ABILITY, ## In-play followers/factories have abilities that can be used. Oftentimes, they exhaust the card
				DECLARE_FOLLOWER, ## Look at [DeclareFollower] to see what a follower can be declared to do in that moment
				END_TURN,
				}

enum DeclareFollower { ATTACKER, INFLUENCER, BLOCKER, NONE }