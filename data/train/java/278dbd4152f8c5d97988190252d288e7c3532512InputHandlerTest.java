package com.technohest.core.handlers;

import com.technohest.constants.Controls;
import org.junit.Test;

import static org.junit.Assert.*;

/**
 * Test for the InputHandler class.
 * @author Oscar boking
 * @author Tobias Alldén
 */
public class InputHandlerTest {

    @Test
    public void testTick() throws Exception {
        InputHandler handler = new InputHandler();
        handler.set(Controls.LEFT,true);
        handler.tick();

        for(int i = 0; i < handler.buttons.length; i++){
            assertTrue(handler.buttons[i] == handler.oldButtons[i]);
        }
    }

    @Test
    public void testSetAndIsPressed() throws Exception {
        InputHandler handler = new InputHandler();
        handler.set(Controls.RIGHT,true);
        assertTrue(handler.isPressed(3));
    }

    @Test
    public void testHasInput() throws Exception {
        InputHandler handler = new InputHandler();
        assertTrue(!handler.hasInput());
        handler.set(Controls.DOWN,true);
        assertTrue(handler.hasInput());

    }

    @Test
    public void testKeys() throws Exception {
        InputHandler handler = new InputHandler();
        handler.set(Controls.RIGHT, true);
        handler.set(Controls.BASE_ATTACK, true);
        handler.set(Controls.SPECIAL_ATTACK, true);
        handler.keyDown(Controls.DOWN);

        boolean[] temp = new boolean[64];

        for(int i = 0; i < handler.buttons.length;i++){
            temp[i] = handler.buttons[i];
        }

        for(int j = 0; j < handler.buttons.length; j++){
            assertTrue(temp[j] == handler.buttons[j]);
        }

        handler.releaseAllKeys();
        assertTrue(temp[3] = !handler.buttons[3]);
        assertTrue(temp != handler.buttons);
    }

    @Test
    public void testKeyDown() throws Exception {
        InputHandler handler = new InputHandler();
        //51 is libgdxs keycode for W.
        boolean keyTyped = handler.hasInput();
        boolean returnValue = handler.keyDown(51);
        boolean keyTyped2 = handler.hasInput();
        assertFalse(keyTyped==keyTyped2 || returnValue);
    }

    @Test
    public void testKeyUp() throws Exception {
        InputHandler handler = new InputHandler();
        //51 is libgdxs keycode for W.
        boolean keyTyped = handler.hasInput();
        boolean returnValue = handler.keyUp(51);
        boolean keyTyped2 = handler.hasInput();
        assertFalse(keyTyped!=keyTyped2 || returnValue);
    }

    @Test
    public void testKeyTyped() throws Exception {
        InputHandler handler = new InputHandler();
        //51 is libgdxs keycode for W.
        assertFalse(handler.keyTyped('c'));
    }

    @Test
     public void testTouchDown() {
        InputHandler handler = new InputHandler();
        assertFalse(handler.touchDown(10,10,1,10));
    }
    @Test
    public void testTouchUp() {
        InputHandler handler = new InputHandler();
        assertFalse(handler.touchUp(10, 10, 10, 1));
    }
    @Test
    public void testTouchDragged() {
        InputHandler handler = new InputHandler();
        assertFalse(handler.touchDragged(10,10,10));
    }

    @Test
    public void testMouseMoved() throws Exception {
        InputHandler handler = new InputHandler();
        assertFalse(handler.mouseMoved(10,50));
    }

    @Test
    public void testScrolled() throws Exception {
        InputHandler handler = new InputHandler();
        assertFalse(handler.scrolled(15));

    }
}