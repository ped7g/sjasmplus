    DEVICE ZXSPECTRUM48
    ORG 0x4443
test:   DEFW 0x4241
    OUTPUT "lua_get_word.bin"
    LUA ALLPASS
        _pc("dw "..sj.get_word(_c("test"))..", ".._c("test"))
        _pc("dw "..sj.get_word(0x4443)..", "..0x4443)
    ENDLUA

    LUA ALLPASS
        x = _c("test + ~ ")    -- invalid syntax for expression evaluation, returns 0
        _pc("db 'e'+"..x)
    ENDLUA

    LUA pass3 ; wrong arguments
        sj.get_word(0x1234, 2)  -- not reported since Lua5.4 and LuaBridge 2.6 integration :(
    ENDLUA

    ; some extra error specific to get word and test coverage
    LUA PASS3
        sj.get_word(0xFFFF)     -- invalid address
        sj.get_word()           -- missing argument
    ENDLUA
