# Comprehensive Reference: Essential and Advanced `g++` Compiler Flags

2026-11-10

A structured, verbose technical reference guide to GCC / `g++` command-line flags for modern C++ development, performance profiling, hardening, and debugging.

---

## 1. Compilation Pipeline Control

| Flag | Purpose | Mechanics |
| :--- | :--- | :--- |
| `-E` | **Preprocess only** | Halts after Stage 1. Expands `#include`, `#define`, strips comments. Outputs to `stdout` or `-o <file>.i`. |
| `-S` | **Compile to Assembly** | Halts after Stage 2. Generates human-readable assembly instructions (`.s`). |
| `-c` | **Compile to Object File** | Halts after Stage 3 (Assembler). Emits machine code object files (`.o`) without invoking the linker. |
| `-o <file>` | **Output Target** | Names the generated output (executable, object file, or intermediate file). Defaults to `a.out`. |
| `-v` | **Verbose Output** | Prints compiler version, target triplet (`aarch64-linux-gnu`), include search paths, and linker invocations. |
| `-save-temps` | **Preserve Intermediates** | Persists all intermediate files (`.i`, `.s`, `.o`) alongside the source file for low-level inspection. |

---

## 2. Language Standard Specification (`-std=`)

Always pin the standard explicitly. Omitting `-std` defaults to the compiler release's GNU standard dialect.

| Flag | Dialect | Key Standard Features |
| :--- | :--- | :--- |
| `-std=c++11` | C++11 | `auto`, lambdas, rvalue references (`std::move`), `std::unique_ptr`, `constexpr`. |
| `-std=c++14` | C++14 | Generic lambdas, relaxed `constexpr`, `std::make_unique`. |
| `-std=c++17` | C++17 | Structured bindings, `std::string_view`, `std::optional`, `std::filesystem`, `if constexpr`. |
| `-std=c++20` | C++20 | Concepts, ranges, coroutines, 3-way comparison (`<=>`), `std::format`, `std::span`. **(Standard baseline)** |
| `-std=c++23` | C++23 | Explicit object parameters (`deducing this`), `std::expected`, multidimensional subscripts. |
| `-std=gnu++20`| GNU Dialect | C++20 plus GNU compiler extensions (non-standard GCC built-ins, inline assembly syntax). |

---

## 3. Diagnostics & Warning Management

GCC diagnostics catch architectural flaws, undefined behavior, and implicit conversions before code reaches production.

### Diagnostic Tiers
```bash
# Tier 1: Baseline development
g++ -std=c++20 -Wall -Wextra -Wpedantic main.cpp

# Tier 2: Hardened / Zero-Tolerance production
g++ -std=c++20 -Wall -Wextra -Wpedantic -Wconversion -Wshadow -Werror main.cpp
```

| Flag | Category | Diagnostic Behavior |
| :--- | :--- | :--- |
| `-Wall` | Core Warnings | Catches uninitialized variables, unused variables, missing return paths, array bounds. |
| `-Wextra` | Deep Warnings | Checks signed/unsigned comparisons, empty bodies, unused function arguments. |
| `-Wpedantic` | ISO Compliance | Rejects non-standard compiler extensions and GNU syntax leaks. |
| `-Werror` | Fatal Warnings | Treats every single warning as a compilation error. Halts build immediately. |
| `-Wshadow` | Variable Scoping | Warns when a local variable shadows an outer-scope or member variable. |
| `-Wconversion` | Type Safety | Warns on implicit conversions that may alter values (e.g. `double` to `int`, 64-bit to 32-bit). |
| `-Wsign-conversion` | Signedness | Flags implicit signed-to-unsigned and unsigned-to-signed conversions. |
| `-Wnull-dereference` | Memory Safety | Flags code paths guaranteed to dereference null pointers (requires optimization `-O2`). |
| `-Wold-style-cast` | Modern C++ | Flags C-style casts (`(int)x`) in favor of explicit `static_cast` or `reinterpret_cast`. |
| `-Wuninitialized` | Memory State | Detects variables read before initialization. |
| `-Wformat=2` | I/O Safety | Validates format strings in `printf` and family against passed argument types. |

---

## 4. Optimization Profiles (`-O`)

