package com.tickets.controllers;

import java.io.Serializable;

import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;

import com.tickets.controllers.handlers.SeatHandler;

@Controller("seatController")
@Scope("session")
public class SeatController extends BaseController implements Serializable {

    private SeatHandler seatHandler;
    private SeatHandler returnSeatHandler;

    public SeatHandler getSeatHandler() {
        return seatHandler;
    }

    public void setSeatHandler(SeatHandler seatHandler) {
        this.seatHandler = seatHandler;
    }

    public SeatHandler getReturnSeatHandler() {
        return returnSeatHandler;
    }

    public void setReturnSeatHandler(SeatHandler returnSeatHandler) {
        this.returnSeatHandler = returnSeatHandler;
    }
}