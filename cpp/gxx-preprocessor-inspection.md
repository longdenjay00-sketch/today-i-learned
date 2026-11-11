# Deep Dive: Inspecting the C++ Preprocessor with `g++ -E`

2026-11-10

Before the compiler analyzes types, builds abstract syntax trees, or generates machine code, the preprocessor (`cpp`) runs as Stage 1. Halting compilation with `g++ -E` exposes exactly what the compiler receives after macro expansion, file inclusion, and conditional directives are resolved.

---

## 1. What `g++ -E` Does

By default, `g++` compiles, assembles, and links. Passing `-E` halts processing immediately after the preprocessing stage:

```bash
g++ -E main.cpp -o main.i
```

- Preprocessed C++ is traditionally written to files ending in `.i` (preprocessed C) or `.ii` (preprocessed C++).
- If `-o` is omitted, `g++ -E` streams the expanded text directly to `stdout`.

---

## 2. What Happens During Preprocessing

1. **Comment Stripping:** Every single-line (`//`) and multi-line (`/* */`) comment is replaced by a single whitespace character.
2. **Header Inlining (`#include`):** The preprocessor opens every included header and literally copy-pastes its content into the translation unit recursively.
   - A 5-line `hello.cpp` that includes `<iostream>` expands to over **25,000 to 30,000 lines** of type declarations, templates, and inline functions.
3. **Macro Replacement (`#define`):** Macro identifiers and function-like macros are substituted with their replacement tokens.
4. **Conditional Compilation (`#if`, `#ifdef`, `#ifndef`, `#elif`, `#endif`):** Branches evaluating to false are completely discarded. The compiler proper never sees omitted blocks.
5. **Pragma Evaluation:** Directives like `#pragma once` are parsed to prevent multiple header inclusions.

---

## 3. Understanding Linemarkers (Sync Lines)

When inspecting `g++ -E` output, you will see thousands of lines formatted like:

```cpp
# 1 "/usr/include/c++/13/iostream" 1 3
```

These are **linemarkers**. They communicate metadata back to the compiler and debugger:
- Form: `# <line_number> "<filename>" <flags>`
- Flag `1`: Indicates the start of a new included file.
- Flag `2`: Indicates returning to a file after exiting an included file.
- Flag `3`: Indicates the following text comes from a system header (suppressing standard user warnings).
- Flag `4`: Indicates the following text should be treated as wrapping an `extern "C"` block.

### Stripping Linemarkers (`-P`)
To inspect purely the expanded source without linemarker noise, combine `-E` with `-P`:

```bash
g++ -E -P main.cpp -o main_clean.ii
```

---

## 4. Dumping Preprocessor Macros (`-dM` vs `-dD`)

One of the most powerful diagnostics in systems programming is inspecting preprocessor state:

### Dump All Active Macros (`-dM`)
Reveals every built-in macro, architecture flag, and compiler feature macro (e.g. `__aarch64__`, `__GNUC__`, `__cplusplus`):

```bash
# Inspect all built-in compiler macros on this host:
g++ -std=c++20 -E -dM - < /dev/null | grep -iE 'cplusplus|aarch64|gnuc'
```

Output highlights:
```text
#define __cplusplus 202002L
#define __aarch64__ 1
#define __GNUC__ 14
```

### Dump Macros Alongside Code (`-dD`)
Pass `-dD` to output both `#define` directives and the preprocessed source code:

```bash
g++ -E -dD main.cpp
```

---

## 5. Practical Use Cases for `-E`

| Scenario | Diagnostic Command |
| :--- | :--- |
| **Verify Header Resolution** | `g++ -E -H main.cpp -o /dev/null` (Prints tree of included header paths) |
| **Debug Macro Conflicts** | `g++ -E -P main.cpp \| grep -A 5 "my_macro"` |
| **Check Active Standard Version** | `g++ -std=c++20 -E -dM - < /dev/null \| grep __cplusplus` |
| **Trace Undefined Symbols** | Inspect `.ii` output to confirm if a forward declaration actually exists |
