# Using

1. Clone pico-sdk somewhere (https://github.com/raspberrypi/pico-sdk)
2. Set PICO_SDK_PATH to its location:  `export PICO_SDK_PATH=/where/it/is/pico-sdk`)
3. `mkdir build`
4. `cd build`
5. `cmake ..`
6. `make`

You might need some packages:  
`sudo apt install cmake python3 build-essential gcc-arm-none-eabi libnewlib-arm-none-eabi libstdc++-arm-none-eabi-newlib`