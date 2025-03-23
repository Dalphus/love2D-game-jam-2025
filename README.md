# love2D-game-jam-2025
plan!

## Idea Summary
You control a colony of semi-sentient plant-based lifeforms on their grand journey through the post-apocalyptic remains of a civilization filled with automated factories and mechanical dangers.
These factories are heavily guarded by automated systems and defences

You play as a commander to a small group of powerful troops

Turn based

Friendly troops have an action limit per turn
 - actions are designated before ending turn, and are carried out all at once after clicking end turn

## Roadmap
### High Priority
- enemies
- Turns
- polish GUI
- Level or Scene functionality

### Medium Priority
- Unit Selections
- Organize file structure
- smooth zoom transition


### Low Priority
- Swarm Behavior
- Hub Screen
- UI scaling

Touch up logic for Scenes
 - smooth zoom transition
 - add f5 refresh for testing
 - implement multiple test scenes and scene switching
Button Class
Better Draw paradigm

Loading levels
Turns
Unit selection
 > path planning


Ideas
 - background art is made up of tiles
 - tiles can be chosen from a set of similars
 - enemies make gibs when they die
 - gibs get pushed around when units walk through them
 - violent squish trap
  - loud jumpscare

TODO
- replace circle with appropriate sprite
- remove a/d steering
 - replace with mouse based steering
 - hold mouse 1 or space to start moving ghost
- add inertia and impulse
- make velocity a vector
 - accelerating in a direction adds impulse to this vector
- smooth rotation
 - doesn't have to be done with vectors
 - bezier or spline curve?
 - make rotation take a small amount of energy
- add time-based holograms to give a better scale of time taken
- movement doesn't have to be deterministic, just good enough
