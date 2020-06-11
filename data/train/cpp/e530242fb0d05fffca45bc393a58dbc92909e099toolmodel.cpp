#include "toolmodel.h"
#include "project.h"

namespace Tools
{

    void ToolModel::
            removeFromRepo()
    {
        ToolRepo* r = repo_;
        repo_ = 0;
        if (r)
        {
            // deletes this
            r->removeToolModel( this );
        }
    }


    void ToolModel::
            emitModelChanged()
    {
        emit modelChanged(this);
    }


    ToolModelP ToolRepo::
            addModel(ToolModel* model)
    {
        EXCEPTION_ASSERT( model );

        ToolModelP modelp(model);
        tool_models_.insert( modelp );
        model->repo_ = this;

        foreach( ToolControllerP const& p, tool_controllers_)
            p->createView( modelp, this, project_ );

        project_->setModified();

        return modelp;
    }

} // namespace Tools
