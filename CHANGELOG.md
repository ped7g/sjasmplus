## [1.18.1](https://github.com/z00m128/sjasmplus/releases/tag/v1.18.1) - 23.1.2021
- Big-Endian hosts support (experimental and not tested continuously)
- added "listall", "listact" commands to [OPT](http://z00m128.github.io/sjasmplus/documentation.html#po_opt) - to switch between listing types
- [`WHILE`](http://z00m128.github.io/sjasmplus/documentation.html#po_while) has optional argument to set explicit guardian-counter
- [`ASSERT`](http://z00m128.github.io/sjasmplus/documentation.html#po_assert) has optional argument (to add description/notes for expression)
- [`SLOT`](http://z00m128.github.io/sjasmplus/documentation.html#po_slot) and [`MMU`](http://z00m128.github.io/sjasmplus/documentation.html#po_mmu) will now accept also starting address of slot instead of its number
- fix: option `--sym` was not exporting labels starting with underscore
- fix: `SAVENEX` BMP-loader bug when certain builds of sjasmplus were unable to open BMP files
- fix: after `STRUCT` instance the "main" label is not polluted by last field of STRUCT
- minor bugfixes in parser, windows cmake-builds have now icon
- docs: adding "Index" section
- docs: adding some missing information (`__DATE__`, `__TIME__`), fixing HTML anchor names

## [1.18.0](https://github.com/z00m128/sjasmplus/releases/tag/v1.18.0) - 12.12.2020
- [may break old sources] the colon between end of EQU/DEFL/= expression and instruction is mandatory
- [may break old sources] new [abs operator](http://z00m128.github.io/sjasmplus/documentation.html#s_expressions) for absolute integer value
- new [system of warnings](http://z00m128.github.io/sjasmplus/documentation.html#s_id_warnings) (and suppression), the "; ok" comments are now deprecated
- [`DISPLAY`](http://z00m128.github.io/sjasmplus/documentation.html#po_display) has now also binary and char formatting
- [`DEFINE+`](http://z00m128.github.io/sjasmplus/documentation.html#po_define) added to [re]define identifier without error
- [`ELSEIF`](http://z00m128.github.io/sjasmplus/documentation.html#ca_elseif) added to conditional assembling arsenal
- [`WHILE`](http://z00m128.github.io/sjasmplus/documentation.html#po_while) added for conditional loops
- added ["NOSLOT64K" device](http://z00m128.github.io/sjasmplus/documentation.html#po_device) with 2MiB of virtual memory
- [`LABELSLIST`](http://z00m128.github.io/sjasmplus/documentation.html#po_labelslist) has new optional argument to dump 16bit "virtual labels"
- [`CSPECTMAP`](http://z00m128.github.io/sjasmplus/documentation.html#po_cspectmap) exports STRUCT symbols with more detail (instance labels with physical address)
- [SMC offset](http://z00m128.github.io/sjasmplus/documentation.html#s_labels) syntax for self-modify-code labels for source brevity
- added exclamation mark prefix for [labels](http://z00m128.github.io/sjasmplus/documentation.html#s_local_labels) to not affect following local labels
- added "listmc" command to [OPT](http://z00m128.github.io/sjasmplus/documentation.html#po_opt) - to list only lines with machine code bytes
- added `--lstlab=sort` variant to have symbols in listings in predictable order
- minor bugfixes in parser and listing-line-numbering, refactored symbols/labels implementation
- Added [example (chargfx2asm)](https://github.com/z00m128/sjasmplus/tree/master/examples/chargfx2asm) how to use sjasmplus as byte-processor for binary files
- [SLD data](http://z00m128.github.io/sjasmplus/documentation.html#c_sld_data) improvements based on Maziac's feedback and DeZog's needs

## [1.17.0](https://github.com/z00m128/sjasmplus/releases/tag/v1.17.0) - 8.8.2020
- `STRUCT` has new [`TEXT`](http://z00m128.github.io/sjasmplus/documentation.html#st_text) pseudo-instruction to define "DB-like" data
- [`STRUCT` initializer block](http://z00m128.github.io/sjasmplus/documentation.html#st_usage) can be now multi-line (when correctly enclosed in curly braces)
- [`EQU`](http://z00m128.github.io/sjasmplus/documentation.html#po_equ) now allows for optional override of page number assigned to the new symbol
- new [$$$ and $$$$ operators](http://z00m128.github.io/sjasmplus/documentation.html#s_expressions) to retrieve "physical" address/page inside DISP block
- instruction `out (c),0` now emits warning (can be suppressed by the "; ok" comment)
- fixed listing of structures using long BLOCK fields (machine code was correct, but listing not)
- fixed some memory leaks, undefined behaviour and unaligned memory access

## [1.16.0](https://github.com/z00m128/sjasmplus/releases/tag/v1.16.0) - 27.7.2020
- `LUA` the new emit warning (v1.15.1) is now suppressible
- Predefined defines extended and renamed (following gcc/clang ones)
- Added [relocation data generator](http://z00m128.github.io/sjasmplus/documentation.html#po_relocate_end), check also [example](https://github.com/z00m128/sjasmplus/tree/master/examples/relocation)
- bugfixes/improvements in parser like: operators `not`, `low`, `high` can be followed also by `(`

## [1.15.1](https://github.com/z00m128/sjasmplus/releases/tag/v1.15.1) - 7.7.2020
- `EQU` now assigns memory page to symbol based on the symbol value and current memory mapping
- this does affect also results of `LABELSLIST` (Issue #111)
- `LUA` emits warning when some machine code is emitted without "ALLPASS" modifier
- `SAVETRD` refactored: fix couple of bugs and make TRD files conform the actual TR-DOS practice
- `SAVETRD`: new "&" modifier to produce "mono-loaders" with extra files appended
- `SAVETRD`: added support for the unofficial 3-letter extensions ("; ok" to suppress warnings)
- `INCTRD` refactored and added support for unofficial 3-letter extensions
- fix issue #108 to detect windows drive letters at beginning of file names with full windows paths
- bugfixes: RAMTOP w/ global device, "r+w" file operations code review, memory buffer overrun in LUA

## [1.15.0](https://github.com/z00m128/sjasmplus/releases/tag/v1.15.0) - 18.5.2020
- added `BPLIST` and `SETBP` to export breakpoints info from asm for Unreal and ZEsarUX emulators
- added ZX-like devices with 2/4/8 MiB of virtual memory
- the fake-sysvars/state of ZXSPECTRUM48/128/... devices reworked, moving stack down by default
- behaviour of `--fullpath` option unified across all platforms and compilers
- `DEFARRAY` has new operator `[#]` to retrieve current size of array.
- `MMU` has new optional third argument to set also address (like `ORG`)
- use of forward reference in `IF`/`IFN` emits only warning, and can be suppressed
- internal Lua updated to 5.1.5 (last official 5.1 version)
- STDIN can be read multiple times (per each "-" argument)
- new macro/lua examples: `sj_sysvars.i.asm`, `section.asm`, `lua_sin_table.asm`, `union_like_structures.asm`
- RAM limit exceeded warning/error reworked to report with more sense, fixed bug with missing labels
- `SAVETRD` warning about invalid extension can be suppressed by "; ok"
- `EMPTYTRD` takes as second argument disc label
- added `--outprefix` option to prefix any output-directive filename (issue #102)

## [1.14.5](https://github.com/z00m128/sjasmplus/releases/tag/v1.14.5) - 30.1.2020
- fix crash when opening source file fails
- [DISP](http://z00m128.github.io/sjasmplus/documentation.html#po_disp)/[ORG](http://z00m128.github.io/sjasmplus/documentation.html#po_org) warns about being used inside DISP block (also docs extended)

## [1.14.4](https://github.com/z00m128/sjasmplus/releases/tag/v1.14.4) - 13.1.2020
- added few example utility macros in tests/macro_examples/sj_library.asm (`neg r16`)
- added [SAVENEX SCREEN BMP](http://z00m128.github.io/sjasmplus/documentation.html#nex_screen) sub-command to include BMP loading-screen
- added support for V1.3 of [NEX file format](http://z00m128.github.io/sjasmplus/documentation.html#c_savenex) (new commands: `CFG3`, `PALETTE`, `COPPER`, new screen modes)
- in lua scripts: `sj.calc(..)` (alias `_c(..)`) now substitutes defines and macro arguments
- error reporting inside LUA and MACRO refactored to give better info about origin of error
- macro-arguments parser now recognizes C++ numeric literals with apostrophe as digits-group separator
- the assembler will instantly exit when run at Big-Endian platform (the rest of code is broken on BE)
- updated syntax-highlight file for KDE5 editors (Kate)

## [1.14.3](https://github.com/z00m128/sjasmplus/releases/tag/v1.14.3) - 15.11.2019
- fix detection of `.end:` and `.END` labels when `--dirbol` is used
- added export of [SLD (Source Level Debugging) data](http://z00m128.github.io/sjasmplus/documentation.html#c_sld_data), see also [NDS (NextDevSystem)](https://github.com/Ckirby101/NDS-NextDevSystem)
- added `--longptr` option to allow labels outside of 16b address space
- docs: added small details about FPOS, SAVETAP, IFUSED
- fix assembling-time reported in linux

## [1.14.2](https://github.com/z00m128/sjasmplus/releases/tag/v1.14.2) - 3.10.2019
- added i8080 mode (`--i8080` CLI option) (it's still Z80 Zilog syntax, just limited instruction set)
- added Sharp LR35902 mode (`--lr35902` CLI option) (100% syntax compatibility with IDA, 95% bgb)
- new `$$label` operator to retrieve page of label
- 1.14.0 include-path bugfix reverted, the "." is again automatically added (*did* break projects)
- small improvements/polish/extra-info in docs, INSTALL, README, few new tests added
- cmake script fix of `SYSTEM_LUA=ON` option, [CirrusCI](https://cirrus-ci.com/github/z00m128/sjasmplus/master) configs added for macOS and FreeBSD
- few fixes of memory leaks, invalid memory access, double free/delete

## [1.14.1](https://github.com/z00m128/sjasmplus/releases/tag/v1.14.1) - 30.8.2019
- refactored `SHELLEXEC` to use clib `system(..)` on all platforms (also MS VS), minor fixes
- [lua example `inc_text`](https://github.com/z00m128/sjasmplus/blob/master/tests/lua_examples/lua_inctext.lua) (result of specific request from sjasmplus user)
- listing fixed when Lua was used to emit bytes and also parsed lines of assembly source
- MinGW windows exe prefers "/" file system delimiter ("\\" should still work on windows (only))
- lot of small bugfixes and Cirrus CI infrastructure adjustments (windows MinGW build does run full tests)
- MS VS builds stabilized and fixed, should now work mostly on par with MinGW builds (99.5%)
- Using [lgtm.com](https://lgtm.com/projects/g/z00m128/sjasmplus/) code analysis (did help to find new bugs and memory leaks)
- [UnitTest++](https://github.com/unittest-cpp/unittest-cpp) framework added for regular C++ unit tests, first few tests added

## [1.14.0](https://github.com/z00m128/sjasmplus/releases/tag/v1.14.0) - 17.8.2019
- `INCLUDE` bugfix, now searching paths according to original documentation (may break some projects)
- `UNDEFINE` had undocumented feature of removing also labels, cancelled (was broken beyond repair)
- R800 `MULUB` was producing wrong opcode all those years... fixed
- `MODULE` names can't contain dot any more, `MODULE` and `ENDMODULE` resets non-local label to `_`
- `--syntax` option: `m` (switch off low-mem access warning) and `M` added, `A` removed
- macro expansion can be inhibited by using `@` in front of instruction
- expression evaluator was not strictly 32 bit (64b binaries could have produced different results than 32b binaries)
- reading memory addresses 0..255 directly emits warning, use `; ok` comment to suppress it.
- several tests added to improve the code coverage: [coveralls.io/github/z00m128/sjasmplus](https://coveralls.io/github/z00m128/sjasmplus?branch=master)
- as tests were added, minor bugs were found and squashed (errors wording, etc)

## [1.13.3](https://github.com/z00m128/sjasmplus/releases/tag/v1.13.3) - 21.7.2019
- bugfixes, new examples (check tests/lua_examples)
- UTF BOM are now detected, UTF8 BOM is silently skipped, UTF16/32 BOMs cause fatal error
- `ZXSPECTRUMNEXT` device is now initialized with whole memory zeroed (no more ZX48 sysvars)
- `DEFL` documented, "no forward reference" rule relaxed for `EQU`
- some error messages reworded to make them easier to comprehend

## [1.13.2](https://github.com/z00m128/sjasmplus/releases/tag/v1.13.2) - 28.6.2019
- `OPT` has now also `listoff` and `liston` commands
- added to `--syntax` option: case insensitive instructions, `bBw` added/changed
- new macro examples, minor fixes and refactoring
- `SAVETRD` implementation refactored (more checks, less bugs, "replace" file feature)
- operators `{address}` and `{b address}` are now official and documented

## [1.13.1](https://github.com/z00m128/sjasmplus/releases/tag/v1.13.1) - 30.05.2019
- added `--syntax` command line option
- added `OPT` directive (modifies some command line options)
- added way to use structure at designed address
- `MACRO` can be now named through label (optional syntax)
- added `DEFARRAY+` directive (for splitting long list of `DEFARRAY` values)
- added `CSPECTMAP` directive for `MAP` files for CSpect emulator
- added support for `SJASMPLUSOPTS` environment variable
- Z80N new variants of syntax, now also `mul de : mul : pixelad hl : pixeldn hl` works
- minor bugfixes, improvements and internal refactorings (error reporting)
- updated syntax-highlight file for KDE5 editors (Kate)

## [1.13.0](https://github.com/z00m128/sjasmplus/releases/tag/v1.13.0) - 05.05.2019
- [may break old sources] `DEVICE`: each assembling pass resets also
  "device". To work with "device" memory (`SAVESNA`, `SAVETAP`, ...) you
  must select the device (and slot and pages) before producing machine
  code which you want to work with (`SAVESNA`, `SAVETAP`, ...).
  If only single `DEVICE` is used in whole source batch, then the setting
  is "global" and will be applied to all lines of source (in 2nd+ pass).
- [may break old sources] `ZXSPECTRUM128` based devices map into slots
  by default banks {7, 5, 2, 0}. (was {0, 5, 2, 7} in older versions)
- [may break old sources] `ZXSPECTRUM128` based devices have sysvars and
  stack set up as in `USR 0` mode (`ZXSPECTRUM48` system variables and
  default stack content).
- [may break old sources] `MAP` + `FIELD` directives removed (`STRUCT` is better and working)
- `MMU` directive (fusing `SLOT` + `PAGE` and extending them)
- `SAVEDEV` directive (similar to `SAVEBIN`)
- `SAVENEX` directive (for ZX Spectrum Next)
- INCBIN: support for negative offset/length values, support for `MMU` wrapping
- INCBIN: support for file chunks of 64+ki size (usable with `MMU`)
- Fixed: `INCTRD` offset, binary `STDOUT` on windows, `SAVETRD`, `SAVEHOB` filenames
- Fixed: LUA used inside macros, LUA get_word, LUA error reporting
- parser: added C++(like) numeric literals
- `ZXSPECTRUMNEXT` device added
- refactoring of label/define implementation = less memory leaks, more correct
  "label.mem_page" values, "Unreal" labels dump is more correct too
- docs: now the CSS file is actually used, and default style modified a bit
- new MACRO examples, syntax-highlight file for KDE5 editors (Kate)

## [1.12.0](https://github.com/z00m128/sjasmplus/releases/tag/v1.12.0) - 07.04.2019
- Fixed parsing of expressions starting with string literal
- Fixed listing of `DS` directive with negative values, added value check warning
- Fixed possible wrong indexing of some arrays internally
- Fixed parsing of single-word instructions in colon-packed-no-space macros
- Making macro arguments substitution a bit more aggressive, to work also with
  `DEFINE`, `IFDEF`, `IFNDEF`, `DEFARRAY` directives inside macro (this gives the coder
  more macro power and freedom, but the error reporting may get lot more confused)
- Refactoring substring substitution for macro-arguments and defines, now it
  should work always. To prohibit some macro/define to substitute into middle
  of the string, start its name with underscore, like "_VERSION".
- THIS MAY BREAK SOME OLDER SOURCES, SORRY. Also the rules for substitutions
  will be in the future further modified and documented, to make them more
  intuitive and predictable, so there may be more breakage even later.
- Adding fake instructions break and exit for CSpect emulator (`--zxnext=cspect`)

## [1.11.1](https://github.com/z00m128/sjasmplus/releases/tag/v1.11.1) - 01.04.2019
- Fixed global labels in `MACRO` and in `IFUSED`, `IFNUSED`
- Fixed nested `IF`-`DUP`-`IF`
- Fixed local labels fail when amount of lines did change between passes
- Fixed Makefile to build when path to project contains space
- Added macro-example: turn `DJNZ .` into `DJNZ $` (to fix Zeus syntax source)
- Added `--msg=lst` and `--msg=lstlab` options to produce listing file to `STDERR`
- Added options to read input file from `STDIN` and output "raw" binary to `STDOUT`

## [1.11.0](https://github.com/z00m128/sjasmplus/releases/tag/v1.11.0) - 22.03.2019
- Added ZX Spectrum Next instructions support
- Added `--msg` option, directives `DG` and `DH`
- Changed listing layout to fixed-width type
- Errors, Warnings and similar are now channeled to `STDERR`
- Fixed string literal parser, added two apostrophes and escaped zero
- Fixed docs templates (HTML is now more valid)
- Fixed nesting `DUP` issue
- Fixed CRLF handling in parser
- Fixed `-D` option for multiple asm files
- Fixed address display when the 64kB limit exceeded
- Fixed lost code when current memory leaves device slot in "disp" mode
- Fixed `IF` inside `MACRO`, `DUP` and `REPT`
- Fixed `ALIGN` behavior and docs wording
- Fixed `INCHOB`, `INCBIN` (offset / length)
- Fixed `INCLUDE`, `INCLUDELUA` system path priority ("" vs <>)
- Fixed `END` behavior
- Fixed `DEFARRAY` to work as documented
- Fixed and refactored `WORD`, `DWORD`, `D24`
- Fixed and extended `STRUCT`
- Multiple bugfixes in listing generation
- Multiple bugfixes of internal code
- Refactored options parser, instruction parser and Warning/Error system
- C++14 standard is now required minimum (to compile sjasmplus sources)
- Added automated-testing scripts, with 50+ tests
- GitHub connected with Cirrus Continuous Integration service

## [1.10.4](https://github.com/z00m128/sjasmplus/releases/tag/v1.10.4) - 09.01.2019
- `Bytes lost` error reworked (and changed to warning)
- Error/warning messages are displayed in last pass only (where possible)
- Fixed 64k limit warnigs
- BinIncFile reworked

## [1.10.3](https://github.com/z00m128/sjasmplus/releases/tag/v1.10.3) - 26.11.2018
- Fixed macro issue with commas inside quotes
- Fixed `IFUSED` and `IFNUSED` directives
- Fixed `STRUCT` directive
- Added support of register operands for operators `HIGH` and `LOW`

## [1.10.2](https://github.com/z00m128/sjasmplus/releases/tag/v1.10.2) - 09.08.2018
- Fixed bug in `UNDEFINE` directive
- Fixed bug in parser line wrapping

## [1.10.1](https://github.com/z00m128/sjasmplus/releases/tag/v1.10.1) - 15.05.2018
- Fixed bug in `OUTPUT` directive (bugfix of flushing buffer)
- Implemented `TAPOUT`, `TAPEND` and `OUTEND` directives

## [1.10.0](https://github.com/z00m128/sjasmplus/releases/tag/v1.10.0) - 06.05.2018
- Implemented full featured `SAVETAP` and `EMPTYTAP` directives

## [1.09](https://github.com/z00m128/sjasmplus/releases/tag/v1.09) - 07.09.2017
- `-D` commandline parameter added
- `INCHOB`, `INCBIN` bugfix

## [1.08](https://github.com/z00m128/sjasmplus/releases/tag/v1.08) - 23.12.2016
- a lot of compilation warnings were cleaned up
- CMake build method implemented

## [1.07-rc9](https://github.com/z00m128/sjasmplus/releases/tag/v1.07-RC9) - 11.10.2016
- a few compilation warnings were cleaned up
- documentation was added

## [1.07-rc8](https://github.com/z00m128/sjasmplus/releases/tag/v1.07-RC8) - 05.05.2016
- new makefile
- compilation errors fixed
- a few compilation warnings were cleaned up

## [1.07-rc7](https://github.com/z00m128/sjasmplus/releases/tag/v1.07-RC7)
- Added new `SAVETAP` pseudo-op. It's support up to 1024kb ZX-Spectrum's RAM
- Added new `--nofakes` commandline parameter
- Another fix of 48k SNA snapshots saving routine
- Added new `UNDEFINE` pseudo-op
- Added new `IFUSED`, `IFNUSED` pseudo-ops for labels (such `IFDEF` for defines)
- Fixed labels list dump rountine (`--lstlab` command line parameter)

## 1.07-rc6 - 27.03.2008
- Applied bugfix patches for `SAVEHOB`, `SAVETRD` pseudo-ops by Breeze
- Fixed memory leak in line parsing routine
- Fixed 48k SNA snapshots saving routine
- Added missing `INF` instruction
- Fixed code parser's invalid addressing of temporary labels in macros

## 1.07-rc5bf - 31.05.2007
- Bugfix patches by Ric Hohne
- Important bugfix of memory leak
- Bugfix of strange crashes at several machines
- Added yet another sample for built-in LUA engine. See end of this file
- Added sources of CosmoCubes demo to the "examples" directory

## 1.07-rc5 - 13.05.2007
- `ALIGN` has new optional parameter
- Corrected bug of RAM sizing
- Corrected bug of structures naming

## 1.07-rc4bf - 02.12.2006
- Corrected important bug in code generation functions of SjASMPlus

## 1.07-rc4 - 28.11.2006
- Corrected bug with `SAVEBIN`, `SAVETRD` and possible `SAVESNA`
- Add Makefile to build under Linux, FreeBSD etc

## 1.07-rc3 - 12.10.2006
- `SAVESNA can save 48kb snapshots
- Corrected `DEFINE` bug
- Corrected bug of incorrect line numbering

## 1.07-rc2 - 28.09.2006
- `SAVESNA` works and with device `ZXSPECTRUM48`
- Added new device `PENTAGON128`
- In `ZXSPECTRUM48` device and others attributes has black ink and white paper by default

## 1.07-rc1bf - 23.09.2006
- Corrected bug with `_ERRORS` and `_WARNINGS` constants
- Added error message, when `SHELLEXEC` program execution failed

## 1.07-rc1 - 17.09.2006
- 3-pass design
- Built-in Lua scripting engine
- Changed command line keys
- Documentation converted to HTML
- Added new directives: `DEVICE`, `SLOT`, `SHELLEXEC`
- Added predefined constanst: `_SJASMPLUS=1`, `_ERRORS` and other
- Changed output log format
- And many many more

## 1.06 Stable - 2006.08.02
- Corrected bug in `INCTRD`
- Added version of compiler for DOS

## 1.06-rc3 - 2006.07.25
- Corrected some important bugs

## 1.06-rc2bf - 2006.04.23
- Corrected bug in `LABELSLIST`

## 1.06rc2 - 2006.04.20
- Corrected bugs in `STRUCT`, `ENDS`
- Applied changes from new version of SjASM 0.39g:
	- `ENDMAP` directive
	- `DEFM` and `DM` synonyms for `BYTE`
- Some bug fixes:
	- file size is reset when a new output file is opened
	- `bytes lost` warning fixed
And thanks to Konami Man:
  - `PHASE` and `DEPHASE` directives as synonyms of `TEXTAREA` and `ENDT`
  - `FPOS` directive.
  - Expanded `OUTPUT` directive.
  - The possibility to generate a symbol file.

## 1.06-rc1 - 2006.01.19
- WARNING! To enlarge compatibility of the SjASMPlus with other assemblers, the key `-B` ENABLES(but no disables) possibility writing pseudo-ops from the beginning of line.
- Corrected bug with chars which position in ascii table is more than 127
- Corrected bug with `DISP`, `ENT`
- Added new pseudo-op `DEFM`, `DM` as synonym of `DB`, `DEFB`, `BYTE`
- `DEFL`(this is new pseudo-op) and `LABEL=...` can be redefined
- Corrected bug with temporary labels in `DUP`, `REPT`
- New pseudo-op `DEFARRAY` to create array of DEFINEs. Can not be redefined

## 1.05 Stable
- Corrected bug with including external files
- Now sjasm.exe has icon.
- To distributive included version for FreeBSD
- Corrected bug, when `END` could not be a label
- Added new key `-B`

## 1.05-rc3
- Corrected small bug of directive processing
- Added support of {..} as in Alasm (see below)
- Added possibility to write commands ADC,ADD,AND,BIT and etc throught comma: XOR B,C,A ;---> XOR B / XOR C / XOR A

## 1.05-rc2
- Second very important fix of procedure of line reading
- Corrected bug in `INCTRD`
- Added possibility to write commands LD,INC,DEC,CALL,DJNZ,JP,JR throught comma (in test mode!): LD A,D,A,0,HL,100h or INC A,B,C,D,A,A etc

## 1.05-rc1
- Very important fix of procedure of line reading

## 1.05 (debug)
- Now you can write directives from the beginning of line
- Added directive `.<expression> <code>`, where `<expression>` - count of repeats, `<code>` - code, which need to repeat
- Corrected small bug of `IF` and `IFN`
- Added directive `LABELSLIST` (by Kurles^HS^CPU)
- Added directive `DISPLAY` analogue of Alasm's directive (by Kurles^HS^CPU)
- Added directives `EMPTYTRD`, `SAVETRD`, `INCHOB`, `INCTRD`
- Remade procedure of lines reading (added support of end lines codes of Mac and Unix)
- Added support of resting of `DUP`, `REPT` and synonym of `EDUP` -- `ENDR`
- Corrected error with macros

## 1.04 (debug)
- Speeded up! 250000 lines of code compiles with 1.15 sec instead of 2.5 sec! And SjASMPlus will no more eat so much RAM.
- Added support of encodings (WIN/DOS) --- directive `ENCODING` and key `-d` (by Kurles^HS^CPU)
- Added directive `IFN` an opposition of `IF`

## 1.03 (debug)
- Added counter of compiled lines
- Added directive `SAVEHOB`, which saves block of memory in Hobeta format (by Kurles^HS^CPU)
- Corrected bug with using <..> in directives `INCLUDE`, `INCBIN` and etc (by Kurles^HS^CPU)

## 1.02 (debug)
- New synonym of `INCBIN` -- `INSERT`
- Added support of ZX-Spectrum memory. Use key `-m` for this.
- With key `-m` enabling new directives `PAG`E, `SAVESNA`, `SAVEBIN` and extra parameter of `ORG <address>,<pagenumber>`
- Added directives `DISP`, `ENT` (`PHASE`, `UNPHASE`, `DEPHASE`)
- Speeded up. 250000 lines of code compiles with 2.5 sec instead of 7 sec!
- Max length of line now is 1024 bytes

## 1.01 alpha
- Added synonym of EX AF,AF' -- EXA
- Corrected small bug with DEFINEs
- Small speed up
- Added support of single quotes for `BYTE`, `DB`, `DC`, `DZ`, in which don't working slash (example \n will be \n, but not carry to new line)
- Commented all changes in sources
- -Q & -L was returned (yet in test mode)

## 1.00 alpha
- Added key `-P` which enabled reverse compiling of POP (i.e POP  AF,BC will be compiled to pop  bc / pop  af)
- Support code throught colon (LD A,C:INC A:PUSH AF:IFDEF FX:LD A,D:ENDIF...)
- New synonym of `REPT` -- `DUP`
- Synonyms of IXH,IXL and IYH,IYL: XH,XL,LX,HX,YH,YL,HY,LY
- Corrected small bugs (with SIZE and other)
- Shortened listing file was more friendly
- Display time of compilation

## 0.39f
- Maximum, minimum, and, or, mod, xor, not, shl, shr, low and high operators added.
- Logical operations result in -1 or 0 instead of 1 or 0. Of course, -1 for true and 0 for false ;)
- Fixed the "ifdef <illegal identifier>" bug

## 0.30
- `#` Can be used now to indicate a hexadecimal value
- Local "number" labels should really work now
- Multiple error messages per source line possible
- Things like ld a,(4)+1 work again (=> ld a,5). Somehow I broke this in v0.3
- Filenames don't need surrounding quotes anymore
- Macro's can be nested once again
- Better define-handling
- `Textarea` detects forward references
- Include within include searches relative to that include
- Unlocked some directives (assert, output)
- `#` Can be used in labels
- No space needed between label and `=` in statements like `label=value`
- The `export` directive now exports `label: EQU value` instead of `label = value`
- Labelnames starting with a register name (like HL_kip) shouldn't confuse SjASM anymore
- RLC, RRC, RL, RR, SLA, SRA, SLL (SLI), RES and SET undocumented instructions added
- `ex af,af` and `ex af` are possible now
- Added defb, defw and defs
- Locallabels now also work correctly when used in macros
- Added `//` and limited `/* */` comments
- SjASM now checks the label values between passes
- `>>>` Operator added
- Sources included
- `>>>` And `>>` operators now work the way they should (I think)
- Removed the data/text/pool-bug. (Together with the data/text/pool directives. ~8)
- Added `endmodule` and `endmod` to end a module
- `STRUCT` directive
- `REPT`, `DWORD`, `DD`, `DEFD` directives
- More freedom with character constants; in some cases it's possible to use double quotes...
- It's now possible to specify include paths at the command line
- Angle brackets are used now to include commas in macroarguments. So check your macro's
- Fixed a structure initialization bug
- It's not possible to use CALLs or jumps without arguments anymore
- `DZ` and `ABYTEZ` directives to define null terminated strings
- SjASM now checks for lines that are too long
- Added "16 bit" LD, LDI and LDD instructions
- PUSH and POP accept a list of registers
- Added "16 bit" SUB instruction
- Unreferenced labels are indicated with an 'X' in the labellisting
- Unknown escapecodes in strings result in just one error (instead of more)
- Labelnameparts now have a maximum of 70 characters
- Improved IX and IY offset checking

## 0.2
- SjASM v0.3x assumes Z80-mode as there are no other cpus supported
- All calculations are 32 bits
