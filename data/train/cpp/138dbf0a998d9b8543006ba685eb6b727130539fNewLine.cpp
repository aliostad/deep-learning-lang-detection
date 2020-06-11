#include "NewLine.hpp"


NewLine::NewLine()
{
}


void NewLine::execute(EditorModel& model)
{
    std::string line = model.line(model.cursorLine());
    prevText = line.substr(model.cursorColumn()-1, line.length()-model.cursorColumn()+1);
    
    prevCurCol = model.cursorColumn();
    model.insertText(model.cursorLine()+1, 1, prevText, true);
    model.removeText(model.cursorLine(), prevCurCol+1, prevText.length(), false, false);

    model.setCursorLine(model.cursorLine()+1);
    model.setCursorColumn(1);
}


void NewLine::undo(EditorModel& model)
{
    model.insertText(model.cursorLine()-1, prevCurCol, prevText, false);
    model.removeText(model.cursorLine(), 1, prevText.length(), false, false);

    if (model.line(model.cursorLine()).length() == 0)
    {
        model.removeText(model.cursorLine(), 1, 1, false, true);
    }
    else
    {
        model.setCursorLine(model.cursorLine()-1);
    }
    model.setCursorColumn(prevText.length()+1);
}
