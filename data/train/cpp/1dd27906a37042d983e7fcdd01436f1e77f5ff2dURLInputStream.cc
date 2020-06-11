#include "StringUtil.h"
#include "CS240Exception.h"
#include "HTTPInputStream.h"
#include "FileInputStream.h"
#include "URLInputStream.h"
#include "InputStream.h"

using namespace std;

InputStream * URLInputStream::StreamFactory(const string & url) {
	string tempUrl = StringUtil::ToLowerCopy(url);
	if (StringUtil::IsPrefix(tempUrl, "file:/")) {
		return new FileInputStream(url);
	}
	else if (StringUtil::IsPrefix(tempUrl, "http://")) {
		return new HTTPInputStream(url);
	}
	else {
		throw InvalidURLException(url);
	}
	
}

URLInputStream::URLInputStream(const std::string & Url) : 
								 mStream(URLInputStream::StreamFactory(Url))
{
}

URLInputStream::~URLInputStream()
{
	if(mStream && mStream->IsOpen())
	{
		mStream->Close();
		
	}
	
	delete mStream;
}


	
char URLInputStream::Peek()
{
	return mStream->Peek();
}
		
char URLInputStream::Read()
{
	return mStream->Read();
}

void URLInputStream::Close()
{
	
	return mStream->Close();
}

bool URLInputStream::IsOpen()const
{
	return mStream->IsOpen();
}

bool URLInputStream::IsDone()const
{
	return mStream->IsDone();
}

std::string URLInputStream::GetLocation() const
{
	return mStream->GetLocation();
}

			


