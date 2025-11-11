### RayWars : Opening crawl example program


![alt](img/raywars_v0.1.gif)

#### Prerequisites

---

Install `gcc, make`

#### Download Raylib library

---
1. cd `your_work_dir`
1. `git clone https://github.com/dinau/raywars` 
1. Download Raylib binary for Windows: [raylib-5.5_win64_mingw-w64.zip](https://github.com/raysan5/raylib/releases/download/5.5/raylib-5.5_win64_mingw-w64.zip) (for Linux: [raylib-5.5_linux_amd64.tar.gz](https://github.com/raysan5/raylib/releases/download/5.5/raylib-5.5_linux_amd64.tar.gz)) then extracts it.
1. Rename the folder name to `raylib` from `raylib-5.5_win64_mingw-w64` (or `raylib-5.5_linux_amd64`).
1. Copy raylib  
Windows:  `cp -r raylib raywars/libs/win/`  
Linux: `cp -r raylib raywars/libs/linux/`  
Folder structure:

   ```sh
   your_work_dir
    `-- raywars
        |-- libs
        |   |-- win
        |   |   `-- raylib
        |   `-- linux
        |       `-- raylib
        `-- src
            |-- c
            |-- luajit
            snip
   ```

#### Programs

##### C  

---

[raywars.c](src/c/raywars.c)

```sh
pwd raywars/src/c
make run
```

If you are on Linux,

```sh
LD_LIBRARY_PATH=../../libs/linux/raylib/lib make run
```

#####  Nim 

---

raywars.nim

#####  Nelua

---

raywars.nelua

#####  Ruby

---

raywars.rb

#####  LuaJIT

---

raywars.lua

#####  Python

---

raywars.lua
