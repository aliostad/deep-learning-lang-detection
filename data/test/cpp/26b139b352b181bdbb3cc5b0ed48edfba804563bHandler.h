#pragma once

class Handler
{
public:
	virtual ~Handler(void);

	virtual void HandleRequest(int iRequest) = 0;
	
	void SetSuccessor(Handler* pHandler);
	Handler* GetSuccessor();
protected:
	Handler(void);
private:
	Handler* m_pSuc;
};

class HandlerA : public Handler
{
public:
	HandlerA();
	virtual ~HandlerA();

	void HandleRequest(int iRequest);
};

class HandlerB : public Handler
{
public:
	HandlerB();
	virtual ~HandlerB();

	void HandleRequest(int iRequest);
};

class HandlerC : public Handler
{
public:
	HandlerC();
	virtual ~HandlerC();

	void HandleRequest(int iRequest);
};