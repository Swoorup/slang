// syntax-error-op-line-3.slang

// NOTE! That although this is a 'diagnostic' like test, it tests using downstream compiler
// the downstream compiler being present is a requirement, so we mark as a 'TEST' so that
// those tests are made.

//TEST:SIMPLE(filecheck=CHK):-entry computeMain -target spirv -emit-spirv-via-glsl
//TEST:SIMPLE(filecheck=CHK):-entry computeMain -target dxil -profile cs_6_0
//TEST:SIMPLE(filecheck=CHK):-entry computeMain -target dxbc
//TEST:SIMPLE(filecheck=CHK):-entry computeMain -target shader-dll
//TEST:SIMPLE(filecheck=CHK):-entry computeMain -target ptx

//TEST_INPUT:ubuffer(data=[0 0 0 0], stride=4):out,name outputBuffer
RWStructuredBuffer<int> outputBuffer;

// Here the thing being checked is error reporting around return, and +=

[__unsafeForceInlineEarly]
int doSomething(int a)
{
    a += a;

    return a
    +=
    __SyntaxError();
}

[shader("compute")]
[numthreads(4, 1, 1)]
void computeMain(uint3 dispatchThreadID : SV_DispatchThreadID)
{
    int id = int(dispatchThreadID.x);

    int v = int(dispatchThreadID.y);


    //CHK:([[#@LINE+1]]): error
    v += doSomething(id);

    outputBuffer[id] = v;
}
