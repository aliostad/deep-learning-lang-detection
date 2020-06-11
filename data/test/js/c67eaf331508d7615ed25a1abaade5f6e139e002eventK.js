// keyDown event
function keyDown(event){
    switch (event.keyCode){
        case 65:    // A
            drag(y,x,show_block,0);
            x = x > 0 ? x-1 : 0;
            preX = 1;
            drag(y,x,show_block,1);
            break;
        case 68:    // D
            drag(y,x,show_block,0);
            x = x >= 8 ? 8 : x+1;
            preX = -1;
            drag(y,x,show_block,1);
            break;
        case 83:    // S
            drag(y,x,show_block,0);
            y = y+4 ;
            y = y>20 ? 20: y;
            drag(y,x,show_block,1);
            break;
        case 87:    // w
            drag(y,x,show_block,0);
            show_block = show_block == I1_block ? I2_block : I1_block ;
            drag(y,x,show_block,1);
            break;
    }
}

