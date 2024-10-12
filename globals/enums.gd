## class_name Enums <- autoload so commented out
extends Node


enum CardRarity { COMMON, RARE, MYTHIC }

enum FluxType { FOUNDATION, WORSHIPPERS, INVESTIGATORS, FEY, ABYSSAL, CLOCKWORK, NEUTRAL }

enum Faction { FOUNDATION, WORSHIPPERS, INVESTIGATORS, FEY, ABYSSAL, CLOCKWORK, NEUTRAL }

const FactionColors: Dictionary = { Faction.FOUNDATION: "black",
                                    Faction.WORSHIPPERS: "red", 
                                    Faction.INVESTIGATORS: "white", 
                                    Faction.FEY: "green", 
                                    Faction.ABYSSAL: "purple", 
                                    Faction.CLOCKWORK: "orange", 
                                    Faction.NEUTRAL: "grey" }