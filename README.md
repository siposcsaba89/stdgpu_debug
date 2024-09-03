# stdgpu_debug

## Build

```bash
git clone https://github.com/siposcsaba89/stdgpu_debug.git
cd stdgpu_debug
mkdir build
cd build
cmake .. # Note: on linux you may need to specify thrust path, for example -DCMAKE_PREFIX_PATH=/usr/local/cuda/targets/x86_64-linux/
# cmake .. -DCMAKE_PREFIX_PATH=/usr/local/cuda/targets/x86_64-linux/
cmake --build . --target stdgpu_debug
```



