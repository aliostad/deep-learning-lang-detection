#ifndef _H_CHAIN_OF_RESPONSIBLITY_H_
#define _H_CHAIN_OF_RESPONSIBLITY_H_

class handler
{
    public:
        handler(handler* pHandler = NULL)
            : m_pHandler(pHandler)
        {
        }
        virtual ~handler();

        virtual void handlerRequest() = 0;

    protected:
        handler* m_pHandler;
};

class firstConcreatHandler :public handler
{
    public :
        firstConcreatHandler(handler* pHandler = NULL)
            : handler(pHandler)
        {
        }
        virtual ~firstConcreatHandler(){}

        virtual void handlerRequest();
};

class secondConcreateHandler :public handler
{
    public:
        secondConcreateHandler(handler* pHandler = NULL)
            : handler(pHandler)
        {
        }
        virtual ~secondConcreateHandler(){}

        virtual void handlerRequest();
};




#endif /* _H_CHAIN_OF_RESPONSIBLITY_H_ */
