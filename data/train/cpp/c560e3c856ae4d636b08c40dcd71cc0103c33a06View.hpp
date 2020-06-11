/*
 * Abstract base class for views.
 */

#ifndef _VIEW_H_
#define _VIEW_H_

namespace oobench {
    class Controller;

    class View : public Observer {
        Model* model;
        Controller* controller;

    public:
        View(Model& theModel);
        View(const View& anotherView);
        virtual ~View();
        virtual void update();
        inline Model& getModel() const;
        Controller& getController() const;
        Controller* makeController();
        virtual void draw() = 0;
    };

    // Implementation

    Model& View::getModel() const {
        return *model;
    }
}

#endif
