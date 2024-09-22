# N-UNIX (NES Unix)

N-UNIX is a Family BASIC ROM hack which extends functionality to that closer to a computer at the time. It uses a specialized cartridge to perform its tasks.

## Expansions

TBD

## Building

Make sure to include and build the cc65 toolchain

```bash
git submodule update --init --recursive
cd cc65
make -j8
```

Then run `make` to build the project
