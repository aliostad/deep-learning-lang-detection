#include "handler.h"

Handler::Handler() {
}

Handler::~Handler() {
}

void Handler::parse_options(int argc, char* const argv[]) {
}

void Handler::input(IPPacket& p) {
    //cout << "Handler::input" << endl;
    p.accept();
}

void Handler::output(IPPacket& p) {
    //cout << "Handler::output" << endl;
    p.accept();
}

void Handler::forward(IPPacket& p) {
    //cout << "Handler::forward" << endl;
    p.accept();
}

void Handler::prerouting(IPPacket& p) {
    //cout << "Handler::prerouting" << endl;
    p.accept();
}

void Handler::postrouting(IPPacket& p) {
    //cout << "Handler::postrouting" << endl;
    p.accept();
}

void Handler::start() {
}
