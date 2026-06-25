# wc-zig

A tiny `wc`-style command-line tool written in Zig. It reads a file and reports the number of **lines**, **words**, and **bytes** it contains.

This was built as a learning project to explore Zig's standard library — explicit allocators, the `std.Io` reader/writer interface, and the `Init`-style `main`.

## Requirements

- [Zig](https://ziglang.org/) 0.16.0 or later

The project relies on the I/O-as-interface APIs (`std.Io.Dir`, `std.Io.File`) introduced in 0.16, so older versions won't compile. Check your version with:

```
zig version
```

## Build & run

Run it directly through the build system, passing a file path after `--`:

```
zig build run -- path/to/file.txt
```


## License

MIT