| Level | Profile | Mechanics & Use Case |
| :--- | :--- | :--- |
| `-O0` | **No Optimization** | Fastest compilation time. Instructions mirror source code line-by-line. Default if omitted. |
| `-Og` | **Debug Optimized** | Preserves precise call stacks and variable inspection while applying basic optimizations. Best for `gdb`. |
| `-O1` | **Basic Optimization** | Simple peephole and dead-code elimination. |
| `-O2` | **Standard Production** | Heavy optimization without size-speed trade-offs: inlining, loop vectorization, constant folding. |
| `-O3` | **Aggressive Optimization** | Enables loop unrolling, aggressive function inlining, and SIMD auto-vectorization. |
| `-Os` | **Size Optimization** | Optimizes binary for smallest storage footprint (strips code duplication, restricts inlining). |
| `-Ofast` | **Disregard IEEE 754** | Turns on `-O3` plus `-ffast-math` (violates strict floating-point standards; handles NaNs inconsistently). |
| `-flto` | **Link-Time Optimization** | Optimizes across separate translation units (`.o`) during final linking stage. Dramatically shrinks call sites. |
| `-march=native`| **Host Architecture** | Emits instructions tailored exclusively for the host CPU (e.g. specific ARM NEON or AVX extensions). |

---

## 5. Debugging & Symbol Generation (`-g`)

| Flag | Function |
| :--- | :--- |
| `-g` | Generates standard OS DWARF debug information for `gdb` / `lldb`. |
| `-g3` | Maximum debug info: includes preprocessor macro definitions inside debug tables. |
| `-s` | Strips all symbol tables and relocation information from final binary to minimize size. |

---

## 6. Dynamic Sanitizers (`-fsanitize=`)

Sanitizers instrument binaries with runtime assertions to detect memory corruption and undefined behavior at near-native execution speed.

```bash
# Debug build instrumented with Address & Undefined Behavior Sanitizers:
g++ -std=c++20 -g -Og -fsanitize=address,undefined -fno-omit-frame-pointer main.cpp -o app_sanitized
```

| Sanitizer Flag | Defect Detected |
| :--- | :--- |
| `-fsanitize=address` (ASan) | Out-of-bounds access, use-after-free, double-free, stack buffer overflow. |
| `-fsanitize=undefined` (UBSan)| Integer overflow, null pointer dereference, misaligned memory access, zero division. |
| `-fsanitize=thread` (TSan) | Multi-threaded data races and deadlocks. (Incompatible with ASan). |
| `-fsanitize=leak` (LSan) | Memory allocations never freed prior to process exit. |
| `-fno-omit-frame-pointer` | Preserves frame pointers (`RBP`/`FP`) to produce clean, legible stack traces upon crash. |

---

## 7. Preprocessor, Include & Linker Flags

| Flag | Purpose | Syntax Example |
| :--- | :--- | :--- |
| `-I<path>` | Header Search Path | `g++ -I./include main.cpp` |
| `-isystem <path>` | System Header Path | Treats included path as a system directory, suppressing external library warnings. |
| `-D<name>=<val>` | Define Macro | `g++ -DNDEBUG -DVERSION="2.1"` |
| `-U<name>` | Undefine Macro | `g++ -UDEBUG main.cpp` |
| `-L<path>` | Library Search Path | `g++ -L./lib main.cpp` |
| `-l<name>` | Link Shared/Static Lib | `g++ main.cpp -lpthread -lsqlite3` (links `libpthread.so`, `libsqlite3.so`). |
| `-static` | Static Linkage | Bundles libc and C++ runtime into binary, producing a standalone executable. |
| `-fPIC` | Position Independent Code | Required when compiling `.o` files intended for shared libraries (`.so`). |
| `-shared` | Build Shared Object | Emits a `.so` library instead of an executable binary. |
| `-Wl,-rpath=<dir>` | Runtime Library Path | Bakes the dynamic library runtime search directory directly into the ELF header. |

---

## 8. Low-Level Mechanics & Embedded Flags

| Flag | Effect |
| :--- | :--- |
| `-fno-exceptions` | Completely disables C++ exception handling overhead (`try`/`catch`/`throw`). Saves binary size. |
| `-fno-rtti` | Disables Run-Time Type Information (`typeid`, `dynamic_cast`). Common in embedded & game engines. |
| `-fstack-protector-strong` | Inserts stack canary guards to detect buffer overflow attacks before function return. |

---

## 9. Recommended Operator Profiles

### Development / Debug Profile
```bash
g++ -std=c++20 -Wall -Wextra -Wpedantic -g -Og \
    -fsanitize=address,undefined -fno-omit-frame-pointer \
    main.cpp -o app_dev
```

### Production / Release Profile
```bash
g++ -std=c++20 -Wall -Wextra -Wpedantic -Wconversion -Werror \
    -O3 -DNDEBUG -flto -s \
    main.cpp -o app_release
```
