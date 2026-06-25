const std = @import("std");
const Io = std.Io;

const wc = @import("wc");

const Count = struct {
    lines: usize = 0,
    words: usize = 0,
    bytes: usize = 0,
};

fn processFile(reader: *std.Io.File.Reader) !Count {
    var count = Count{};
    var in_word = false;

    while (true) {
        const c = reader.interface.takeByte() catch |err| switch (err) {
            error.EndOfStream => break,
            else => return err,
        };
        count.bytes += 1;
        if (c == '\n') count.lines += 1;
        if (c == ' ' or c == '\t' or c == '\n' or c == '\r') {
            in_word = false;
        } else if (!in_word) {
            in_word = true;
            count.words += 1;
        }
    }
    return count;
}

pub fn main(init: std.process.Init) !void {
    const io = init.io;

    var stdout_buffer: [1024]u8 = undefined;
    var stdout_file_writer: Io.File.Writer = .init(.stdout(), io, &stdout_buffer);
    const stdout = &stdout_file_writer.interface;

    const args = try init.minimal.args.toSlice(init.arena.allocator());

    if (args.len < 2) {
        try stdout.print("To few arguments, please pass a path\n", .{});
    }

    const cwd = std.Io.Dir.cwd();
    const file = try cwd.openFile(io, args[1], .{ .mode = .read_only });
    defer file.close(io);

    var read_buffer: [4096]u8 = undefined;
    var file_reader = file.reader(io, &read_buffer);

    const count = try processFile(&file_reader);

    try stdout.print("The file {s} contains: \nlines: {d}\nwords: {d}\nbytes: {d}\n", .{ args[0], count.lines, count.words, count.bytes });

    try stdout.flush();
}
