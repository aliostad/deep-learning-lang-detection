//
//  collisionscorekeeper.cpp
//  witchball
//
//  Created by Shervin Ghazazani on 3/13/13.
//	Handles Ball to Player game collision and increments score.
//

#include "collisionscorekeeper.h"
#include "model.h"

collisionscorekeeper::collisionscorekeeper(b2ContactListener *listener) : listener(listener) {}

void collisionscorekeeper::BeginContact(b2Contact *contact) {
  if (listener) {
    listener->BeginContact(contact);
  }

  b2Body *bodyA = contact->GetFixtureA()->GetBody();
  b2Body *bodyB = contact->GetFixtureB()->GetBody();

  void *bodyUserData = contact->GetFixtureA()->GetBody()->GetUserData();

  if ( bodyUserData ) {
    Model *model = static_cast<Model*>( bodyUserData );

    if(((bodyA == model->player1_bottom || bodyA == model->player1_top) && (bodyB == model->ball)) ||
       ((bodyB == model->player1_bottom || bodyB == model->player1_top) && (bodyA == model->ball))) {
      if (model->player1_top->IsActive()) {
        model->IncrementPlayerOneCount();
      }
    } else if(((bodyA == model->player2_bottom || bodyA == model->player2_top) && (bodyB == model->ball)) ||
              ((bodyB == model->player2_bottom || bodyB == model->player2_top) && (bodyA == model->ball))) {
      if (model->player2_top->IsActive()) {
        model->IncrementPlayerTwoCount();
      }
    }
  }
}

void collisionscorekeeper::EndContact(b2Contact *contact) {
  if (listener) {
    listener->EndContact(contact);
  }
  
  b2Body *bodyA = contact->GetFixtureA()->GetBody();
  b2Body *bodyB = contact->GetFixtureB()->GetBody();

  void* bodyUserData = contact->GetFixtureA()->GetBody()->GetUserData();

  if ( bodyUserData ) {
    Model *model = static_cast<Model*>( bodyUserData );

    if(((bodyA == model->player1_bottom || bodyA == model->player1_top) && (bodyB == model->ball)) ||
       ((bodyB == model->player1_bottom || bodyB == model->player1_top) && (bodyA == model->ball))) {
      model->RotateClockwise();
    }
    else if(((bodyA == model->player2_bottom || bodyA == model->player2_top) && (bodyB == model->ball)) ||
            ((bodyB == model->player2_bottom || bodyB == model->player2_top) && (bodyA == model->ball))) {
      model->RotateCounterClockwise();
    }
  }
}
