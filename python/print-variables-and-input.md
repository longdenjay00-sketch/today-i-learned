# Python print, names, and input

2026-11-17

`print` writes a line. A name is case-sensitive, so `name` and `Name` are different variables. `input` always returns a `str`, and a number typed at the keyboard needs `int`.

```python
name = "Epic"
teacher = "Yoda"
print(f"{name} loves learning python from {teacher}!")

name = input("what is your name? ")
food = input("whats your favorite food? ")
age = int(input("how old are you? "))
print(f"hey, {name}, i heard {food} is your favorite. are you {age}?")
```

`type("69")` is `str` because of the quotes. `int("69")` is the number.
