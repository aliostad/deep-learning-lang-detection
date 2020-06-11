package asteroids

import (
	"fmt"
	"math/rand"
	//"math/rand"
)

// asteroidManager stores info regarding gameworlds boundaries, all asteroids etc.
type asteroidManager struct {
	xMax      int
	yMax      int
	nextID    int
	maxRoids  int
	treshold  int
	deathRow  []int
	input     chan Data
	output    chan Data
	asteroids []*Asteroid
}

// loop is where the asteroidManagers spinns waiting for tick message from the session,
// once tick received it handle collisions from last tick, spawn new asteroids and
// send the tick to all asteroids
func (manager *asteroidManager) loop(sessionConn *Connection, height int, width int) {

	manager.init(sessionConn, height, width)

	for {
		select {

		case msg := <-manager.input:

			if msg.action == "session.tick" {
				//fmt.Println(manager.asteroids)
				manager.print()
				manager.handleCollisions()

				if manager.shouldSpawn() {
					manager.newAsteroid()
				}

				manager.resumeAsteroids()
			}

			if msg.action == terminate {

				roidKills := manager.killAsteroids()
				DebugPrint(fmt.Sprintln("[AST.MAN] Dead,", roidKills, "asteroids killed"))
				manager.output <- Data{terminated, ok}
				return

			}

		}
	}

}

func (manager *asteroidManager) kill() {

	go func() {
		manager.input <- Data{terminate, request}
	}()

}

func (manager *asteroidManager) killAsteroids() int {

	count := 0
	for _, asteroid := range manager.asteroids {

		asteroid.input <- Data{terminate, request}
		<-asteroid.input
		count++
	}
	return count

}

// newAsteroidManager creates a new asteroid manager
func newAsteroidManager() *asteroidManager {

	DebugPrint(fmt.Sprintln("[AST.MAN] Created"))
	return new(asteroidManager)

}

// init initiate the asteroid manager with hardcoded values TODO: input?
// and sets channels to session and
func (manager *asteroidManager) init(sessionConn *Connection, height int, width int) {
	// TODO fix hardcoded variables
	manager.yMax = height
	manager.xMax = width
	manager.maxRoids = 50
	manager.input = sessionConn.read
	manager.output = sessionConn.write

	sessionConn.write <- Data{"a.manager_ready", ok}
}

// newAsteroid creates a new asteroid, appends it to the asteroidmanagers array
// and creates a new go-routine that will handle the asteroid
func (manager *asteroidManager) newAsteroid() {

	asteroid := newAsteroid()
	manager.asteroids = append(manager.asteroids, asteroid)

	asteroid.init(manager.getNextID(), manager.xMax, manager.yMax)
	go asteroid.loop()

}

// spawnAsteroid spawns a new asteroid if current asteroids in world below maxValue and
// if the randomized int that is set has a higher value than the worlds threshold
func (manager *asteroidManager) shouldSpawn() bool {

	r := rand.Intn(101)
	scalar := 100 / manager.maxRoids

	if r > manager.treshold && len(manager.asteroids) < manager.maxRoids {

		if len(manager.asteroids) > 0 {
			manager.treshold = len(manager.asteroids) * scalar
		} else {
			manager.treshold = scalar
		}
		return true

	}

	return false

}

// resumeAsteroids used to send "tick" to all asteroids
func (manager *asteroidManager) resumeAsteroids() {

	for _, asteroid := range manager.asteroids {
		asteroid.input <- Data{"a.manager_tick", ok}
	}

}

// handleCollisions used to check if any asteroid has been in a collision
// or if it's out of bounds
func (manager *asteroidManager) handleCollisions() {

	var offset = 0

	var acopy = make([]*Asteroid, len(manager.asteroids))
	copy(acopy, manager.asteroids)

	for i, asteroid := range acopy {

		if !asteroid.isAlive() || !asteroid.inBounds(manager) {
			manager.removeAsteroid(i + offset)
			offset--
		}
	}

}

// getAsteroids return the array containing the current asteroids
func (manager *asteroidManager) getAsteroids() []*Asteroid {
	return manager.asteroids
}

// removeAsteroid removes specific asteroid from manager asteroid array
func (manager *asteroidManager) removeAsteroid(i int) {
	manager.asteroids = append(manager.asteroids[:i], manager.asteroids[i+1:]...)
}

// getNextID returns the id to be used and sets the next value
func (manager *asteroidManager) getNextID() int {
	defer func() { manager.nextID++ }()
	return manager.nextID
}

// print is used to print all asteroids that have collided
func (manager *asteroidManager) print() {

	var list []int

	for _, asteroid := range manager.asteroids {
		if !asteroid.isAlive() {
			list = append(list, asteroid.ID)
		}
	}

	if len(list) > 0 {
		DebugPrint(fmt.Sprintln("[AST.MAN] Collision:", list))
	}

}
