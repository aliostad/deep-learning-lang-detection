//
//  MessageModel.cpp
//  Protocol
//
//  Created by Wahid Tanner on 9/26/14.
//

#include "MessageModel.h"

using namespace std;
using namespace MuddledManaged;

Protocol::MessageModel::MessageModel (const string & name)
: Nestable(name)
{
}

Protocol::MessageModel::MessageModel (const MessageModel & src)
: Nestable(src), OptionModelContainer(src), MessageFieldModelContainer(src),
  EnumModelContainer(src), MessageModelContainer(src), OneofModelContainer(src)
{
}

Protocol::MessageModel & Protocol::MessageModel::operator = (const MessageModel & rhs)
{
    if (this == &rhs)
    {
        return *this;
    }

    Nestable::operator=(rhs);
    OptionModelContainer::operator=(rhs);
    MessageFieldModelContainer::operator=(rhs);
    EnumModelContainer::operator=(rhs);
    MessageModelContainer::operator=(rhs);
    OneofModelContainer::operator=(rhs);

    return *this;
}
