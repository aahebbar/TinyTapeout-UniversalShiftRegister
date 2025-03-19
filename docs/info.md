<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

Works as a Universal Shift Regsiter. Holds the value if 'mode == 0', shifts right if 'mode == 1', shifts left if 'mode == 2' and loads the parallel input to the registers if 'mode == 3'. Also has a 8-bit parallel output.

## How to test

Can be used for the shifting applications. Can act as both left and right shifter. The parallel load and read feature provides the flexibility in use cases.

## External hardware

The inputs parallelIn, serialIn_left and serialIn_right can be fed through the slide switches. The outputs can be observed through a series of LEDs.
