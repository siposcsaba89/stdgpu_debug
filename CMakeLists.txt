cmake_minimum_required(VERSION 3.15)
cmake_policy(SET CMP0104 NEW)
project(stdgpu_debug LANGUAGES CXX CUDA)

find_package(CUDAToolkit REQUIRED)
find_package(Thrust REQUIRED)

include(FetchContent)

FetchContent_Declare(
  stdgpu
  GIT_REPOSITORY git@github.com:stotko/stdgpu.git
  GIT_TAG        master # release-1.10.0
)
FetchContent_MakeAvailable(stdgpu)



add_executable(stdgpu_debug main.cu)
set_target_properties(stdgpu_debug PROPERTIES
    CXX_STANDARD 17
    CXX_STANDARD_REQUIRED ON
    CUDA_STANDARD 17
    CUDA_STANDARD_REQUIRED ON
    DEBUG_POSTFIX d
    RELWITHDEBINFO_POSTFIX rd
    CUDA_ARCHITECTURES "61"
    CUDA_RUNTIME_LIBRARY Shared
)

target_link_libraries(stdgpu_debug PRIVATE
    CUDA::cudart
    stdgpu::stdgpu
    Thrust::Thrust
)