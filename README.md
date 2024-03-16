# FoxyOS v0.02
Welcome to the FoxyOS page written in nasm x86. FoxyOS is light and fast operation system, with frequent updates.

❗ Attention: there are new versions of FoxyOS, support for this version will end on 08.04.

▪ language in files (comments) - Russian

▪ Real size (Code): 54 bytes

# New features
- Output "Welcome..." text.

# System Requirements
- CPU: 8086 CPU
- GPU: any
- RAM: 512 byte
- Motherboard: support BIOS

# Features
- It starts
- Output "Welcome..." 😀
- No user input
- No internet service
- No sounds
- No filesystem

# File hierarchy
1. build directory - iso image, bin files
2. source directory - Code of FoxyOS (boot.asm, kernel/print.asm)
3. Documentation.txt - There are missing comments that are often repeated in code

# Compile
1. Compile assembly files with nasm to bin file. (Command: nasm -f bin boot.asm -o boot.bin)
2. Compile bin file to iso image with UltraISO, PowerISO, etc...
3. Done!

# Photo
<img src="Screenshot.PNG" alt="" title="FoxyOS">
