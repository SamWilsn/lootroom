#!/usr/bin/env python3

BREAKS = [
    229,
    4,
    4,
    3,
    3,
    2,
    2,
    2,
    2,
    2,
    2,
    1
]

if sum(BREAKS) != 256:
    raise Exception()

result = bytearray()
index = 0
for ii in range(256):
    if ii >= sum(BREAKS[:index+1]):
        index += 1
    result.append(index)

print(result.hex())
