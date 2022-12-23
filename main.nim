import os
import system
import sequtils
import std/strformat

proc main() =
    let argv = commandLineParams()
    if len(argv) == 0:
        echo "ERROR: please provide your bf source file."
        echo "USAGE: brainfrick <input.bf>"
        quit(1)
    let f = open(argv[0])
    defer: f.close()

    # important variables
    var tape: array[30000, int]
    var arrow: int = 0
    var instructionCount: int = 0
    let code = toSeq((f.readAll()).items)
    var i: int = 0


    # interpreter
    while i < len(code):
        if code[i] == '>':
            instructionCount += 1
            arrow += 1
        elif code[i] == '<':
            instructionCount += 1
            arrow -= 1
            if arrow < 0:
                quit(1)
        elif code[i] == '+':
            instructionCount += 1
            tape[arrow] += 1
            if tape[arrow] == 256:
                tape[arrow] = 0
        elif code[i] == '-':
            instructionCount += 1
            tape[arrow] -= 1
            if tape[arrow] == -1:
                tape[arrow] = 255
        elif code[i] == '.':
            instructionCount += 1
            stdout.write char(tape[arrow])
        elif code[i] == '[':
            instructionCount += 1
            if tape[arrow] == 0:
                var n: int = 0
                i += 1
                while i < len(code):
                    if code[i] == ']' and n == 0:
                        break
                    elif code[i] == '[':
                        n += 1
                    elif code[i] == ']':
                        n -= 1
                    i += 1
        elif code[i] == ']':
            instructionCount += 1
            if tape[arrow] != 0:
                var n: int = 0
                i -= 1
                while i < len(code):
                    if code[i] == '[' and n == 0:
                        break
                    elif code[i] == ']':
                        n += 1
                    elif code[i] == '[':
                        n -= 1
                    i -= 1
        i += 1
    echo ""
    echo fmt"Completed the program in {instructionCount} instructions."

when isMainModule:
    main()
