cmake_minimum_required(VERSION 3.13)

include($ENV{PICO_SDK_PATH}/external/pico_sdk_import.cmake)

project(blink_asm C CXX ASM)
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)

pico_sdk_init()

add_executable(blink_asm
    blink.S
)

target_link_libraries(blink_asm
    pico_stdlib
)

pico_add_extra_outputs(blink_asm)
