# coding: utf-8

import sys
sys.path.append("../")
from src.program_controller import ProgramController


if __name__ == '__main__':    
    
    #controller = ProgramController()
    ##addi : R10 = 100 + R0(que é 0) -> (4 vezes)
    #controller.pipeline.PC = ["00100000000010100000000001100100", "00100000000010100000000001100100",
    #                            "00100000000010100000000001100100", "00100000000010100000000001100100"]
    #controller.run_clocks_continuously()

    #controller = ProgramController()
    ##addi : R0 = 100
    ##addi : R1 = 100
    ##add : R2 = R1 + R0
    #controller.pipeline.PC = ["00100010000000000000000001100100","00100010000000010000000001100100",
    #                          "00000000000000010001000000100000" ]
    #controller.run_clocks_continuously()

    controller = ProgramController()
    ##addi : R0 = 100
    ##addi : R1 = 100
    ##mul: r1 = r1*r0
    ##add : R2 = R1 + R0
    controller.pipeline.PC = ["00100010000000000000000001100100","00100010000000010000000001100100",
                              "00000000000000010000100000011000", "00000000000000010001000000100000" ]
    controller.run_clocks_continuously()
