/*
 * load.h
 *
 *  Created on: 24 îêò. 2013 ã.
 *      Author: r.leonov
 */

#ifndef LOAD_H_
#define LOAD_H_

#include "kl_lib_f100.h"
#include "lcd.h"
#include "load.h"

#define LOAD_PORT   GPIOA
#define LOAD_PIN    1

enum LoadMode_t {
    lmManual, lmTime
};

class Load_t {
private:
    bool IsOn;
public:
    uint32_t TimeToWork;
    bool InLoad;
    LoadMode_t Mode;
    void ChangeMode()   { Mode = (Mode == lmTime)? lmManual : lmTime;           }
    void PrintMode(LoadMode_t AMode) {
        switch (AMode) {
            case lmManual:
                Lcd.Printf(8,0, "Manual");
                break;
            case lmTime:
                Lcd.Printf(8,0, "Time  ");
                break;
        }
    }
    void Init()         { PinSetupOut(LOAD_PORT, LOAD_PIN, omPushPull, ps50MHz); Mode = lmTime; }
    inline void On()    { PinSet(LOAD_PORT, LOAD_PIN); InLoad = true;           }
    inline void Off()   { PinClear(LOAD_PORT, LOAD_PIN); InLoad = false;        }
};

extern Load_t Load;
#endif /* LOAD_H_ */
