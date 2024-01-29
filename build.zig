const std = @import("std");

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard optimization options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall. Here we do not
    // set a preferred release mode, allowing the user to decide how to optimize.
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "HLSLcc",
        .target = target,
        .optimize = optimize,
    });

    lib.addIncludePath(.{ .path = "include" });
    lib.addIncludePath(.{ .path = "." });
    lib.addIncludePath(.{ .path = "src" });
    lib.addIncludePath(.{ .path = "src/cbstring" });
    lib.addIncludePath(.{ .path = "src/internal_includes" });
    lib.linkLibCpp();
    lib.addCSourceFiles(std.Build.Step.Compile.AddCSourceFilesOptions{
        .files = &cpp_source_files,
        .flags = &.{"-std=c++11"},
    });
    lib.addCSourceFiles(.{ .files = &c_source_files });

    // This declares intent for the library to be installed into the standard
    // location when the user invokes the "install" step (the default step when
    // running `zig build`).
    b.installArtifact(lib);
    lib.installHeadersDirectory("include", "HLSLcc");
}

const cpp_source_files = [_][]const u8{
    "src/ControlFlowGraph.cpp",
    "src/ControlFlowGraphUtils.cpp",
    "src/DataTypeAnalysis.cpp",
    "src/Declaration.cpp",
    "src/HLSLCrossCompilerContext.cpp",
    "src/HLSLcc.cpp",
    "src/HLSLccToolkit.cpp",
    "src/Instruction.cpp",
    "src/LoopTransform.cpp",
    "src/Operand.cpp",
    "src/Shader.cpp",
    "src/ShaderInfo.cpp",
    "src/UseDefineChains.cpp",
    "src/decode.cpp",
    "src/reflect.cpp",
    "src/toGLSL.cpp",
    "src/toGLSLDeclaration.cpp",
    "src/toGLSLInstruction.cpp",
    "src/toGLSLOperand.cpp",
    "src/toMetal.cpp",
    "src/toMetalDeclaration.cpp",
    "src/toMetalInstruction.cpp",
    "src/toMetalOperand.cpp",
};
const c_source_files = [_][]const u8{
    "src/cbstring/bsafe.c",
    "src/cbstring/bstraux.c",
    "src/cbstring/bstrlib.c",
};
