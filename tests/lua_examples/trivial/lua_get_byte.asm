    DEVICE ZXSPECTRUM48
    ORG 0x7842
test:   DEFB 0x41, 0x78
    OUTPUT "lua_get_byte.bin"
    LUA ALLPASS
        _pc("db "..sj.get_byte(sj.calc("test"))..", "..sj.calc("low test"))
        _pc("db "..sj.get_byte(0x7842)..", "..0x42)
    ENDLUA

    LUA ALLPASS
        x = sj.calc("test + ~ ")    -- invalid syntax for expression evaluation, returns 0
        _pc("db 'e'+"..x)
    ENDLUA

    LUA pass3 ; wrong arguments
        sj.get_byte(0x1234, 2)      -- not reported since Lua5.4 and LuaBridge 2.6 integration :(
    ENDLUA

    ; extra test coverage
    LUA PASS3
        sj.get_byte()               -- missing argument
    ENDLUA
