# Midnight Stealth
## Game Design Document

## Design Pillars

- Focusing on stealth through sound levels 
- Simple controls with swift decision making
- Cat-like exploration and behaviour
- Increasing difficulty and mischief

## Core Loop

Explore the house, choose a route, manage noise level, complete the night's objective, and return to safety without waking the household.

## Mechanics

Primary: Sneak  

Secondary: Move  

Tertiary: Interact 

## Goal · Opposition · Decisions · Rules

### Goal
Complete the nightly objective without waking the household.

### Opposition

- Sleeping humans/dogs
- Noisy floorboards
- Creaking doors
- Obstacles

### Decision

- Speed vs. Noise  
    - Sprint through the hallway with a dash, or crouch and move quietly?

- Route selection
    - Take the short route through a noisy room, or the longer quiet route?

- Risk vs. Safety
    - Is it worth interacting with that object to complete the objective, knowing it might make noise?

- Hiding vs. Continuing
    - Hide and wait for the human's awareness to decrease, or keep moving?

### Rules

- The cat can move around the designated environment.
- Different actions produce the appropriate amounts of noise.
- Louder noises increases human awareness.
- Humans have the ability to investigate the noises they hear.
- Hiding allows the cat to avoid detection and/or reduce risk.
- If human awareness reaches its maximum, the player loses.
- Completing the required objective completes the level.
- Later levels introduce additional challenges.
- The player cannot move through walls or other solid obstacles.
- The player cannot skip to higher levels without completing previous ones.

## Player Experience

- The human takes the role of a mischevous, greedy cat. Of the eight pleasures, the aim is for sensation and challenge. 

## Target Player

Bartle Type: Achiever

Why? The player has clear objectives they aim to win. The levels get progressively harder, increasing the challenge. Players can improve by learning the house layout.

## Inspirations

### Games
 
Splinter Cell
Stray 

### Non Games

My own mischevous cat.

## Genre · Platform · Tools.

### Genre 

Stealth/Puzzle

### Platform

PC/Windows

### Tools

- Odin
- Raylib
- VS Code
- Git/Github

## Progression

The progression will be over multiple nights (levels). Each level introduces a new stealth challenge while also requiring the player to apply mechanics learned in the previous levels.

Night 1 - Basics/Learning how to sneak  
    - get to the treats

Night 2 - Someone is sleeping   
    - Player has to avoid making loud noises to alert the sleeping human  

Night 3 - More noisy objects are places  
    - e.g. Different floor surface  

Night 4 - Introduce more routes + hiding spots  
    - Player needs to make decisions between different routes  

Night 5 - Combining all the mechanics together 


## Themes

- Mischief 
- Curiosity

## Scope 

### Must Have

- Playable cat
- Basic movement
- Crouching / walking / sprinting
- Noise system
- Human awareness system
- Basic human AI
- Hiding mechanic
- Environmental collision
- Objectives
- Win/lose conditions
- 4–5 levels
- Title screen
- In-game controls/tutorial
- Basic sound effects
- Basic UI

### Should Have

- Different hiding spots
- Different floor surfaces
- More environmental noise sources
- Multiple human behaviors
- Optional objectives
- More detailed environmental interactions

### Nice to Have 

- Additional cat animations 
- Cat customization
- Additional rooms
- Particle effects
- Small story moments
- Additional sound effects
- Extra bonus levels

If short on time, nice-to-have features will be taken out first, followed by should have features.