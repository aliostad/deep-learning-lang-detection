package com.pactstudios.games.bescared.core.es.systems.collision.handler;

import com.artemis.World;

public class CollisionHandlerFactory {

    public BounceCollisionHandler bounceHandler;
    public DeathCollisionHandler deathHandler;
    public DoorTriggerCollisionHandler doorTriggerHandler;
    public WeightTriggerCollisionHandler weightTriggerHandler;
    public RepelCollisionHandler repelHandler;
    public ScareCollisionHandler scareHandler;

    public CollisionHandlerFactory() {
        bounceHandler = new BounceCollisionHandler();
        deathHandler = new DeathCollisionHandler();
        doorTriggerHandler = new DoorTriggerCollisionHandler();
        weightTriggerHandler = new WeightTriggerCollisionHandler();
        repelHandler = new RepelCollisionHandler();
        scareHandler = new ScareCollisionHandler();
    }

    public void initialize(World world) {
        bounceHandler.initialize(world);
        deathHandler.initialize(world);
        doorTriggerHandler.initialize(world);
        weightTriggerHandler.initialize(world);
        repelHandler.initialize(world);
        scareHandler.initialize(world);
    }
}
