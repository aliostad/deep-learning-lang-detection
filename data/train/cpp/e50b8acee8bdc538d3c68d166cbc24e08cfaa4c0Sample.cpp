#include "Sample.h"
#include <android/log.h>

Sample* Sample::uniqueInstance_ = 0;

Sample::Sample() {
}

Sample* Sample::getInstance() {
	if (uniqueInstance_ == 0)
		uniqueInstance_ = new Sample();
	return uniqueInstance_;
}

int Sample::add(int a, int b) {
	return a + b;
}

void Sample::printLog(char *tag, char *log) {
	__android_log_print(ANDROID_LOG_DEBUG, tag, log);
}

char* Sample::getString() {
	static char s[] = "hello, rosetta";
	return s;
}

// 자바 코드 호출 테스트
#include "callback.h"

void Sample::testCallback() {
	char text[] = "this is callback!!";
	Callback_CallbackSample_showToast(text, 1000);
}

