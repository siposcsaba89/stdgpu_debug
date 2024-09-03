#include <iostream>
#include <stdgpu/unordered_map.cuh>
#include <thrust/device_vector.h>
#include <thrust/host_vector.h>

struct A
{
    int a;
    int b;

    __host__ __device__ bool operator==(const A& other) const
    {
        return a == other.a && b == other.b;
    }
};

struct B
{
    int a;
    int b;
};

struct HashA
{
    __host__ __device__ std::size_t operator()(const A& key) const
    {
        return key.a;
    }
};

__global__ void insetr(stdgpu::unordered_map<A, B, HashA> map)
{
    int g_id = blockIdx.x * blockDim.x + threadIdx.x;
    map.emplace(A{g_id, 2 }, B{ 3, 4 });
}

int main() 
{
    stdgpu::unordered_map<A, B, HashA> map = stdgpu::unordered_map<A, B, HashA>::createDeviceObject(16 * 16);

    insetr << <16, 16 >> > (map);
    cudaDeviceSynchronize();

    auto range_map = map.device_range();

#define OLD_WORKING_CODE 1
#if OLD_WORKING_CODE
    thrust::host_vector<stdgpu::pair<A, B>> host_pairs(map.size());
    thrust::copy(range_map.begin(), range_map.end(), host_pairs.begin());
#else
    thrust::device_vector<stdgpu::pair<A, B>> device_pairs(map.size());
    thrust::copy(range_map.begin(), range_map.end(), device_pairs.begin());
    thrust::host_vector<stdgpu::pair<A, B>> host_pairs = device_pairs;
#endif
    cudaDeviceSynchronize();
    for (const auto& pair : host_pairs)
    {
        std::cout << pair.first.a << " " << pair.first.b << " " << pair.second.a << " " << pair.second.b << std::endl;
    }

    std::cout << "Hello, World!" << std::endl;
    return 0;
}