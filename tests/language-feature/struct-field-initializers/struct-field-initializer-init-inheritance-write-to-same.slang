//TEST(compute, vulkan):COMPARE_COMPUTE(filecheck-buffer=BUF):-vk -compute -entry computeMain 
//TEST(compute, vulkan):COMPARE_COMPUTE(filecheck-buffer=BUF):-vk -compute -entry computeMain -emit-spirv-directly
//TEST(compute, vulkan):COMPARE_COMPUTE(filecheck-buffer=BUF):-cpu -compute -entry computeMain
//TEST(smoke,compute):COMPARE_COMPUTE(filecheck-buffer=BUF):-dx12 -use-dxil -compute -entry computeMain

#pragma warning(disable:30816)


//TEST_INPUT:ubuffer(data=[0 0], stride=4):out,name=outputBuffer
RWStructuredBuffer<int> outputBuffer;

struct DefaultStructWithInit_base
{
    int data0 = 3;
    int data1 = 0;
};

struct DefaultStructWithInit : DefaultStructWithInit_base 
{
    __init()
    {
        data1 = 3;
    }
};

[numthreads(1, 1, 1)]
void computeMain(uint3 dispatchThreadID: SV_DispatchThreadID)
{
    DefaultStructWithInit withInit = DefaultStructWithInit();
    // BUF: 1
    outputBuffer[0] = true
        && withInit.data0 == 3
        && withInit.data1 == 3
        ;
}