#define ARRAY_CHECKS

#ifndef NAN

#include <math_constants.h>

#define NAN CUDART_NAN

#endif

#ifndef INFINITY

#include <math_constants.h>

#define INFINITY CUDART_INF

#endif

#include <stdio.h>

__shared__ size_t m_Local[3];

__shared__ char m_shared[40960];

__device__
int getThreadId(){
  return blockIdx.x * blockDim.x + threadIdx.x;
}
__device__
int getThreadIdxx(){
  return threadIdx.x;
}
__device__
int getBlockIdxx(){
  return blockIdx.x;
}
__device__
int getBlockDimx(){
  return blockDim.x;
}
__device__
int getGridDimx(){
  return blockDim.x;
}
__device__
void edu_syr_pcpratts_syncthreads(){
  __syncthreads();
}
__device__
void edu_syr_pcpratts_threadfence(){
  __threadfence();
}
__device__ clock_t global_now;

/*HAMA_PIPES_HEADER_CODE_IGNORE_IN_TWEAKS_START*/

/* before HostDeviceInterface
nvcc generated.cu --ptxas-options=-v
ptxas info    : 8 bytes gmem, 4 bytes cmem[14]
ptxas info    : Compiling entry function '_Z5entryPcS_PiPxS1_S0_S0_i' for 'sm_10'
ptxas info    : Used 5 registers, 104 bytes smem, 20 bytes cmem[1]

after HostDeviceInterface

nvcc generated.cu --ptxas-options=-v

ptxas info    : 72 bytes gmem, 36 bytes cmem[14]
ptxas info    : Compiling entry function '_Z5entryPcS_PiPxS1_S0_S0_iS0_' for 'sm_10'
ptxas info    : Used 5 registers, 112 bytes smem, 20 bytes cmem[1]


nvcc generated.cu --ptxas-options=-v -arch sm_20

ptxas info    : 72 bytes gmem, 72 bytes cmem[14]
ptxas info    : Compiling entry function '_Z5entryPcS_PiPxS1_S0_S0_iS0_' for 'sm_20'
ptxas info    : Function properties for _Z5entryPcS_PiPxS1_S0_S0_iS0_
    0 bytes stack frame, 0 bytes spill stores, 0 bytes spill loads
ptxas info    : Used 12 registers, 24 bytes smem, 104 bytes cmem[0]

*/

#include <string>

#define STR_SIZE 1024

using std::string;

class HostDeviceInterface {
public:
  volatile bool is_debugging; 

  // Only one thread is able to use the
  // HostDeviceInterface
  volatile int lock_thread_id; 

  // HostMonitor has_task
  volatile bool has_task;

  // HostMonitor is done (end of communication)
  volatile bool done;

  // Request for HostMonitor
  enum MESSAGE_TYPE {
    START_MESSAGE, SET_BSPJOB_CONF, SET_INPUT_TYPES,
    RUN_SETUP, RUN_BSP, RUN_CLEANUP,
    READ_KEYVALUE, WRITE_KEYVALUE,
    GET_MSG, GET_MSG_COUNT,
    SEND_MSG, SYNC,
    GET_ALL_PEERNAME, GET_PEERNAME,
    GET_PEER_INDEX, GET_PEER_COUNT, GET_SUPERSTEP_COUNT,
    REOPEN_INPUT, CLEAR,
    CLOSE, ABORT,
    DONE, TASK_DONE,
    REGISTER_COUNTER, INCREMENT_COUNTER,
    SEQFILE_OPEN, SEQFILE_READNEXT,
    SEQFILE_APPEND, SEQFILE_CLOSE,
    PARTITION_REQUEST, PARTITION_RESPONSE,
    LOG, END_OF_DATA,
    UNDEFINED
  };
  volatile MESSAGE_TYPE command;

  // Command parameter
  volatile bool use_int_val1; // in int_val1
  volatile bool use_int_val2; // in int_val2
  volatile bool use_int_val3; // in int_val3
  volatile bool use_long_val1; // in long_val1
  volatile bool use_long_val2; // in long_val2
  volatile bool use_float_val1; // in float_val1
  volatile bool use_float_val2; // in float_val2
  volatile bool use_double_val1; // in double_val1
  volatile bool use_double_val2; // in double_val2
  volatile bool use_str_val1; // in str_val1
  volatile bool use_str_val2; // in str_val2
  volatile bool use_str_val3; // in str_val3

  // Transfer variables (used in sendCommand and getResult)
  volatile int int_val1;
  volatile int int_val2;
  volatile int int_val3;
  volatile long long_val1;
  volatile long long_val2;
  volatile float float_val1;
  volatile float float_val2;
  volatile double double_val1;
  volatile double double_val2;
  volatile char str_val1[STR_SIZE];
  volatile char str_val2[STR_SIZE];
  volatile char str_val3[255];

  enum TYPE {
    INT, LONG, FLOAT, DOUBLE, STRING, STRING_ARRAY,
    KEY_VALUE_PAIR, NULL_TYPE, NOT_AVAILABLE
  };
  volatile TYPE return_type;
  volatile TYPE key_type;
  volatile TYPE value_type;

  volatile bool end_of_data;

  // Response of HostMonitor
  volatile bool is_result_available;

  HostDeviceInterface() {
    init();
  }

  void init() {
    is_debugging = false;
    lock_thread_id = -1;
    has_task = false;
    done = false;
    command = UNDEFINED;
    use_int_val1 = false;
    use_int_val2 = false;
    use_int_val3 = false;
    use_long_val1 = false;
    use_long_val2 = false;
    use_float_val1 = false;
    use_float_val2 = false;
    use_double_val1 = false;
    use_double_val2 = false;
    use_str_val1 = false;
    use_str_val2 = false;
    use_str_val3 = false;
    int_val1 = 0;
    int_val2 = 0;
    int_val3 = 0;
    long_val1 = 0;
    long_val2 = 0;
    float_val1 = 0;
    float_val2 = 0;
    double_val1 = 0;
    double_val2 = 0;
    key_type = NOT_AVAILABLE;
    value_type = NOT_AVAILABLE;
    end_of_data = true;
    is_result_available = false;
  }

  ~HostDeviceInterface() {}
};

__device__ HostDeviceInterface *host_device_interface;

/*HAMA_PIPES_HEADER_CODE_IGNORE_IN_TWEAKS_END*/
__device__ double java_lang_Math_abs8_8_( char * gc_info, double parameter0, int * exception);

__device__ int java_lang_Float_toString9_7_( char * gc_info, float parameter0, int * exception);

__device__ int java_lang_Object_initab850b60f96d11de8a390800200c9a660_( char * gc_info, int * exception);

__device__ void java_lang_Object_initab850b60f96d11de8a390800200c9a66_body0_( char * gc_info, int thisref, int * exception);

__device__ int at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVector_initab850b60f96d11de8a390800200c9a660_9_( char * gc_info, int parameter0, int * exception);

__device__ void at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVector_initab850b60f96d11de8a390800200c9a66_body0_9_( char * gc_info, int thisref, int parameter0, int * exception);

__device__ void at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_assignCenters0_5_a12_( char * gc_info, int thisref, int parameter0, int parameter1, int * exception);

__device__ int java_lang_StringBuilder_append10_5_( char * gc_info, int thisref, int parameter0, int * exception);

__device__ double java_lang_Math_sqrt8_8_( char * gc_info, double parameter0, int * exception);

__device__ double double__array_get( char * gc_info, int thisref, int parameter0, int * exception);

__device__ void double__array_set( char * gc_info, int thisref, int parameter0, double parameter1, int * exception);

__device__ int double__array_new( char * gc_info, int size, int * exception);

__device__ int double__array_new_multi_array( char * gc_info, int dim0, int * exception);

__device__ int int__array_get( char * gc_info, int thisref, int parameter0, int * exception);

__device__ void int__array_set( char * gc_info, int thisref, int parameter0, int parameter1, int * exception);

__device__ int int__array_new( char * gc_info, int size, int * exception);

__device__ int int__array_new_multi_array( char * gc_info, int dim0, int * exception);

__device__ int edu_syr_pcpratts_rootbeer_runtime_KeyValuePair_initab850b60f96d11de8a390800200c9a660_13_13_( char * gc_info, int parameter0, int parameter1, int * exception);

__device__ void edu_syr_pcpratts_rootbeer_runtime_KeyValuePair_initab850b60f96d11de8a390800200c9a66_body0_13_13_( char * gc_info, int thisref, int parameter0, int parameter1, int * exception);

__device__ int java_lang_AbstractStringBuilder_initab850b60f96d11de8a390800200c9a660_5_( char * gc_info, int parameter0, int * exception);

__device__ void java_lang_AbstractStringBuilder_initab850b60f96d11de8a390800200c9a66_body0_5_( char * gc_info, int thisref, int parameter0, int * exception);

__device__ void java_lang_Integer_getChars0_5_5_a14_( char * gc_info, int parameter0, int parameter1, int parameter2, int * exception);

__device__ void java_lang_Long_getChars0_6_5_a14_( char * gc_info, long long parameter0, int parameter1, int parameter2, int * exception);

__device__ int at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVector__array_get( char * gc_info, int thisref, int parameter0, int * exception);

__device__ void at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVector__array_set( char * gc_info, int thisref, int parameter0, int parameter1, int * exception);

__device__ int at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVector__array_new( char * gc_info, int size, int * exception);

__device__ int at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVector__array_new_multi_array( char * gc_info, int dim0, int * exception);

__device__ int java_lang_Double_toString9_8_( char * gc_info, double parameter0, int * exception);

__device__ int java_lang_Integer_toString9_5_( char * gc_info, int parameter0, int * exception);

__device__ int java_lang_String_length5_( char * gc_info, int thisref, int * exception);

__device__ int java_lang_Exception_initab850b60f96d11de8a390800200c9a660_9_( char * gc_info, int parameter0, int * exception);

__device__ void java_lang_Exception_initab850b60f96d11de8a390800200c9a66_body0_9_( char * gc_info, int thisref, int parameter0, int * exception);

__device__ int invoke_java_lang_StringBuilder_toString9_( char * gc_info, int thisref, int * exception);

__device__ int invoke_java_lang_Object_toString9_( char * gc_info, int thisref, int * exception);

__device__ int at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVector_getLength5_( char * gc_info, int thisref, int * exception);

__device__ int invoke_java_lang_Object_toString9_( char * gc_info, int thisref, int * exception);

__device__ int invoke_java_lang_StringBuilder_toString9_( char * gc_info, int thisref, int * exception);

__device__ void at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVectorList_add0_11_( char * gc_info, int thisref, int parameter0, int * exception);

__device__ int java_lang_AbstractStringBuilder_append15_9_( char * gc_info, int thisref, int parameter0, int * exception);

__device__ int invoke_java_lang_AbstractStringBuilder_append15_9_( char * gc_info, int thisref, int parameter0, int * exception);

__device__ int invoke_java_lang_StringBuilder_append15_9_( char * gc_info, int thisref, int parameter0, int * exception);

__device__ int static_getter_java_lang_Integer_DigitOnes( char * gc_info, int * exception);

__device__ void static_setter_java_lang_Integer_DigitOnes( char * gc_info, int parameter0, int * expcetion);

__device__ int instance_getter_edu_syr_pcpratts_rootbeer_runtime_KeyValuePair_m_value( char * gc_info, int thisref, int * exception);

__device__ void instance_setter_edu_syr_pcpratts_rootbeer_runtime_KeyValuePair_m_value( char * gc_info, int thisref, int parameter0, int * exception);

__device__ int static_getter_java_lang_Integer_DigitTens( char * gc_info, int * exception);

__device__ void static_setter_java_lang_Integer_DigitTens( char * gc_info, int parameter0, int * expcetion);

__device__ int instance_getter_java_lang_String_hash( char * gc_info, int thisref, int * exception);

__device__ void instance_setter_java_lang_String_hash( char * gc_info, int thisref, int parameter0, int * exception);

__device__ int instance_getter_java_lang_Class_name( char * gc_info, int thisref, int * exception);

__device__ void instance_setter_java_lang_Class_name( char * gc_info, int thisref, int parameter0, int * exception);

__device__ int instance_getter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_cache( char * gc_info, int thisref, int * exception);

__device__ void instance_setter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_cache( char * gc_info, int thisref, int parameter0, int * exception);

__device__ int instance_getter_java_lang_AbstractStringBuilder_value( char * gc_info, int thisref, int * exception);

__device__ void instance_setter_java_lang_AbstractStringBuilder_value( char * gc_info, int thisref, int parameter0, int * exception);

__device__ int static_getter_java_lang_AbstractStringBuilder_sizeTable( char * gc_info, int * exception);

__device__ void static_setter_java_lang_AbstractStringBuilder_sizeTable( char * gc_info, int parameter0, int * expcetion);

__device__ int instance_getter_edu_syr_pcpratts_rootbeer_runtimegpu_GpuException_m_arrayLength( char * gc_info, int thisref, int * exception);

__device__ void instance_setter_edu_syr_pcpratts_rootbeer_runtimegpu_GpuException_m_arrayLength( char * gc_info, int thisref, int parameter0, int * exception);

__device__ int instance_getter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_summationCount( char * gc_info, int thisref, int * exception);

__device__ void instance_setter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_summationCount( char * gc_info, int thisref, int parameter0, int * exception);

__device__ long long instance_getter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_superstepCount( char * gc_info, int thisref, int * exception);

__device__ void instance_setter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_superstepCount( char * gc_info, int thisref, long long parameter0, int * exception);

__device__ int static_getter_java_lang_Integer_digits( char * gc_info, int * exception);

__device__ void static_setter_java_lang_Integer_digits( char * gc_info, int parameter0, int * expcetion);

__device__ int instance_getter_at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVector_m_index( char * gc_info, int thisref, int * exception);

__device__ void instance_setter_at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVector_m_index( char * gc_info, int thisref, int parameter0, int * exception);

__device__ int instance_getter_edu_syr_pcpratts_rootbeer_runtime_KeyValuePair_m_key( char * gc_info, int thisref, int * exception);

__device__ void instance_setter_edu_syr_pcpratts_rootbeer_runtime_KeyValuePair_m_key( char * gc_info, int thisref, int parameter0, int * exception);

__device__ int instance_getter_at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVector_m_vector( char * gc_info, int thisref, int * exception);

__device__ void instance_setter_at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVector_m_vector( char * gc_info, int thisref, int parameter0, int * exception);

__device__ int instance_getter_at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVectorList_m_values( char * gc_info, int thisref, int * exception);

__device__ void instance_setter_at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVectorList_m_values( char * gc_info, int thisref, int parameter0, int * exception);

__device__ int instance_getter_java_lang_AbstractStringBuilder_count( char * gc_info, int thisref, int * exception);

__device__ void instance_setter_java_lang_AbstractStringBuilder_count( char * gc_info, int thisref, int parameter0, int * exception);

__device__ int static_getter_java_lang_System_out( char * gc_info, int * exception);

__device__ void static_setter_java_lang_System_out( char * gc_info, int parameter0, int * expcetion);

__device__ int instance_getter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_centers( char * gc_info, int thisref, int * exception);

__device__ void instance_setter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_centers( char * gc_info, int thisref, int parameter0, int * exception);

__device__ int instance_getter_java_lang_Throwable_detailMessage( char * gc_info, int thisref, int * exception);

__device__ void instance_setter_java_lang_Throwable_detailMessage( char * gc_info, int thisref, int parameter0, int * exception);

__device__ long long instance_getter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_converged( char * gc_info, int thisref, int * exception);

__device__ void instance_setter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_converged( char * gc_info, int thisref, long long parameter0, int * exception);

__device__ int static_getter_java_lang_Integer_sizeTable( char * gc_info, int * exception);

__device__ void static_setter_java_lang_Integer_sizeTable( char * gc_info, int parameter0, int * expcetion);

__device__ int instance_getter_java_lang_String_count( char * gc_info, int thisref, int * exception);

__device__ void instance_setter_java_lang_String_count( char * gc_info, int thisref, int parameter0, int * exception);

__device__ int instance_getter_java_lang_String_value( char * gc_info, int thisref, int * exception);

__device__ void instance_setter_java_lang_String_value( char * gc_info, int thisref, int parameter0, int * exception);

__device__ int instance_getter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_maxIterations( char * gc_info, int thisref, int * exception);

__device__ void instance_setter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_maxIterations( char * gc_info, int thisref, int parameter0, int * exception);

__device__ int instance_getter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_newCenters( char * gc_info, int thisref, int * exception);

__device__ void instance_setter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_newCenters( char * gc_info, int thisref, int parameter0, int * exception);

__device__ int instance_getter_at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVectorList_m_index( char * gc_info, int thisref, int * exception);

__device__ void instance_setter_at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVectorList_m_index( char * gc_info, int thisref, int parameter0, int * exception);

__device__ int instance_getter_edu_syr_pcpratts_rootbeer_runtimegpu_GpuException_m_arrayIndex( char * gc_info, int thisref, int * exception);

__device__ void instance_setter_edu_syr_pcpratts_rootbeer_runtimegpu_GpuException_m_arrayIndex( char * gc_info, int thisref, int parameter0, int * exception);

__device__ int instance_getter_java_lang_String_offset( char * gc_info, int thisref, int * exception);

__device__ void instance_setter_java_lang_String_offset( char * gc_info, int thisref, int parameter0, int * exception);

__device__ int instance_getter_java_lang_Throwable_cause( char * gc_info, int thisref, int * exception);

__device__ void instance_setter_java_lang_Throwable_cause( char * gc_info, int thisref, int parameter0, int * exception);

__device__ int instance_getter_edu_syr_pcpratts_rootbeer_runtimegpu_GpuException_m_array( char * gc_info, int thisref, int * exception);

__device__ void instance_setter_edu_syr_pcpratts_rootbeer_runtimegpu_GpuException_m_array( char * gc_info, int thisref, int parameter0, int * exception);

__device__ int edu_syr_pcpratts_rootbeer_runtime_Sentinal_initab850b60f96d11de8a390800200c9a660_( char * gc_info, int * exception);

__device__ void edu_syr_pcpratts_rootbeer_runtime_Sentinal_initab850b60f96d11de8a390800200c9a66_body0_( char * gc_info, int thisref, int * exception);

__device__ int java_lang_String__array_get( char * gc_info, int thisref, int parameter0, int * exception);

__device__ void java_lang_String__array_set( char * gc_info, int thisref, int parameter0, int parameter1, int * exception);

__device__ int java_lang_String__array_new( char * gc_info, int size, int * exception);

__device__ int java_lang_String__array_new_multi_array( char * gc_info, int dim0, int * exception);

__device__ int java_lang_StringBuilder_initab850b60f96d11de8a390800200c9a660_( char * gc_info, int * exception);

__device__ void java_lang_StringBuilder_initab850b60f96d11de8a390800200c9a66_body0_( char * gc_info, int thisref, int * exception);

__device__ int java_lang_IllegalArgumentException_initab850b60f96d11de8a390800200c9a660_9_( char * gc_info, int parameter0, int * exception);

__device__ void java_lang_IllegalArgumentException_initab850b60f96d11de8a390800200c9a66_body0_9_( char * gc_info, int thisref, int parameter0, int * exception);

__device__ int java_lang_String_initab850b60f96d11de8a390800200c9a66( char * gc_info, int parameter0, int * exception);

__device__ void java_lang_String_initab850b60f96d11de8a390800200c9a66_body( char * gc_info, int thisref, int parameter0, int * exception);

__device__ int java_lang_RuntimeException_initab850b60f96d11de8a390800200c9a660_9_( char * gc_info, int parameter0, int * exception);

__device__ void java_lang_RuntimeException_initab850b60f96d11de8a390800200c9a66_body0_9_( char * gc_info, int thisref, int parameter0, int * exception);

__device__ int java_lang_Object_hashCode( char * gc_info, int thisref, int * exception);

__device__ int java_lang_StringBuilder_toString9_( char * gc_info, int thisref, int * exception);

__device__ int edu_syr_pcpratts_rootbeer_runtime_KeyValuePair_getKey13_( char * gc_info, int thisref, int * exception);

__device__ int java_lang_AbstractStringBuilder_append15_5_( char * gc_info, int thisref, int parameter0, int * exception);

__device__ int java_lang_IndexOutOfBoundsException_initab850b60f96d11de8a390800200c9a660_9_( char * gc_info, int parameter0, int * exception);

__device__ void java_lang_IndexOutOfBoundsException_initab850b60f96d11de8a390800200c9a66_body0_9_( char * gc_info, int thisref, int parameter0, int * exception);

__device__ int invoke_java_lang_String_hashCode5_( char * gc_info, int thisref, int * exception);

__device__ int invoke_java_lang_Object_hashCode( char * gc_info, int thisref, int * exception);

__device__ int java_lang_Long_toString9_6_( char * gc_info, long long parameter0, int * exception);

__device__ int java_lang_String_initab850b60f96d11de8a390800200c9a660_5_5_a14_( char * gc_info, int parameter0, int parameter1, int parameter2, int * exception);

__device__ void java_lang_String_initab850b60f96d11de8a390800200c9a66_body0_5_5_a14_( char * gc_info, int thisref, int parameter0, int parameter1, int parameter2, int * exception);

__device__ int java_lang_String_hashCode5_( char * gc_info, int thisref, int * exception);

__device__ void java_lang_String_getChars0_5_5_a14_5_( char * gc_info, int thisref, int parameter0, int parameter1, int parameter2, int parameter3, int * exception);

__device__ int java_lang_Throwable_initab850b60f96d11de8a390800200c9a660_9_( char * gc_info, int parameter0, int * exception);

__device__ void java_lang_Throwable_initab850b60f96d11de8a390800200c9a66_body0_9_( char * gc_info, int thisref, int parameter0, int * exception);

__device__ int java_lang_Object_toString9_( char * gc_info, int thisref, int * exception);

__device__ int java_lang_String_initab850b60f96d11de8a390800200c9a660_a14_5_5_( char * gc_info, int parameter0, int parameter1, int parameter2, int * exception);

__device__ void java_lang_String_initab850b60f96d11de8a390800200c9a66_body0_a14_5_5_( char * gc_info, int thisref, int parameter0, int parameter1, int parameter2, int * exception);

__device__ void java_lang_AbstractStringBuilder_expandCapacity0_5_( char * gc_info, int thisref, int parameter0, int * exception);

__device__ int invoke_java_lang_AbstractStringBuilder_append15_5_( char * gc_info, int thisref, int parameter0, int * exception);

__device__ int invoke_java_lang_StringBuilder_append15_5_( char * gc_info, int thisref, int parameter0, int * exception);

__device__ double at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_measureEuclidianDistance8_a12_a12_( char * gc_info, int thisref, int parameter0, int parameter1, int * exception);

__device__ int java_lang_Integer_stringSize5_5_( char * gc_info, int parameter0, int * exception);

__device__ int edu_syr_pcpratts_rootbeer_runtimegpu_GpuException_arrayOutOfBounds( char * gc_info, int parameter0, int parameter1, int parameter2, int * exception);

__device__ int invoke_java_lang_String_hashCode5_( char * gc_info, int thisref, int * exception);

__device__ int java_lang_Math_min5_5_5_( char * gc_info, int parameter0, int parameter1, int * exception);

__device__ char char__array_get( char * gc_info, int thisref, int parameter0, int * exception);

__device__ void char__array_set( char * gc_info, int thisref, int parameter0, char parameter1, int * exception);

__device__ int char__array_new( char * gc_info, int size, int * exception);

__device__ int char__array_new_multi_array( char * gc_info, int dim0, int * exception);

__device__ int java_lang_Integer_toHexString9_5_( char * gc_info, int parameter0, int * exception);

__device__ int java_lang_Integer_toUnsignedString9_5_5_( char * gc_info, int parameter0, int parameter1, int * exception);

__device__ void at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_gpuMethod0_( char * gc_info, int thisref, int * exception);

__device__ int java_lang_Long_stringSize5_6_( char * gc_info, long long parameter0, int * exception);

__device__ int java_util_Arrays_copyOfRangea14_a14_5_5_( char * gc_info, int parameter0, int parameter1, int parameter2, int * exception);

__device__ int java_lang_Boolean_toString9_1_( char * gc_info, char parameter0, int * exception);

__device__ void 
java_lang_System_arraycopy( char * gc_info, int src_handle, int srcPos, int dest_handle, int destPos, int length, int * exception);

__device__ int at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVectorList_getLength5_( char * gc_info, int thisref, int * exception);

__device__ int java_lang_StringBuilder_append10_9_( char * gc_info, int thisref, int parameter0, int * exception);

__device__ int edu_syr_pcpratts_rootbeer_runtimegpu_GpuException_initab850b60f96d11de8a390800200c9a660_( char * gc_info, int * exception);

__device__ void edu_syr_pcpratts_rootbeer_runtimegpu_GpuException_initab850b60f96d11de8a390800200c9a66_body0_( char * gc_info, int thisref, int * exception);

__device__ int java_util_Arrays_copyOfa14_a14_5_( char * gc_info, int parameter0, int parameter1, int * exception);

__device__ int double__array__array_get( char * gc_info, int thisref, int parameter0, int * exception);

__device__ void double__array__array_set( char * gc_info, int thisref, int parameter0, int parameter1, int * exception);

__device__ int double__array__array_new( char * gc_info, int size, int * exception);

__device__ int double__array__array_new_multi_array( char * gc_info, int dim0, int dim1, int * exception);

__device__ int at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_getNearestCenter5_a12_( char * gc_info, int thisref, int parameter0, int * exception);

__device__ int java_lang_Character_toString9_3_( char * gc_info, char parameter0, int * exception);

__device__ int at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVectorList_initab850b60f96d11de8a390800200c9a660_( char * gc_info, int * exception);

__device__ void at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVectorList_initab850b60f96d11de8a390800200c9a66_body0_( char * gc_info, int thisref, int * exception);

__device__ int at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVectorList_get11_5_( char * gc_info, int thisref, int parameter0, int * exception);

__device__ int java_lang_AbstractStringBuilder_stringSizeOfInt5_5_( char * gc_info, int parameter0, int * exception);

__device__ int at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVector_toArraya12_( char * gc_info, int thisref, int * exception);

__device__ int java_lang_StringIndexOutOfBoundsException_initab850b60f96d11de8a390800200c9a660_5_( char * gc_info, int parameter0, int * exception);

__device__ void java_lang_StringIndexOutOfBoundsException_initab850b60f96d11de8a390800200c9a66_body0_5_( char * gc_info, int thisref, int parameter0, int * exception);

#define GC_OBJ_TYPE_COUNT char

#define GC_OBJ_TYPE_COLOR char

#define GC_OBJ_TYPE_TYPE int

#define GC_OBJ_TYPE_CTOR_USED char

#define GC_OBJ_TYPE_SIZE int

#define COLOR_GREY 0

#define COLOR_BLACK 1

#define COLOR_WHITE 2

__device__ void edu_syr_pcpratts_gc_collect( char * gc_info);

__device__ void edu_syr_pcpratts_gc_assign( char * gc_info, int * lhs, int rhs);

__device__  char * edu_syr_pcpratts_gc_deref( char * gc_info, int handle);

__device__ int edu_syr_pcpratts_gc_malloc( char * gc_info, int size);

__device__ unsigned long long edu_syr_pcpratts_gc_malloc_no_fail( char * gc_info, int size);

__device__ int edu_syr_pcpratts_classConstant(int type_num);

__device__ long long java_lang_System_nanoTime( char * gc_info, int * exception);

#define CACHE_SIZE_BYTES 32

#define CACHE_SIZE_INTS (CACHE_SIZE_BYTES / sizeof(int))

#define CACHE_ENTRY_SIZE 4

#define TO_SPACE_OFFSET               0

#define TO_SPACE_FREE_POINTER_OFFSET  8

__device__
void edu_syr_pcpratts_exitMonitorMem( char * gc_info, char * mem, int old){
  if(old == -1){
   
    edu_syr_pcpratts_threadfence(); 
    atomicExch((int *) mem, -1);
  }
}
__device__ double java_lang_StrictMath_sqrt( char * gc_info , double parameter0 , int * exception ) {
 
  return sqrt(parameter0); 
}
__device__ 
int edu_syr_pcpratts_rootbeer_runtime_RootbeerGpu_getThreadIdxx( char * gc_info, int * exception){
  return getThreadIdxx();
}
__device__ 
int edu_syr_pcpratts_rootbeer_runtime_RootbeerGpu_getBlockIdxx( char * gc_info, int * exception){
  return getBlockIdxx();
}
__device__ 
int edu_syr_pcpratts_rootbeer_runtime_RootbeerGpu_getBlockDimx( char * gc_info, int * exception){
  return getBlockDimx();
}
__device__ 
int edu_syr_pcpratts_rootbeer_runtime_RootbeerGpu_getGridDimx( char * gc_info, int * exception){
  return getGridDimx();
}
__device__
void java_io_PrintStream_println0_9_( char * gc_info, int thisref, int str_ret, int * exception){
  int valueref;
  int count;
  int offset;
  int i;
  int curr_offset;
  char * valueref_deref;
  valueref = instance_getter_java_lang_String_value(gc_info, str_ret, exception);  
  if(*exception != 0){
    return; 
  }
 
  count = instance_getter_java_lang_String_count(gc_info, str_ret, exception);
  if(*exception != 0){
    return; 
  }
 
  offset = instance_getter_java_lang_String_offset(gc_info, str_ret, exception);
  if(*exception != 0){
    return; 
  }
 
  valueref_deref = (char *) edu_syr_pcpratts_gc_deref(gc_info, valueref);
  for(i = offset; i < count; ++i){
    curr_offset = 32 + (i * 4);
    printf("%c", valueref_deref[curr_offset]);
  }
  printf("\n");
}
__device__
void java_io_PrintStream_println0_6_( char * gc_info, int thisref, long long value, int * exception){
  printf("%lld\n", value);
}
__device__
void java_io_PrintStream_println0_8_( char * gc_info, int thisref, double value, int * exception){
  printf("%e\n", value);
}
__device__
void java_io_PrintStream_print0_9_( char * gc_info, int thisref, int str_ret, int * exception){
  int valueref;
  int count;
  int offset;
  int i;
  int curr_offset;
  char * valueref_deref;
  valueref = instance_getter_java_lang_String_value(gc_info, str_ret, exception);  
  if(*exception != 0){
    return; 
  }
 
  count = instance_getter_java_lang_String_count(gc_info, str_ret, exception);
  if(*exception != 0){
    return; 
  }
 
  offset = instance_getter_java_lang_String_offset(gc_info, str_ret, exception);
  if(*exception != 0){
    return; 
  }
 
  valueref_deref = (char *) edu_syr_pcpratts_gc_deref(gc_info, valueref);
  for(i = offset; i < count; ++i){
    curr_offset = 32 + (i * 4);
    printf("%c", valueref_deref[curr_offset]);
  }
}
__device__ 
void edu_syr_pcpratts_rootbeer_runtime_RootbeerGpu_syncthreads( char * gc_info, int * exception){
  edu_syr_pcpratts_syncthreads();
}
__device__ char
edu_syr_pcpratts_cmp(long long lhs, long long rhs){
  if(lhs > rhs)
    return 1;
  if(lhs < rhs)
    return -1;
  return 0;
}
__device__ char
edu_syr_pcpratts_cmpl(double lhs, double rhs){
  if(lhs > rhs)
    return 1;
  if(lhs < rhs)
    return -1;
  if(lhs == rhs)
    return 0;
  return -1;
}
__device__ char
edu_syr_pcpratts_cmpg(double lhs, double rhs){
  if(lhs > rhs)
    return 1;
  if(lhs < rhs)
    return -1;
  if(lhs == rhs)
    return 0;
  return 1;
}
__device__ void
edu_syr_pcpratts_gc_set_count( char * mem_loc, GC_OBJ_TYPE_COUNT value){
  mem_loc[0] = value;
}
__device__ void
edu_syr_pcpratts_gc_set_color( char * mem_loc, GC_OBJ_TYPE_COLOR value){
  mem_loc += sizeof(GC_OBJ_TYPE_COUNT);
  mem_loc[0] = value;
}
__device__ void
edu_syr_pcpratts_gc_init_monitor( char * mem_loc){
  int * addr;
  mem_loc += 16;
  addr = (int *) mem_loc;
  *addr = -1;
}
__device__ void
edu_syr_pcpratts_gc_set_type( char * mem_loc, GC_OBJ_TYPE_TYPE value){
  mem_loc += sizeof(GC_OBJ_TYPE_COUNT) + sizeof(GC_OBJ_TYPE_COLOR) + sizeof(char) +
    sizeof(GC_OBJ_TYPE_CTOR_USED);
  *(( GC_OBJ_TYPE_TYPE *) &mem_loc[0]) = value;
}
__device__ GC_OBJ_TYPE_TYPE
edu_syr_pcpratts_gc_get_type( char * mem_loc){
  mem_loc += sizeof(GC_OBJ_TYPE_COUNT) + sizeof(GC_OBJ_TYPE_COLOR) + sizeof(char) +
    sizeof(GC_OBJ_TYPE_CTOR_USED);
  return *(( GC_OBJ_TYPE_TYPE *) &mem_loc[0]);
}
__device__ void
edu_syr_pcpratts_gc_set_ctor_used( char * mem_loc, GC_OBJ_TYPE_CTOR_USED value){
  mem_loc += sizeof(GC_OBJ_TYPE_COUNT) + sizeof(GC_OBJ_TYPE_COLOR) + sizeof(char);
  mem_loc[0] = value;
}
__device__ void
edu_syr_pcpratts_gc_set_size( char * mem_loc, GC_OBJ_TYPE_SIZE value){
  mem_loc += sizeof(GC_OBJ_TYPE_COUNT) + sizeof(GC_OBJ_TYPE_COLOR) + sizeof(char) + 
    sizeof(GC_OBJ_TYPE_CTOR_USED) + sizeof(GC_OBJ_TYPE_TYPE);
  *(( GC_OBJ_TYPE_SIZE *) &mem_loc[0]) = value;
}
__device__ int edu_syr_pcpratts_getint( char * buffer, int pos){
  return *(( int *) &buffer[pos]);
}
__device__ void edu_syr_pcpratts_setint( char * buffer, int pos, int value){
  *(( int *) &buffer[pos]) = value;
}
__device__ int
edu_syr_pcpratts_strlen(char * str_constant){
  int ret = 0;
  while(1){
    if(str_constant[ret] != 
'\0'
){
      ret++;
    }
 else {
      return ret;
    }
  }
}
__device__ int
edu_syr_pcpratts_array_length( char * gc_info, int thisref){
  
  
  
  
  
     char * thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
    int ret = edu_syr_pcpratts_getint(thisref_deref, 12);
    return ret;
  
}
__device__
int java_lang_StringBuilder_initab850b60f96d11de8a390800200c9a660_(char * gc_info, int * exception){
 
  int thisref;
  char * thisref_deref;
  int chars;
  thisref = edu_syr_pcpratts_gc_malloc(gc_info , 48);
  if(thisref == -1){
    *exception = 21352; 
    return -1; 
  }
  thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
  edu_syr_pcpratts_gc_set_count(thisref_deref, 1); 
  edu_syr_pcpratts_gc_set_color(thisref_deref, COLOR_GREY); 
  edu_syr_pcpratts_gc_set_type(thisref_deref, 2905); 
  edu_syr_pcpratts_gc_set_ctor_used(thisref_deref, 1); 
  edu_syr_pcpratts_gc_set_size(thisref_deref, 48); 
  edu_syr_pcpratts_gc_init_monitor(thisref_deref); 
  chars = char__array_new(gc_info, 0, exception);
  instance_setter_java_lang_AbstractStringBuilder_value(gc_info, thisref, chars, exception); 
  instance_setter_java_lang_AbstractStringBuilder_count(gc_info, thisref, 0, exception);
  return thisref; 
}
__device__
int java_lang_String_initab850b60f96d11de8a390800200c9a66(char * gc_info, int parameter0, int * exception) {
 
  int r0 = -1; 
  int r1 = -1; 
  int i0; 
  int $r2 = -1; 
  int thisref; 
  char * thisref_deref; 
  int i;
  int len;
  int characters_copy;
  char ch;
  
  thisref = -1; 
  edu_syr_pcpratts_gc_assign(gc_info, &thisref, edu_syr_pcpratts_gc_malloc(gc_info, 48)); 
  if(thisref == -1) {
 
    *exception = 21352; 
    return -1; 
  }
 
  thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref); 
  edu_syr_pcpratts_gc_set_count(thisref_deref, 1); 
  edu_syr_pcpratts_gc_set_color(thisref_deref, COLOR_GREY); 
  edu_syr_pcpratts_gc_set_type(thisref_deref, 2905); 
  edu_syr_pcpratts_gc_set_ctor_used(thisref_deref, 1); 
  edu_syr_pcpratts_gc_set_size(thisref_deref, 48); 
  edu_syr_pcpratts_gc_init_monitor(thisref_deref); 
  len = edu_syr_pcpratts_array_length(gc_info, parameter0);
  characters_copy = char__array_new(gc_info, len, exception);
  for(i = 0; i < len; ++i){
    ch = char__array_get(gc_info, parameter0, i, exception);
    char__array_set(gc_info, characters_copy, i, ch, exception);
  }
  instance_setter_java_lang_String_value(gc_info, thisref, characters_copy, exception); 
  instance_setter_java_lang_String_count(gc_info, thisref, len, exception); 
  instance_setter_java_lang_String_offset(gc_info, thisref, 0, exception); 
  return thisref; 
}
__device__ int 
char__array_new( char * gc_info, int size, int * exception);

__device__ void 
char__array_set( char * gc_info, int thisref, int parameter0, char parameter1, int * exception);

__device__ int
edu_syr_pcpratts_string_constant( char * gc_info, char * str_constant, int * exception){
  int i;
  int len = edu_syr_pcpratts_strlen(str_constant);
  int characters = char__array_new(gc_info, len, exception);
  unsigned long long * addr = (unsigned long long *) (gc_info + TO_SPACE_FREE_POINTER_OFFSET);
  for(i = 0; i < len; ++i){
    char__array_set(gc_info, characters, i, str_constant[i], exception);
  }
  return java_lang_String_initab850b60f96d11de8a390800200c9a66(gc_info, characters, exception);
}
__device__ void
edu_syr_pcpratts_gc_assign( char * gc_info, int * lhs_ptr, int rhs){
  *lhs_ptr = rhs;
}
__device__ int java_lang_StackTraceElement__array_get( char * gc_info, int thisref, int parameter0, int * exception);

__device__ void java_lang_StackTraceElement__array_set( char * gc_info, int thisref, int parameter0, int parameter1, int * exception);

__device__ int java_lang_StackTraceElement__array_new( char * gc_info, int size, int * exception);

__device__ int java_lang_StackTraceElement_initab850b60f96d11de8a390800200c9a660_3_3_3_4_( char * gc_info, int parameter0, int parameter1, int parameter2, int parameter3, int * exception);

__device__ void instance_setter_java_lang_RuntimeException_stackDepth( char * gc_info, int thisref, int parameter0);

__device__ int instance_getter_java_lang_RuntimeException_stackDepth( char * gc_info, int thisref);

__device__ int java_lang_StackTraceElement__array_get( char * gc_info, int thisref, int parameter0, int * exception);

__device__ int instance_getter_java_lang_Throwable_stackTrace( char * gc_info, int thisref, int * exception);

__device__ void instance_setter_java_lang_Throwable_stackTrace( char * gc_info, int thisref, int parameter0, int * exception);

__device__ int java_lang_Throwable_fillInStackTrace( char * gc_info, int thisref, int * exception){
  
  
  return thisref;
}
__device__ void instance_setter_java_lang_Throwable_cause( char * gc_info, int thisref, int parameter0, int * exception);

__device__ void instance_setter_java_lang_Throwable_detailMessage( char * gc_info, int thisref, int parameter0, int * exception);

__device__ void instance_setter_java_lang_Throwable_stackDepth( char * gc_info, int thisref, int parameter0, int * exception);

__device__ void java_lang_VirtualMachineError_initab850b60f96d11de8a390800200c9a66_body0_( char * gc_info, int thisref, int * exception);

__device__ int
java_lang_Object_hashCode( char * gc_info, int thisref, int * exception){
  return thisref;
}
__device__ int
java_lang_Class_getName( char * gc_info , int thisref , int * exception ) {
 
  int $r1 =-1 ; 
  $r1 = instance_getter_java_lang_Class_name ( gc_info , thisref , exception ) ; 
  if ( * exception != 0 ) {
 
    return 0 ; 
  }
 
  return $r1;
}
__device__ int
java_lang_Object_getClass( char * gc_info , int thisref, int * exception ) {
 
  char * mem_loc = edu_syr_pcpratts_gc_deref(gc_info, thisref);
  int type = edu_syr_pcpratts_gc_get_type(mem_loc);
  return edu_syr_pcpratts_classConstant(type);
}
__device__ 
int java_lang_StringBuilder_initab850b60f96d11de8a390800200c9a6610_9_(char * gc_info, 
  int str ,int * exception){
 
  int r0 = -1; 
  int thisref; 
  int str_value;
  int str_count;  
  char * thisref_deref; 
  thisref = -1;
  edu_syr_pcpratts_gc_assign ( gc_info , & thisref , edu_syr_pcpratts_gc_malloc ( gc_info , 48 ) ) ; 
  if ( thisref ==-1 ) {
 
    * exception = 21352; 
    return-1 ; 
  }
 
  thisref_deref = edu_syr_pcpratts_gc_deref ( gc_info , thisref ) ; 
  edu_syr_pcpratts_gc_set_count ( thisref_deref , 0 ) ; 
  edu_syr_pcpratts_gc_set_color ( thisref_deref , COLOR_GREY ) ; 
  edu_syr_pcpratts_gc_set_type ( thisref_deref , 16901 ) ; 
  edu_syr_pcpratts_gc_set_ctor_used ( thisref_deref , 1 ) ; 
  edu_syr_pcpratts_gc_set_size ( thisref_deref , 44 ) ; 
  edu_syr_pcpratts_gc_init_monitor ( thisref_deref ) ; 
  str_value = instance_getter_java_lang_String_value(gc_info, str, exception);
  str_count = instance_getter_java_lang_String_count(gc_info, str, exception);
  instance_setter_java_lang_AbstractStringBuilder_value(gc_info, thisref, str_value, exception); 
  instance_setter_java_lang_AbstractStringBuilder_count(gc_info, thisref, str_count, exception); 
  return thisref; 
}
__device__ 
int java_lang_StringBuilder_append10_9_(char * gc_info, int thisref,
  int parameter0, int * exception){
  int sb_value;
  int sb_count;
  int str_value;
  int str_count;
  int new_count;
  int new_sb_value;
  int i;
  char ch;
  int new_str;
  
  sb_value = instance_getter_java_lang_AbstractStringBuilder_value(gc_info, thisref,
    exception);
  sb_count = instance_getter_java_lang_AbstractStringBuilder_count(gc_info, thisref,
    exception);
  
  str_value = instance_getter_java_lang_String_value(gc_info, parameter0,
    exception);
  str_count = instance_getter_java_lang_String_count(gc_info, parameter0,
    exception);
  new_count = sb_count + str_count;
  new_sb_value = char__array_new(gc_info, new_count, exception);
  for(i = 0; i < sb_count; ++i){
    ch = char__array_get(gc_info, sb_value, i, exception);
    char__array_set(gc_info, new_sb_value, i, ch, exception);
  }
  for(i = 0; i < str_count; ++i){
    ch = char__array_get(gc_info, str_value, i, exception);
    char__array_set(gc_info, new_sb_value, sb_count + i, ch, exception);
  }
  
  new_str = java_lang_String_initab850b60f96d11de8a390800200c9a66(gc_info, 
    new_sb_value, exception);
  
  return java_lang_StringBuilder_initab850b60f96d11de8a390800200c9a6610_9_(gc_info,
    new_str, exception);
}
__device__ 
int java_lang_StringBuilder_append10_5_(char * gc_info, int thisref,
  int parameter0, int * exception){
  int str = java_lang_Integer_toString9_5_(gc_info, parameter0, exception);
  return java_lang_StringBuilder_append10_9_(gc_info, thisref, str, exception);
}
__device__ 
int java_lang_StringBuilder_toString9_(char * gc_info, int thisref,
  int * exception){
 
  int value = instance_getter_java_lang_AbstractStringBuilder_value(gc_info, thisref,
    exception);
  return java_lang_String_initab850b60f96d11de8a390800200c9a66(gc_info, value, 
    exception);
}
/*****************************************************************************/
/* local methods */
__device__
int at_illecker_strlen(volatile char * str_constant) {
  int ret = 0;
  while(1) {
    if(str_constant[ret] != 
'\0'
) {
      ret++;
    }
 else {
      return ret;
    }
  }
}
__device__
int at_illecker_string_constant(char * gc_info, volatile char * str_constant, int * exception) {
  if (str_constant == 0) {
    return 0;
  }
  int i;
  int len = at_illecker_strlen(str_constant);
  int characters = char__array_new(gc_info, len, exception);
  
  
  
  
  for(i = 0; i < len; ++i) {
    char__array_set(gc_info, characters, i, str_constant[i], exception);
    
    
    
  }
  
  
  
  
  return java_lang_String_initab850b60f96d11de8a390800200c9a66(gc_info, characters, exception);
}
/*****************************************************************************/
/* toString methods */
__device__
double at_illecker_abs_val(double value) {
  double result = value;
  if (value < 0) {
    result = -value;
  }
  return result;
}
__device__
double at_illecker_pow10(int exp) {
  double result = 1;
  while (exp) {
    result *= 10;
    exp--;
  }
  return result;
}
__device__
long at_illecker_round(double value) {
  long intpart;
  intpart = value;
  value = value - intpart;
  if (value >= 0.5) {
    intpart++;
  }
  return intpart;
}
__device__
void at_illecker_set_char(char *buffer, int *currlen, int maxlen, char c) {
  if (*currlen < maxlen) {
    buffer[(*currlen)++] = c;
  }
}
__device__
int at_illecker_double_to_string(char * gc_info, double fvalue, int max, int * exception) {
  int signvalue = 0;
  double ufvalue;
  long intpart;
  long fracpart;
  char iconvert[20];
  char fconvert[20];
  int iplace = 0;
  int fplace = 0;
  int zpadlen = 0; 
  char buffer[64];
  int maxlen = 64;
  int currlen = 0;
  
  
  
  if (max < 0) {
    max = 6;
  }
  
  
  if (max > 9) {
    max = 9;
  }
  
  if (fvalue < 0) {
    signvalue = 
'-'
;
  }
  ufvalue = at_illecker_abs_val(fvalue);
  intpart = ufvalue;
  
  
  fracpart = at_illecker_round(at_illecker_pow10(max) * (ufvalue - intpart));
  if (fracpart >= at_illecker_pow10(max)) {
    intpart++;
    fracpart -= at_illecker_pow10(max);
  }
  
  
  
  do {
    iconvert[iplace++] = "0123456789abcdef"[intpart % 10];
    intpart = (intpart / 10);
  }
 while(intpart && (iplace < 20));
  if (iplace == 20) {
    iplace--;
  }
  iconvert[iplace] = 0;
  
  do {
    fconvert[fplace++] = "0123456789abcdef"[fracpart % 10];
    fracpart = (fracpart / 10);
  }
 while(fracpart && (fplace < 20));
  
  if (fplace == 20) {
    fplace--;
  }
  fconvert[fplace] = 0;
  
  zpadlen = max - fplace;
  if (zpadlen < 0) {
    zpadlen = 0;
  }
  
  
  
  if (signvalue) {
    at_illecker_set_char(buffer, &currlen, maxlen, signvalue);
  }
  
  while (iplace > 0) {
    at_illecker_set_char(buffer, &currlen, maxlen, iconvert[--iplace]);
  }
  
  if (max > 0) {
    
    
    
    at_illecker_set_char(buffer, &currlen, maxlen, 
'.'
);
    while (fplace > 0) {
      at_illecker_set_char(buffer, &currlen, maxlen, fconvert[--fplace]);
    }
  }
  
  while (zpadlen > 0) {
    at_illecker_set_char(buffer, &currlen, maxlen, 
'0'
);
    --zpadlen;
  }
  
  if (currlen < maxlen - 1) {
    buffer[currlen] = 
'\0'
;
  }
 else {
    buffer[maxlen - 1] = 
'\0'
;
  }
  return at_illecker_string_constant(gc_info, buffer, exception);
}
__device__ 
int java_lang_Double_toString9_8_(char * gc_info, double double_val, int * exception) {
  
  return at_illecker_double_to_string(gc_info, double_val, 6, exception);
}
/*****************************************************************************/
/* String.indexOf methods */
__device__
int at_illecker_strpos(char * gc_info, int str_value, int str_count, 
                       int sub_str_value, int sub_str_count, 
                       int start_pos, int * exception) {
  if ( (str_count == 0) || (sub_str_count == 0) || 
       (start_pos > str_count)) {
    return -1;
  }
  for (int i = start_pos; i < str_count; i++) {
    if (char__array_get(gc_info, str_value, i, exception) != 
        char__array_get(gc_info, sub_str_value, 0, exception)) {
      continue;
    }
    int found_pos = i;
    int found_sub_string = true;
    for (int j = 1; j < sub_str_count; j++) {
      i++;
      if (char__array_get(gc_info, str_value, i, exception) != 
          char__array_get(gc_info, sub_str_value, j, exception)) {
        found_sub_string = false;
        break;
      }
    }
    if (found_sub_string) {
      return found_pos;
    }
  }
  return -1;
}
/*****************************************************************************/
/* String.substring methods */
__device__
int at_illecker_substring(char * gc_info, int str_value, int str_count, 
                       int begin_index, int end_index, int * exception) {
  int new_length = 0;
  int new_string = -1;
  
  if (end_index == -1) {
 
    new_length = str_count - begin_index;
  }
 else {
    if (end_index < str_count) {
      new_length = end_index - begin_index;
    }
 else {
      new_length = str_count - begin_index;
    }
  }
 
  
  new_string = char__array_new(gc_info, new_length, exception);
  for(int i = 0; i < new_length; i++) {
    char__array_set(gc_info, new_string, i, char__array_get(gc_info, str_value, begin_index, exception), exception);
    begin_index++;
  }
  return java_lang_String_initab850b60f96d11de8a390800200c9a66(gc_info, new_string, exception);
}
/*****************************************************************************/
/* String.split methods */
__device__
int at_illecker_strcnt(char * gc_info, int str_value, int str_count, 
                       int sub_str_value, int sub_str_count, int * exception) {
  int occurrences = 0;
  if ( (str_count == 0) || (sub_str_count == 0) ) {
    return 0;
  }
  for (int i = 0; i < str_count; i++) {
    if (char__array_get(gc_info, str_value, i, exception) != 
        char__array_get(gc_info, sub_str_value, 0, exception)) {
      continue;
    }
    bool found_sub_string = true;
    for (int j = 1; j < sub_str_count; j++) {
      i++;
      if (char__array_get(gc_info, str_value, i, exception) != 
          char__array_get(gc_info, sub_str_value, j, exception)) {
        found_sub_string = false;
        break;
      }
    }
    if (found_sub_string) {
      occurrences++;
    }
  }
  return occurrences;
}
__device__
int at_illecker_split(char * gc_info, int str_obj_ref, int delim_str_obj_ref,
                      int limit, int * exception) {
  int return_obj = -1;
  int start = 0;
  int end = 0;
  int str_value = 0;
  int str_count = 0;
  int delim_str_value = 0;
  int delim_str_count = 0;
  int delim_occurrences = 0;
  str_value = instance_getter_java_lang_String_value(gc_info, str_obj_ref, exception);
  str_count = instance_getter_java_lang_String_count(gc_info, str_obj_ref, exception);
  delim_str_value = instance_getter_java_lang_String_value(gc_info, delim_str_obj_ref, exception);
  delim_str_count = instance_getter_java_lang_String_count(gc_info, delim_str_obj_ref, exception);
  
  delim_occurrences = at_illecker_strcnt(gc_info, str_value, str_count, 
                                         delim_str_value, delim_str_count, exception);
  
  if ( (limit <= 0) || (limit > delim_occurrences) ) {
    return_obj = java_lang_String__array_new(gc_info, delim_occurrences + 1, exception);
    limit = delim_occurrences + 1;
  }
 else {
    return_obj = java_lang_String__array_new(gc_info, limit, exception);
  }
  if (delim_occurrences == 0) {
    
    java_lang_String__array_set(gc_info, return_obj, 0, str_obj_ref, exception);
    
  }
 else {
    
    for (int i = 0; i < limit - 1; i++) {
      end = at_illecker_strpos(gc_info, str_value, str_count, 
                               delim_str_value, delim_str_count, start, exception);
      if (end == -1) {
        break;
      }
      
      java_lang_String__array_set(gc_info, return_obj, i,
        at_illecker_substring(gc_info, str_value, str_count, start, end, exception), exception);
      
      start = end + delim_str_count;
    }
    
    if (end != -1) {
      
      java_lang_String__array_set(gc_info, return_obj, limit - 1,
        at_illecker_substring(gc_info, str_value, str_count, start, -1, exception), exception);
    }
  }
  return return_obj;
}
__device__
int java_lang_String_split(char * gc_info, int str_obj_ref, int delim_str_obj_ref, int limit, int * exception) {
  return at_illecker_split(gc_info, str_obj_ref, delim_str_obj_ref, limit, exception);
}
__device__
int java_lang_String_split(char * gc_info, int str_obj_ref, int delim_str_obj_ref, int * exception) {
  return at_illecker_split(gc_info, str_obj_ref, delim_str_obj_ref, 0, exception);
}
/*****************************************************************************/
/* Parse methods */
__device__
bool at_illecker_is_digit(unsigned char c) {
  return ((c)>=
'0'
 && (c)<=
'9'
);
}
__device__
bool at_illecker_is_space(unsigned char c) {
  return ((c)==
' '
 || (c)==
'\f'
 || (c)==
'\n'
 || (c)==
'\r'
 || (c)==
'\t'
 || (c)==
'\v'
);
}
/* Argument1: String of ASCII digits, possibly
 * preceded by white space.  For bases
 * greater than 10, either lower- or
 * upper-case digits may be used.
 */
/* Argument2: Where to store address of terminating
 * character, or NULL.
 */
/* Argument3: Base for conversion.  Must be less
 * than 37.  If 0, then the base is chosen
 * from the leading characters of string:
 * "0x" means hex, "0" means octal, anything
 * else means decimal.
 */
__device__
unsigned long int at_illecker_strtoul(const char *string, char **end_ptr, int base) {
  register const char *p;
  register unsigned long int result = 0;
  register unsigned digit;
  int anyDigits = 0;
  int negative=0;
  int overflow=0;
  char cvtIn[] = {
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9,		/* 
'0'
 - 
'9'
 */
    100, 100, 100, 100, 100, 100, 100,		/* punctuation */
    10, 11, 12, 13, 14, 15, 16, 17, 18, 19,	/* 
'A'
 - 
'Z'
 */
    20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
    30, 31, 32, 33, 34, 35,
    100, 100, 100, 100, 100, 100,		/* punctuation */
    10, 11, 12, 13, 14, 15, 16, 17, 18, 19,	/* 
'a'
 - 
'z'
 */
    20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
    30, 31, 32, 33, 34, 35
  }
;
  
  p = string;
  while (at_illecker_is_space((unsigned char) (*p))) {
    p += 1;
  }
  
  if (*p == 
'-'
) {
    negative = 1;
    p += 1;
  }
 else {
    if (*p == 
'+'
) {
      p += 1;
    }
  }
  
  
  if (base == 0) {
    if (*p == 
'0'
) {
      p += 1;
      if ((*p == 
'x'
) || (*p == 
'X'
)) {
        p += 1;
        base = 16;
      }
 else {
        
        
        anyDigits = 1;
        base = 8;
      }
    }
 else {
      base = 10;
    }
  }
 else if (base == 16) {
    
    if ((p[0] == 
'0'
) && ((p[1] == 
'x'
) || (p[1] == 
'X'
))) {
      p += 2;
    }
  }
  
  
  if (base == 8) {
    unsigned long maxres = 0xFFFFFFFFUL >> 3; 
    for ( ; ; p += 1) {
      digit = *p - 
'0'
;
      if (digit > 7) {
        break;
      }
      if (result > maxres) {
 
        overflow = 1;
      }
      result = (result << 3);
      if (digit > (0xFFFFFFFFUL - result)) {
 
        overflow = 1;
      }
      result += digit;
      anyDigits = 1;
    }
  }
 else if (base == 10) {
    unsigned long maxres = 0xFFFFFFFFUL / 10; 
    for ( ; ; p += 1) {
      digit = *p - 
'0'
;
      if (digit > 9) {
        break;
      }
      if (result > maxres) {
 
        overflow = 1;
      }
      result *= 10;
      if (digit > (0xFFFFFFFFUL - result)) {
 
        overflow = 1;
      }
      result += digit;
      anyDigits = 1;
    }
  }
 else if (base == 16) {
    unsigned long maxres = 0xFFFFFFFFUL >> 4;
    for ( ; ; p += 1) {
      digit = *p - 
'0'
;
      if (digit > (
'z'
 - 
'0'
)) {
        break;
      }
      digit = cvtIn[digit];
      if (digit > 15) {
        break;
      }
      if (result > maxres) {
 
        overflow = 1;
      }
      result = (result << 4);
      if (digit > (0xFFFFFFFFUL - result)) {
 
        overflow = 1;
      }
      result += digit;
      anyDigits = 1;
    }
  }
 else if ( base >= 2 && base <= 36 ) {
    unsigned long maxres = 0xFFFFFFFFUL / base;
    for ( ; ; p += 1) {
      digit = *p - 
'0'
;
      if (digit > (
'z'
 - 
'0'
)) {
        break;
      }
      digit = cvtIn[digit];
      if (digit >= ( (unsigned) base )) {
        break;
      }
      if (result > maxres) {
 
        overflow = 1;
      }
      result *= base;
      if (digit > (0xFFFFFFFFUL - result)) {
        overflow = 1;
      }
      result += digit;
      anyDigits = 1;
    }
  }
  
  if (!anyDigits) {
    p = string;
  }
  if (end_ptr != 0) {
    /* unsafe, but required by the strtoul prototype */
    *end_ptr = (char *) p;
  }
  if (overflow) {
    
    return 0xFFFFFFFFUL;
  }
 
  if (negative) {
    return -result;
  }
  return result;
}
/* Argument1: String of ASCII digits, possibly
 * preceded by white space.  For bases
 * greater than 10, either lower- or
 * upper-case digits may be used.
 */
/* Argument2: Where to store address of terminating
 * character, or NULL.
 */
/* Argument3: Base for conversion.  Must be less
 * than 37.  If 0, then the base is chosen
 * from the leading characters of string:
 * "0x" means hex, "0" means octal, anything
 * else means decimal.
 */
__device__
long int at_illecker_strtol(const char *string, char **end_ptr, int base) {
  register const char *p;
  long result;
  
  p = string;
  while (at_illecker_is_space((unsigned char) (*p))) {
    p += 1;
  }
  
  if (*p == 
'-'
) {
    p += 1;
    result = -(at_illecker_strtoul(p, end_ptr, base));
  }
 else {
    if (*p == 
'+'
) {
      p += 1;
    }
    result = at_illecker_strtoul(p, end_ptr, base);
  }
  if ((result == 0) && (end_ptr != 0) && (*end_ptr == p)) {
    *end_ptr = (char *) string;
  }
  return result;
}
__device__
double at_illecker_strtod(const char *string) {
  int sign = 0; 
  int expSign = 0; 
  double fraction, dblExp, *d;
  register const char *p;
  register int c;
  int exp = 0;
  int fracExp = 0;
  int mantSize;
  int decPt;
  const char *pExp;
  int maxExponent = 511;
  double powersOf10[] = {
    10.,
    100.,
    1.0e4,
    1.0e8,
    1.0e16,
    1.0e32,
    1.0e64,
    1.0e128,
    1.0e256
  }
;
  
  p = string;
  while (at_illecker_is_space((unsigned char) (*p))) {
    p += 1;
  }
  
  if (*p == 
'-'
) {
    sign = 1; 
    p += 1;
  }
 else {
    if (*p == 
'+'
) {
      p += 1;
    }
    sign = 0; 
  }
  
  
  decPt = -1;
  for (mantSize = 0; ; mantSize += 1) {
    c = *p;
    if (!at_illecker_is_digit(c)) {
      if ((c != 
'.'
) || (decPt >= 0)) {
        break;
      }
      decPt = mantSize;
    }
    p += 1;
  }
  
  
  
  
  pExp  = p;
  p -= mantSize;
  if (decPt < 0) {
    decPt = mantSize;
  }
 else {
    mantSize -= 1;
  }
  if (mantSize > 18) {
    fracExp = decPt - 18;
    mantSize = 18;
  }
 else {
    fracExp = decPt - mantSize;
  }
  if (mantSize == 0) {
    fraction = 0.0;
    p = string;
    goto done;
  }
 else {
    int frac1, frac2;
    frac1 = 0;
    for ( ; mantSize > 9; mantSize -= 1) {
      c = *p;
      p += 1;
      if (c == 
'.'
) {
        c = *p;
        p += 1;
      }
      frac1 = 10*frac1 + (c - 
'0'
);
    }
    frac2 = 0;
    for (; mantSize > 0; mantSize -= 1) {
      c = *p;
      p += 1;
      if (c == 
'.'
) {
        c = *p;
        p += 1;
      }
      frac2 = 10*frac2 + (c - 
'0'
);
    }
    fraction = (1.0e9 * frac1) + frac2;
  }
  
  p = pExp;
  if ((*p == 
'E'
) || (*p == 
'e'
)) {
    p += 1;
    if (*p == 
'-'
) {
      expSign = 1; 
      p += 1;
    }
 else {
      if (*p == 
'+'
) {
        p += 1;
      }
      expSign = 0; 
    }
    if (!at_illecker_is_digit((unsigned char) (*p))) {
      p = pExp;
      goto done;
    }
    while (at_illecker_is_digit((unsigned char) (*p))) {
      exp = exp * 10 + (*p - 
'0'
);
      p += 1;
    }
  }
  if (expSign) {
    exp = fracExp - exp;
  }
 else {
    exp = fracExp + exp;
  }
  
  
  
  
  if (exp < 0) {
    expSign = 1; 
    exp = -exp;
  }
 else {
    expSign = 0; 
  }
  if (exp > maxExponent) {
    exp = maxExponent;
    
    
  }
  dblExp = 1.0;
  for (d = powersOf10; exp != 0; exp >>= 1, d += 1) {
    if (exp & 01) {
      dblExp *= *d;
    }
  }
  if (expSign) {
    fraction /= dblExp;
  }
 else {
    fraction *= dblExp;
  }
done:
  if (sign) {
    return -fraction;
  }
  return fraction;
}
__device__
long java_lang_Long_parseLong(char * gc_info, int str_obj_ref, int * exception) {
  int str_value = 0;
  int str_count = 0;
  char str_val[255];
  long return_val = 0;
  str_value = instance_getter_java_lang_String_value(gc_info, str_obj_ref, exception);
  str_count = instance_getter_java_lang_String_count(gc_info, str_obj_ref, exception);
  
  
  for(int i = 0; i < str_count; i++){
    str_val[i] = char__array_get(gc_info, str_value, i, exception);
  }
  str_val[str_count] = 
'\0'
;
  
  return_val = at_illecker_strtol(str_val, 0, 0);
  
  return return_val;
}
__device__
int java_lang_Integer_parseInt(char * gc_info, int str_obj_ref, int * exception) {
  return java_lang_Long_parseLong(gc_info, str_obj_ref, exception);
}
__device__
double java_lang_Double_parseDouble(char * gc_info, int str_obj_ref, int * exception) {
  int str_value = 0;
  int str_count = 0;
  char str_val[255];
  double return_val = 0;
  str_value = instance_getter_java_lang_String_value(gc_info, str_obj_ref, exception);
  str_count = instance_getter_java_lang_String_count(gc_info, str_obj_ref, exception);
  
  
  for(int i = 0; i < str_count; i++){
    str_val[i] = char__array_get(gc_info, str_value, i, exception);
  }
  str_val[str_count] = 
'\0'
;
  
  return_val = at_illecker_strtod(str_val);
  
  return return_val;
}
/*****************************************************************************/
/* local typeof methods */
__device__ bool at_illecker_typeof_Integer(char * gc_info, int thisref){
  char * thisref_deref;
  GC_OBJ_TYPE_TYPE type;
  if(thisref == -1){
    return false;
  }
  thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
  type = edu_syr_pcpratts_gc_get_type(thisref_deref);
  if(type==12647) {
    return true;
  }
  return false;
}
__device__ bool at_illecker_typeof_Long(char * gc_info, int thisref){
  char * thisref_deref;
  GC_OBJ_TYPE_TYPE type;
  if(thisref == -1){
    return false;
  }
  thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
  type = edu_syr_pcpratts_gc_get_type(thisref_deref);
  if(type==12639) {
    return true;
  }
  return false;
}
__device__ bool at_illecker_typeof_Float(char * gc_info, int thisref){
  char * thisref_deref;
  GC_OBJ_TYPE_TYPE type;
  if(thisref == -1){
    return false;
  }
  thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
  type = edu_syr_pcpratts_gc_get_type(thisref_deref);
  if(type==12643) {
    return true;
  }
  return false;
}
__device__ bool at_illecker_typeof_Double(char * gc_info, int thisref){
  char * thisref_deref;
  GC_OBJ_TYPE_TYPE type;
  if(thisref == -1){
    return false;
  }
  thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
  type = edu_syr_pcpratts_gc_get_type(thisref_deref);
  if(type==12637) {
    return true;
  }
  return false;
}
__device__ bool at_illecker_typeof_String(char * gc_info, int thisref){
  char * thisref_deref;
  GC_OBJ_TYPE_TYPE type;
  if(thisref == -1){
    return false;
  }
  thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
  type = edu_syr_pcpratts_gc_get_type(thisref_deref);
  if(type==2905) {
    return true;
  }
  return false;
}
/*****************************************************************************/
template<class T>
__device__
T at_illecker_getResult( char * gc_info, 
    HostDeviceInterface::MESSAGE_TYPE cmd, 
    HostDeviceInterface::TYPE return_type, bool use_return_value,
    int key_value_pair_ref, HostDeviceInterface::TYPE key_type, HostDeviceInterface::TYPE value_type,
    int int_param1, bool use_int_param1,
    int int_param2, bool use_int_param2,
    int int_param3, bool use_int_param3,
    long long long_param1, bool use_long_param1,
    long long long_param2, bool use_long_param2,
    float float_param1, bool use_float_param1,
    float float_param2, bool use_float_param2,
    double double_param1, bool use_double_param1,
    double double_param2, bool use_double_param2,
    int str_param1, bool use_str_param1,
    int str_param2, bool use_str_param2,
    int str_param3, bool use_str_param3,
    int * exception) {
  T return_value = 0;
  int thread_id = threadIdx.x + blockIdx.x * blockDim.x;
  int count = 0;
  int timeout = 0;
  bool done = false;
  int str_param1_value = 0;
  int str_param1_count = 0;
  int str_param2_value = 0;
  int str_param2_count = 0;
  int str_param3_value = 0;
  int str_param3_count = 0;
  int key_obj_ref = 0;
  int value_obj_ref = 0;
  char * key_obj_deref;
  char * value_obj_deref;
  
  while (count < 100) {
    
    if (++timeout > 100000) {
      break;
    }
    __syncthreads();
    
    if (done) {
      break;
    }
    
    int old = atomicCAS((int *) &host_device_interface->lock_thread_id, -1, thread_id);
    
    if (old == -1 || old == thread_id) {
      
      
      if (host_device_interface->is_debugging) {
        printf("gpu_Thread %d GOT LOCK lock_thread_id: %d\n", thread_id,
               host_device_interface->lock_thread_id);
      }
      /***********************************************************************/
      
      int inner_timeout = 0;
      while (host_device_interface->has_task) {
        
        if (++inner_timeout > 10000) {
          break;
        }
      }
      /***********************************************************************/
      
      host_device_interface->command = cmd;
      host_device_interface->return_type = return_type;
      
      if (use_int_param1) {
        host_device_interface->use_int_val1 = true;
        host_device_interface->int_val1 = int_param1;
      }
      if (use_int_param2) {
        host_device_interface->use_int_val2 = true;
        host_device_interface->int_val2 = int_param2;
      }
      if (use_int_param3) {
        host_device_interface->use_int_val3 = true;
        host_device_interface->int_val3 = int_param3;
      }
      if (use_long_param1) {
        host_device_interface->use_long_val1 = true;
        host_device_interface->long_val1 = long_param1;
      }
      if (use_long_param2) {
        host_device_interface->use_long_val2 = true;
        host_device_interface->long_val2 = long_param2;
      }
      if (use_float_param1) {
        host_device_interface->use_float_val1 = true;
        host_device_interface->float_val1 = float_param1;
      }
      if (use_float_param2) {
        host_device_interface->use_float_val2 = true;
        host_device_interface->float_val2 = float_param2;
      }
      if (use_double_param1) {
        host_device_interface->use_double_val1 = true;
        host_device_interface->double_val1 = double_param1;
      }
      if (use_double_param2) {
        host_device_interface->use_double_val2 = true;
        host_device_interface->double_val2 = double_param2;
      }
      if (use_str_param1) {
        str_param1_value = instance_getter_java_lang_String_value(gc_info, str_param1,
                          exception);
        str_param1_count = instance_getter_java_lang_String_count(gc_info, str_param1,
                          exception);
        
        for(int i = 0; i < str_param1_count; i++) {
          host_device_interface->str_val1[i] = char__array_get(gc_info, str_param1_value, i, exception);
        }
        host_device_interface->use_str_val1 = true;
        host_device_interface->str_val1[str_param1_count] = 
'\0'
;
      }
      if (use_str_param2) {
        str_param2_value = instance_getter_java_lang_String_value(gc_info, str_param2,
                           exception);
        str_param2_count = instance_getter_java_lang_String_count(gc_info, str_param2,
                           exception);
        
        for(int i = 0; i < str_param2_count; i++) {
          host_device_interface->str_val2[i] = char__array_get(gc_info, str_param2_value, i, exception);
        }
        host_device_interface->use_str_val2 = true;
        host_device_interface->str_val2[str_param2_count] = 
'\0'
;
      }
      if (use_str_param3) {
        str_param3_value = instance_getter_java_lang_String_value(gc_info, str_param3,
                           exception);
        str_param3_count = instance_getter_java_lang_String_count(gc_info, str_param3,
                           exception);
        
        for(int i = 0; i < str_param3_count; i++) {
          host_device_interface->str_val3[i] = char__array_get(gc_info, str_param3_value, i, exception);
        }
        host_device_interface->use_str_val3 = true;
        host_device_interface->str_val3[str_param3_count] = 
'\0'
;
      }
      
      host_device_interface->key_type = key_type;
      host_device_interface->value_type = value_type;
      /***********************************************************************/
      
      host_device_interface->has_task = true;
      __threadfence_system();
      
      /***********************************************************************/
      
      inner_timeout = 0;
      while (!host_device_interface->is_result_available) {
        __threadfence_system();
        
	
        if (++inner_timeout > 30000) {
          break;
        }
      }
      /***********************************************************************/
      
      if (return_type == HostDeviceInterface::KEY_VALUE_PAIR) {
        
        
        key_obj_ref = instance_getter_edu_syr_pcpratts_rootbeer_runtime_KeyValuePair_m_key(gc_info, 
                      key_value_pair_ref, exception);
        key_obj_deref = edu_syr_pcpratts_gc_deref(gc_info, key_obj_ref);
        
        if (key_type == HostDeviceInterface::INT) {
          *(( int *) &key_obj_deref[32]) = host_device_interface->int_val1;
        }
 else if (key_type == HostDeviceInterface::LONG) {
          *(( long long *) &key_obj_deref[32]) = host_device_interface->long_val1;
        }
 else if (key_type == HostDeviceInterface::FLOAT) {
          *(( float *) &key_obj_deref[32]) = host_device_interface->float_val1;
        }
 else if (key_type == HostDeviceInterface::DOUBLE) {
          *(( double *) &key_obj_deref[32]) = host_device_interface->double_val1;
        }
 else if (key_type == HostDeviceInterface::STRING) {
          int i;
          int len = at_illecker_strlen(host_device_interface->str_val1);
          int characters = char__array_new(gc_info, len, exception);
          for(i = 0; i < len; ++i) {
            char__array_set(gc_info, characters, i, host_device_interface->str_val1[i], exception);
          }
          
          *(( int *) &key_obj_deref[32]) = characters;
          
          *(( int *) &key_obj_deref[40]) = len;
          
          *(( int *) &key_obj_deref[44]) = 0;
        }
        
        value_obj_ref = instance_getter_edu_syr_pcpratts_rootbeer_runtime_KeyValuePair_m_value(gc_info, 
                        key_value_pair_ref, exception);
        value_obj_deref = edu_syr_pcpratts_gc_deref(gc_info, value_obj_ref);
        
        if (value_type == HostDeviceInterface::INT) {
          *(( int *) &value_obj_deref[32]) = host_device_interface->int_val2;
        }
 else if (value_type == HostDeviceInterface::LONG) {
          *(( long long *) &value_obj_deref[32]) = host_device_interface->long_val2;
        }
 else if (value_type == HostDeviceInterface::FLOAT) {
          *(( float *) &value_obj_deref[32]) = host_device_interface->float_val2;
        }
 else if (value_type == HostDeviceInterface::DOUBLE) {
          *(( double *) &value_obj_deref[32]) = host_device_interface->double_val2;
        }
 else if (value_type == HostDeviceInterface::STRING) {
          int i;
          int len = at_illecker_strlen(host_device_interface->str_val2);
          int characters = char__array_new(gc_info, len, exception);
          for(i = 0; i < len; ++i) {
            char__array_set(gc_info, characters, i, host_device_interface->str_val2[i], exception);
          }
          
          *(( int *) &value_obj_deref[32]) = characters;
          
          *(( int *) &value_obj_deref[40]) = len;
          
          *(( int *) &value_obj_deref[44]) = 0;
        }
        
        return_value = !host_device_interface->end_of_data;
      }
 else if (use_return_value) {
 
        
        if (return_type == HostDeviceInterface::INT) {
          return_value = host_device_interface->int_val1;
        }
 else if (return_type == HostDeviceInterface::LONG) {
          return_value = host_device_interface->long_val1;
        }
 else if (return_type == HostDeviceInterface::FLOAT) {
          return_value = host_device_interface->float_val1;
        }
 else if (return_type == HostDeviceInterface::DOUBLE) {
          return_value = host_device_interface->double_val1;
        }
 else if (return_type == HostDeviceInterface::STRING) {
          
          edu_syr_pcpratts_gc_assign(gc_info, (int*)&return_value,
            at_illecker_string_constant(gc_info, host_device_interface->str_val1, exception));
       
        }
 else if (return_type == HostDeviceInterface::STRING_ARRAY) {
          int index = 0;
          int array_len = host_device_interface->int_val1;
          if (array_len > 0) {
            
            return_value = java_lang_String__array_new(gc_info, array_len, exception);
            while ( (host_device_interface->use_int_val1) && (index < array_len) ) {
              if (host_device_interface->use_str_val1) {
                java_lang_String__array_set(gc_info, return_value, index, 
                  at_illecker_string_constant(gc_info, host_device_interface->str_val1, exception), exception);
                index++;
              }
              if (host_device_interface->use_str_val2) {
                java_lang_String__array_set(gc_info, return_value, index, 
                  at_illecker_string_constant(gc_info, host_device_interface->str_val2, exception), exception);
                index++;
              }
              if (host_device_interface->use_str_val3) {
                java_lang_String__array_set(gc_info, return_value, index, 
                  at_illecker_string_constant(gc_info, host_device_interface->str_val3, exception), exception);
                index++;
              }
              
              host_device_interface->is_result_available = false;
              __threadfence_system();
              
              while (!host_device_interface->is_result_available) {
                __threadfence_system();
              }
            }
          }
 else {
            return_value = 0;
          }
        }
      }
      /***********************************************************************/
      
      if ( (use_int_param1) || (return_type == HostDeviceInterface::INT) ) {
        host_device_interface->int_val1 = 0;
        host_device_interface->use_int_val1 = false;
      }
      if (use_int_param2) {
        host_device_interface->int_val2 = 0;
        host_device_interface->use_int_val2 = false;
      }
      if (use_int_param3) {
        host_device_interface->int_val3 = 0;
        host_device_interface->use_int_val3 = false;
      }
      if ( (use_long_param1) || (return_type == HostDeviceInterface::LONG) ) {
        host_device_interface->long_val1 = 0;
        host_device_interface->use_long_val1 = false;
      }
      if (use_long_param1) {
        host_device_interface->long_val2 = 0;
        host_device_interface->use_long_val2 = false;
      }
      if ( (use_float_param1) || (return_type == HostDeviceInterface::FLOAT) ) {
        host_device_interface->float_val1 = 0;
        host_device_interface->use_float_val1 = false;
      }
      if (use_float_param2) {
        host_device_interface->float_val2 = 0;
        host_device_interface->use_float_val2 = false;
      }
      if ( (use_double_param1) || (return_type == HostDeviceInterface::DOUBLE) ) {
        host_device_interface->double_val1 = 0;
        host_device_interface->use_double_val1 = false;
      }
      if (use_double_param2) {
        host_device_interface->double_val2 = 0;
        host_device_interface->use_double_val2 = false;
      }
      if ( (use_str_param1) || (return_type == HostDeviceInterface::STRING) ) {
        host_device_interface->str_val1[0] = 
'\0'
;
        host_device_interface->use_str_val1 = false;
      }
      if (use_str_param2) {
        host_device_interface->str_val2[0] = 
'\0'
;
        host_device_interface->use_str_val2 = false;
      }
      if (use_str_param3) {
        host_device_interface->str_val3[0] = 
'\0'
;
        host_device_interface->use_str_val3 = false;
      }
      if (return_type == HostDeviceInterface::STRING_ARRAY) {
        host_device_interface->int_val1 = 0;
        host_device_interface->use_int_val1 = false;
        host_device_interface->str_val1[0] = 
'\0'
;
        host_device_interface->use_str_val1 = false;
        host_device_interface->str_val2[0] = 
'\0'
;
        host_device_interface->use_str_val2 = false;
        host_device_interface->str_val3[0] = 
'\0'
;
        host_device_interface->use_str_val3 = false;
      }
      host_device_interface->command = HostDeviceInterface::UNDEFINED;
      host_device_interface->return_type = HostDeviceInterface::NOT_AVAILABLE;
      host_device_interface->key_type = HostDeviceInterface::NOT_AVAILABLE;
      host_device_interface->value_type = HostDeviceInterface::NOT_AVAILABLE;
      /***********************************************************************/ 
      
      host_device_interface->is_result_available = false;
      host_device_interface->lock_thread_id = -1;
      
      __threadfence_system();
      
      /***********************************************************************/ 
      
      done = true; 
    }
 else {
      count++;
      if (count > 50) {
        count = 0;
      }
    }
  }
  return return_value;
}
/*****************************************************************************/
/* Hama Peer public methods */
__device__
void edu_syr_pcpratts_rootbeer_runtime_HamaPeer_send( char * gc_info,
     int peer_name_str_ref, int message_obj_ref, int * exception) {
  int int_value = 0;
  bool use_int_value = false;
  long long long_value = 0;
  bool use_long_value = false;
  float float_value = 0;
  bool use_float_value = false;
  double double_value = 0;
  bool use_double_value = false;
  int string_value = 0;
  bool use_string_value = false;
  char * message_obj_deref;
  
  
  if (message_obj_ref == -1) {
    printf("Exception in HamaPeer.send: unsupported NULL Type\n");
    return;
  }
 else {
    
    if (at_illecker_typeof_Integer(gc_info, message_obj_ref)) {
      message_obj_deref = edu_syr_pcpratts_gc_deref(gc_info, message_obj_ref);
      int_value = *(( int *) &message_obj_deref[32]);
      use_int_value = true;
      
    }
 else if (at_illecker_typeof_Long(gc_info, message_obj_ref)) {
      message_obj_deref = edu_syr_pcpratts_gc_deref(gc_info, message_obj_ref);
      long_value = *(( long long *) &message_obj_deref[32]);
      use_long_value = true;
      
    }
 else if (at_illecker_typeof_Float(gc_info, message_obj_ref)) {
      message_obj_deref = edu_syr_pcpratts_gc_deref(gc_info, message_obj_ref);
      float_value = *(( float *) &message_obj_deref[32]);
      use_float_value = true;
      
    }
 else if (at_illecker_typeof_Double(gc_info, message_obj_ref)) {
      message_obj_deref = edu_syr_pcpratts_gc_deref(gc_info, message_obj_ref);
      double_value = *(( double *) &message_obj_deref[32]);
      use_double_value = true;
      
    }
 else if (at_illecker_typeof_String(gc_info, message_obj_ref)) {
      string_value = message_obj_ref;
      use_string_value = true;
      
    }
 else {
      
      printf("Exception in HamaPeer.send: unsupported Type\n");
      return;
    }
  }
  at_illecker_getResult<int>(gc_info, HostDeviceInterface::SEND_MSG,
    HostDeviceInterface::NOT_AVAILABLE, false, 
    0, HostDeviceInterface::NOT_AVAILABLE, HostDeviceInterface::NOT_AVAILABLE,
    int_value, use_int_value,
    0, false,
    0, false,
    long_value, use_long_value,
    0, false,
    float_value, use_float_value,
    0, false,
    double_value, use_double_value,
    0, false,
    peer_name_str_ref, true,
    string_value, use_string_value,
    0, false,
    exception);
}
__device__
int edu_syr_pcpratts_rootbeer_runtime_HamaPeer_getCurrentStringMessage( char * gc_info, 
    int * exception) {
  return at_illecker_getResult<int>(gc_info, HostDeviceInterface::GET_MSG,
           HostDeviceInterface::STRING, true, 
           0, HostDeviceInterface::NOT_AVAILABLE, HostDeviceInterface::NOT_AVAILABLE,
           0, false,
           0, false,
           0, false,
           0, false,
           0, false,
           0, false,
           0, false,
           0, false,
           0, false,
           0, false,
           0, false,
           0, false,
           exception);
}
__device__
int edu_syr_pcpratts_rootbeer_runtime_HamaPeer_getNumCurrentMessages( char * gc_info, 
    int * exception) {
  return at_illecker_getResult<int>(gc_info, HostDeviceInterface::GET_MSG_COUNT,
           HostDeviceInterface::INT, true, 
           0, HostDeviceInterface::NOT_AVAILABLE, HostDeviceInterface::NOT_AVAILABLE,
           0, false,
           0, false,
           0, false,
           0, false,
           0, false,
           0, false,
           0, false,
           0, false,
           0, false,
           0, false,
           0, false,
           0, false,
           exception);
}
__device__
void edu_syr_pcpratts_rootbeer_runtime_HamaPeer_sync( char * gc_info, 
     int * exception) {
  at_illecker_getResult<int>(gc_info, HostDeviceInterface::SYNC,
    HostDeviceInterface::NOT_AVAILABLE, false, 
    0, HostDeviceInterface::NOT_AVAILABLE, HostDeviceInterface::NOT_AVAILABLE,
    0, false,
    0, false,
    0, false,
    0, false,
    0, false,
    0, false,
    0, false,
    0, false,
    0, false,
    0, false,
    0, false,
    0, false,
    exception);
}
__device__
long edu_syr_pcpratts_rootbeer_runtime_HamaPeer_getSuperstepCount( char * gc_info, 
    int * exception) {
  return at_illecker_getResult<long>(gc_info, HostDeviceInterface::GET_SUPERSTEP_COUNT,
           HostDeviceInterface::LONG, true, 
           0, HostDeviceInterface::NOT_AVAILABLE, HostDeviceInterface::NOT_AVAILABLE,
           0, false,
           0, false,
           0, false,
           0, false,
           0, false,
           0, false,
           0, false,
           0, false,
           0, false,
           0, false,
           0, false,
           0, false,
           exception);
}
__device__
int edu_syr_pcpratts_rootbeer_runtime_HamaPeer_getAllPeerNames( char * gc_info, 
    int * exception) {
  return at_illecker_getResult<int>(gc_info, HostDeviceInterface::GET_ALL_PEERNAME,
           HostDeviceInterface::STRING_ARRAY, true, 
           0, HostDeviceInterface::NOT_AVAILABLE, HostDeviceInterface::NOT_AVAILABLE,
           0, false,
           0, false,
           0, false,
           0, false,
           0, false,
           0, false,
           0, false,
           0, false,
           0, false,
           0, false,
           0, false,
           0, false,
           exception);
}
__device__
void edu_syr_pcpratts_rootbeer_runtime_HamaPeer_reopenInput( char * gc_info, 
     int * exception) {
  at_illecker_getResult<int>(gc_info, HostDeviceInterface::REOPEN_INPUT,
           HostDeviceInterface::NOT_AVAILABLE, false, 
           0, HostDeviceInterface::NOT_AVAILABLE, HostDeviceInterface::NOT_AVAILABLE,
           0, false,
           0, false,
           0, false,
           0, false,
           0, false,
           0, false,
           0, false,
           0, false,
           0, false,
           0, false,
           0, false,
           0, false,
           exception);
}
__device__
bool edu_syr_pcpratts_rootbeer_runtime_HamaPeer_readNext( char * gc_info, 
     int key_value_pair_ref, int * exception) {
  int key_obj_ref;
  int value_obj_ref;
  HostDeviceInterface::TYPE key_type;
  HostDeviceInterface::TYPE value_type;
  key_obj_ref = instance_getter_edu_syr_pcpratts_rootbeer_runtime_KeyValuePair_m_key(gc_info, 
                key_value_pair_ref, exception);
  value_obj_ref = instance_getter_edu_syr_pcpratts_rootbeer_runtime_KeyValuePair_m_value(gc_info, 
                  key_value_pair_ref, exception);
  
  if (at_illecker_typeof_Integer(gc_info, key_obj_ref)) {
    key_type = HostDeviceInterface::INT;
  }
 else if (at_illecker_typeof_Long(gc_info, key_obj_ref)) {
    key_type = HostDeviceInterface::LONG;
  }
 else if (at_illecker_typeof_Float(gc_info, key_obj_ref)) {
    key_type = HostDeviceInterface::FLOAT;
  }
 else if (at_illecker_typeof_Double(gc_info, key_obj_ref)) {
    key_type = HostDeviceInterface::DOUBLE;
  }
 else if (at_illecker_typeof_String(gc_info, key_obj_ref)) {
    key_type = HostDeviceInterface::STRING;
  }
 else if (key_obj_ref == -1) {
    key_type = HostDeviceInterface::NULL_TYPE;
  }
 else {
    
    printf("Exception in HamaPeer.readNext: unsupported Key Type\n");
    return false;
  }
  
  if (at_illecker_typeof_Integer(gc_info, value_obj_ref)) {
    value_type = HostDeviceInterface::INT;
  }
 else if (at_illecker_typeof_Long(gc_info, value_obj_ref)) {
    value_type = HostDeviceInterface::LONG;
  }
 else if (at_illecker_typeof_Float(gc_info, value_obj_ref)) {
    value_type = HostDeviceInterface::FLOAT;
  }
 else if (at_illecker_typeof_Double(gc_info, value_obj_ref)) {
    value_type = HostDeviceInterface::DOUBLE;
  }
 else if (at_illecker_typeof_String(gc_info, value_obj_ref)) {
    value_type = HostDeviceInterface::STRING;
  }
 else if (value_obj_ref == -1) {
    value_type = HostDeviceInterface::NULL_TYPE;
  }
 else {
    
    printf("Exception in HamaPeer.readNext: unsupported Value Type\n");
    return false;
  }
  if ( (key_type == HostDeviceInterface::NULL_TYPE) &&
       (value_type == HostDeviceInterface::NULL_TYPE) ) {
    printf("Exception in HamaPeer.readNext: key and value are NULL!\n");
    return false;
  }
  return at_illecker_getResult<int>(gc_info, HostDeviceInterface::READ_KEYVALUE,
           HostDeviceInterface::KEY_VALUE_PAIR, false, 
           key_value_pair_ref, key_type, value_type,
           0, false,
           0, false,
           0, false,
           0, false,
           0, false,
           0, false,
           0, false,
           0, false,
           0, false,
           0, false,
           0, false,
           0, false,
           exception);
}
__device__ int edu_syr_pcpratts_rootbeer_runtime_KeyValuePair_getKey13_( char * gc_info, int thisref, int * exception){
int r0 = -1;
int $r1 = -1;
 r0  =  thisref ;
 $r1  = instance_getter_edu_syr_pcpratts_rootbeer_runtime_KeyValuePair_m_key(gc_info, r0, exception);
if(*exception != 0) {
 
return 0; }
return  $r1 ;
  return 0;
}
__device__ int at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_getNearestCenter5_a12_( char * gc_info, int thisref, int parameter0, int * exception){
int r0 = -1;
int r1 = -1;
int i0;
double d0;
int i1;
double d1;
int $r2 = -1;
int $i2;
int $r3 = -1;
int $r4 = -1;
char $b3;
 r0  =  thisref ;
 r1  =  parameter0 ;
 i0  =  0 ;
 d0  =  1.7976931348623157E308 ;
 i1  =  0 ;
label2:
 $r2  = instance_getter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_centers(gc_info, r0, exception);
if(*exception != 0) {
 
return 0; }
 $i2  = edu_syr_pcpratts_array_length(gc_info,  $r2 );
if ( i1  >=  $i2   ) goto label0;
 $r3  = instance_getter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_centers(gc_info, r0, exception);
if(*exception != 0) {
 
return 0; }
 $r4  = double__array__array_get(gc_info, $r3, i1, exception);
if(*exception != 0) {
 
return 0; }
 d1  = at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_measureEuclidianDistance8_a12_a12_(gc_info,
 r0,
  $r4 ,
  r1 , exception);
if(*exception != 0) {
 
return 0; }
 $b3  = edu_syr_pcpratts_cmpg((double) d1 , (double) d0 );
if ( $b3  >=  0   ) goto label1;
 d0  =  d1 ;
 i0  =  i1 ;
label1:
 i1  =  i1  +  1  ;
goto label2;
label0:
return  i0 ;
  return 0;
}
__device__ int java_lang_String_initab850b60f96d11de8a390800200c9a660_a14_5_5_( char * gc_info, int parameter0, int parameter1, int parameter2, int * exception){
int r0 = -1;
int r1 = -1;
int i0;
int i1;
int $r2 = -1;
int $r3 = -1;
int $i2;
int $i3;
int $r4 = -1;
int $i4;
int $i5;
int $r5 = -1;
int thisref;
 char * thisref_deref;
thisref = -1;
edu_syr_pcpratts_gc_assign(gc_info, &thisref, edu_syr_pcpratts_gc_malloc(gc_info, 64));
if(thisref == -1){
  *exception = 21106;
  return -1;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
edu_syr_pcpratts_gc_set_count(thisref_deref, 1);
edu_syr_pcpratts_gc_set_color(thisref_deref, COLOR_GREY);
edu_syr_pcpratts_gc_set_type(thisref_deref, 2905);
edu_syr_pcpratts_gc_set_ctor_used(thisref_deref, 1);
edu_syr_pcpratts_gc_set_size(thisref_deref, 64);
edu_syr_pcpratts_gc_init_monitor(thisref_deref);
instance_setter_java_lang_String_value(gc_info, thisref, -1, exception);
instance_setter_java_lang_String_count(gc_info, thisref, 0, exception);
instance_setter_java_lang_String_hash(gc_info, thisref, 0, exception);
instance_setter_java_lang_String_offset(gc_info, thisref, 0, exception);
 r0  =  thisref ;
 r1  =  parameter0 ;
 i0  =  parameter1 ;
 i1  =  parameter2 ;
if ( i0  >=  0   ) goto label0;
 $r2  =  -1 ;
edu_syr_pcpratts_gc_assign (gc_info, 
&$r2, java_lang_StringIndexOutOfBoundsException_initab850b60f96d11de8a390800200c9a660_5_(gc_info,
  i0 , exception));
if(*exception != 0) {
 
return 0; }
 *exception =  $r2 ;
return 0;
label0:
if ( i1  >=  0   ) goto label1;
 $r3  =  -1 ;
edu_syr_pcpratts_gc_assign (gc_info, 
&$r3, java_lang_StringIndexOutOfBoundsException_initab850b60f96d11de8a390800200c9a660_5_(gc_info,
  i1 , exception));
if(*exception != 0) {
 
return 0; }
 *exception =  $r3 ;
return 0;
label1:
 $i2  = edu_syr_pcpratts_array_length(gc_info,  r1 );
 $i3  =  $i2  -  i1  ;
if ( i0  <=  $i3   ) goto label2;
 $r4  =  -1 ;
 $i4  =  i0  +  i1  ;
edu_syr_pcpratts_gc_assign (gc_info, 
&$r4, java_lang_StringIndexOutOfBoundsException_initab850b60f96d11de8a390800200c9a660_5_(gc_info,
  $i4 , exception));
if(*exception != 0) {
 
return 0; }
 *exception =  $r4 ;
return 0;
label2:
instance_setter_java_lang_String_offset(gc_info, r0,  0 , exception);
if(*exception != 0) {
 
return 0; }
instance_setter_java_lang_String_count(gc_info, r0,  i1 , exception);
if(*exception != 0) {
 
return 0; }
 $i5  =  i0  +  i1  ;
 $r5  = java_util_Arrays_copyOfRangea14_a14_5_5_(gc_info,  r1 ,  i0 ,  $i5 , exception);
if(*exception != 0) {
 
return 0; }
instance_setter_java_lang_String_value(gc_info, r0,  $r5 , exception);
if(*exception != 0) {
 
return 0; }
return r0;
  return 0;
}
__device__ void at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_gpuMethod0_( char * gc_info, int thisref, int * exception){
int r0 = -1;
int i0;
int i1;
int i2;
int i3;
int i4;
int i5;
int i6;
char z0;
int i7;
int r1 = -1;
int i8;
int r2 = -1;
int r3 = -1;
int r4 = -1;
int i9;
int r5 = -1;
int i10;
int r6 = -1;
int i11;
int r7 = -1;
int i12;
int $i13;
int $r8 = -1;
int $i14;
int $r9 = -1;
int $r10 = -1;
int $i15;
int $r11 = -1;
int $r12 = -1;
int $i16;
int $r13 = -1;
int $r14 = -1;
int $i17;
int $r15 = -1;
char z1;
int $r16 = -1;
int $r17 = -1;
int $r18 = -1;
int $r19 = -1;
int $r20 = -1;
int r21 = -1;
int $r22 = -1;
int $i18;
int $r23 = -1;
int $r24 = -1;
int i19;
int $r25 = -1;
int r26 = -1;
int $i20;
int $r27 = -1;
int $r28 = -1;
int $i21;
int r29 = -1;
int i22;
int r30 = -1;
int i23;
int $r31 = -1;
int $i24;
int $r32 = -1;
int $i25;
int r33 = -1;
int $r34 = -1;
int $r35 = -1;
int $r36 = -1;
int $r37 = -1;
int r38 = -1;
int $r39 = -1;
int $r40 = -1;
int $r41 = -1;
int r42 = -1;
int $r43 = -1;
int $r44 = -1;
int $r45 = -1;
int $i26;
int $r46 = -1;
int $r47 = -1;
int r48 = -1;
int $r49 = -1;
int $r50 = -1;
int $r51 = -1;
int r52 = -1;
int i27;
int $r53 = -1;
int $r54 = -1;
int $i28;
int $r55 = -1;
int $r56 = -1;
int $r57 = -1;
int $r58 = -1;
double $d0;
int $r59 = -1;
int $r60 = -1;
int $r61 = -1;
int $r62 = -1;
int $i29;
int $i30;
int $r63 = -1;
int $r64 = -1;
int $r65 = -1;
int $r66 = -1;
int $r67 = -1;
int $r68 = -1;
int r69 = -1;
int i31;
int $r70 = -1;
int $i32;
int $r71 = -1;
int $r72 = -1;
int $i33;
int r73 = -1;
int $r74 = -1;
int $i34;
int r75 = -1;
int i35;
int i36;
int r76 = -1;
int $r77 = -1;
int $r78 = -1;
int $r79 = -1;
int r80 = -1;
int $r81 = -1;
int i37;
int $r82 = -1;
int $r83 = -1;
int $r84 = -1;
double $d1;
int $i38;
int i39;
int $r85 = -1;
int $i40;
int $r86 = -1;
double $d2;
double $d3;
double $d4;
int $i43;
int $i44;
int i45;
int $i46;
int $i47;
int i48;
int $r88 = -1;
int $i49;
int $r89 = -1;
double $d5;
int $i51;
double $d6;
double $d7;
long long l52;
int i53;
int $i54;
int $i55;
double d8;
int i56;
int $r90 = -1;
int $r91 = -1;
int $i57;
int $r92 = -1;
int $r93 = -1;
double $d9;
int $r94 = -1;
double $d10;
double $d11;
double $d12;
int $r95 = -1;
int $r96 = -1;
char $b58;
int $r97 = -1;
int $r98 = -1;
long long $l59;
int $r99 = -1;
int $r100 = -1;
long long $l60;
long long $l61;
char $b62;
int $i63;
int $i64;
long long $l65;
long long $l66;
char $b67;
int $r101 = -1;
int $r102 = -1;
 r0  =  thisref ;
 i0  = edu_syr_pcpratts_rootbeer_runtime_RootbeerGpu_getBlockDimx(gc_info, exception);
if(*exception != 0) {
 
return ; }
 i1  = edu_syr_pcpratts_rootbeer_runtime_RootbeerGpu_getGridDimx(gc_info, exception);
if(*exception != 0) {
 
return ; }
 i2  =  i0  *  i1  ;
 i3  = edu_syr_pcpratts_rootbeer_runtime_RootbeerGpu_getBlockIdxx(gc_info, exception);
if(*exception != 0) {
 
return ; }
 i4  = edu_syr_pcpratts_rootbeer_runtime_RootbeerGpu_getThreadIdxx(gc_info, exception);
if(*exception != 0) {
 
return ; }
 $i13  =  i3  *  i0  ;
 i5  =  $i13  +  i4  ;
label55:
if ( i5  !=  0   ) goto label0;
 $r8  = instance_getter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_centers(gc_info, r0, exception);
if(*exception != 0) {
 
return ; }
 $i14  = edu_syr_pcpratts_array_length(gc_info,  $r8 );
 $r9  = instance_getter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_centers(gc_info, r0, exception);
if(*exception != 0) {
 
return ; }
 $r10  = double__array__array_get(gc_info, $r9, 0, exception);
if(*exception != 0) {
 
return ; }
 $i15  = edu_syr_pcpratts_array_length(gc_info,  $r10 );
 $r11  = double__array__array_new_multi_array(gc_info,  $i14 ,  $i15 , exception);
instance_setter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_newCenters(gc_info, r0,  $r11 , exception);
if(*exception != 0) {
 
return ; }
 $r12  = instance_getter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_centers(gc_info, r0, exception);
if(*exception != 0) {
 
return ; }
 $i16  = edu_syr_pcpratts_array_length(gc_info,  $r12 );
 $r13  = int__array_new(gc_info,  $i16 , exception);
instance_setter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_summationCount(gc_info, r0,  $r13 , exception);
if(*exception != 0) {
 
return ; }
 i6  =  0 ;
label2:
 $r14  = instance_getter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_centers(gc_info, r0, exception);
if(*exception != 0) {
 
return ; }
 $i17  = edu_syr_pcpratts_array_length(gc_info,  $r14 );
if ( i6  >=  $i17   ) goto label0;
 $r15  = instance_getter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_summationCount(gc_info, r0, exception);
if(*exception != 0) {
 
return ; }
int__array_set(gc_info, $r15, i6,  -1 , exception);
if(*exception != 0) {
 
return ; }
 i6  =  i6  +  1  ;
goto label2;
label0:
 z1  =  1 ;
 z0  =  0 ;
 i7  =  0 ;
label20:
if ( z1  ==  0   ) goto label3;
 r1  = (int)  -1 ;
 i8  =  0 ;
if ( i5  !=  0   ) goto label4;
 $r16  = instance_getter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_cache(gc_info, r0, exception);
if(*exception != 0) {
 
return ; }
if ( $r16  ==  -1   ) goto label5;
if ( z0  ==  0   ) goto label6;
label5:
 $r17  = instance_getter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_cache(gc_info, r0, exception);
if(*exception != 0) {
 
return ; }
if ( $r17  !=  -1   ) goto label7;
 $r18  =  -1 ;
edu_syr_pcpratts_gc_assign (gc_info, 
&$r18, at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVectorList_initab850b60f96d11de8a390800200c9a660_(gc_info, exception));
if(*exception != 0) {
 
return ; }
instance_setter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_cache(gc_info, r0,  $r18 , exception);
if(*exception != 0) {
 
return ; }
 z0  =  1 ;
label7:
 r2  =  edu_syr_pcpratts_string_constant(gc_info, (char *) "", exception) ;
 $r19  =  -1 ;
edu_syr_pcpratts_gc_assign (gc_info, 
&$r19, edu_syr_pcpratts_rootbeer_runtime_KeyValuePair_initab850b60f96d11de8a390800200c9a660_13_13_(gc_info,
  r2 ,
  -1 , exception));
if(*exception != 0) {
 
return ; }
 r3  =  $r19 ;
label12:
if ( i8  >=  i2   ) goto label8;
 z1  = edu_syr_pcpratts_rootbeer_runtime_HamaPeer_readNext(gc_info,  r3 , exception);
if(*exception != 0) {
 
return ; }
 z0  =  z1 ;
if ( z1  !=  0   ) goto label9;
goto label8;
label9:
 $r20  = edu_syr_pcpratts_rootbeer_runtime_KeyValuePair_getKey13_(gc_info,
 r3, exception);
if(*exception != 0) {
 
return ; }
 r21  = (int)  $r20 ;
 $r22  =  -1 ;
edu_syr_pcpratts_gc_assign (gc_info, 
&$r22, at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVector_initab850b60f96d11de8a390800200c9a660_9_(gc_info,
  r21 , exception));
if(*exception != 0) {
 
return ; }
 r4  =  $r22 ;
if ( r1  !=  -1   ) goto label11;
 $i18  = at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVector_getLength5_(gc_info,
 r4, exception);
if(*exception != 0) {
 
return ; }
 r1  = double__array__array_new_multi_array(gc_info,  i2 ,  $i18 , exception);
label11:
 $r23  = at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVector_toArraya12_(gc_info,
 r4, exception);
if(*exception != 0) {
 
return ; }
double__array__array_set(gc_info, r1, i8,  $r23 , exception);
if(*exception != 0) {
 
return ; }
 $r24  = instance_getter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_cache(gc_info, r0, exception);
if(*exception != 0) {
 
return ; }
at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVectorList_add0_11_(gc_info,
 $r24,
  r4 , exception);
if(*exception != 0) {
 
return ; }
 i8  =  i8  +  1  ;
goto label12;
label8:
goto label4;
label6:
 i19  =  i7 ;
label18:
if ( i8  >=  i2   ) goto label14;
 $r25  = instance_getter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_cache(gc_info, r0, exception);
if(*exception != 0) {
 
return ; }
 r26  = at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVectorList_get11_5_(gc_info,
 $r25,
  i19 , exception);
if(*exception != 0) {
 
return ; }
if ( r1  !=  -1   ) goto label15;
 $i20  = at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVector_getLength5_(gc_info,
 r26, exception);
if(*exception != 0) {
 
return ; }
 r1  = double__array__array_new_multi_array(gc_info,  i2 ,  $i20 , exception);
label15:
 $r27  = at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVector_toArraya12_(gc_info,
 r26, exception);
if(*exception != 0) {
 
return ; }
double__array__array_set(gc_info, r1, i8,  $r27 , exception);
if(*exception != 0) {
 
return ; }
 i8  =  i8  +  1  ;
 i19  =  i19  +  1  ;
 $r28  = instance_getter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_cache(gc_info, r0, exception);
if(*exception != 0) {
 
return ; }
 $i21  = at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVectorList_getLength5_(gc_info,
 $r28, exception);
if(*exception != 0) {
 
return ; }
if ( i19  !=  $i21   ) goto label16;
 z1  =  0 ;
goto label14;
label16:
goto label18;
label14:
 i7  =  i19 ;
label4:
edu_syr_pcpratts_rootbeer_runtime_RootbeerGpu_syncthreads(gc_info, exception);
if(*exception != 0) {
 
return ; }
if ( i5  >=  i8   ) goto label19;
 r29  = double__array__array_get(gc_info, r1, i5, exception);
if(*exception != 0) {
 
return ; }
 i22  = at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_getNearestCenter5_a12_(gc_info,
 r0,
  r29 , exception);
if(*exception != 0) {
 
return ; }
at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_assignCenters0_5_a12_(gc_info,
 r0,
  i22 ,
  r29 , exception);
if(*exception != 0) {
 
return ; }
label19:
edu_syr_pcpratts_rootbeer_runtime_RootbeerGpu_syncthreads(gc_info, exception);
if(*exception != 0) {
 
return ; }
goto label20;
label3:
if ( i5  !=  0   ) goto label21;
 r30  = edu_syr_pcpratts_rootbeer_runtime_HamaPeer_getAllPeerNames(gc_info, exception);
if(*exception != 0) {
 
return ; }
 i23  =  0 ;
label29:
 $r31  = instance_getter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_newCenters(gc_info, r0, exception);
if(*exception != 0) {
 
return ; }
 $i24  = edu_syr_pcpratts_array_length(gc_info,  $r31 );
if ( i23  >=  $i24   ) goto label21;
 $r32  = instance_getter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_summationCount(gc_info, r0, exception);
if(*exception != 0) {
 
return ; }
 $i25  = int__array_get(gc_info, $r32, i23, exception);
if(*exception != 0) {
 
return ; }
if ( $i25  ==  -1   ) goto label23;
 r33  =  edu_syr_pcpratts_string_constant(gc_info, (char *) "", exception) ;
 $r34  =  -1 ;
edu_syr_pcpratts_gc_assign (gc_info, 
&$r34, java_lang_StringBuilder_initab850b60f96d11de8a390800200c9a660_(gc_info, exception));
if(*exception != 0) {
 
return ; }
 $r35  = java_lang_StringBuilder_append10_9_(gc_info,
 $r34,
  r33 , exception);
if(*exception != 0) {
 
return ; }
 $r36  = java_lang_Integer_toString9_5_(gc_info,  i23 , exception);
if(*exception != 0) {
 
return ; }
 $r37  = java_lang_StringBuilder_append10_9_(gc_info,
 $r35,
  $r36 , exception);
if(*exception != 0) {
 
return ; }
 r38  = invoke_java_lang_StringBuilder_toString9_(gc_info,
 $r37, exception);
if(*exception != 0) {
 
return ; }
 $r39  =  -1 ;
edu_syr_pcpratts_gc_assign (gc_info, 
&$r39, java_lang_StringBuilder_initab850b60f96d11de8a390800200c9a660_(gc_info, exception));
if(*exception != 0) {
 
return ; }
 $r40  = java_lang_StringBuilder_append10_9_(gc_info,
 $r39,
  r38 , exception);
if(*exception != 0) {
 
return ; }
 $r41  = java_lang_StringBuilder_append10_9_(gc_info,
 $r40,
  edu_syr_pcpratts_string_constant(gc_info, (char *) ":", exception) , exception);
if(*exception != 0) {
 
return ; }
 r42  = invoke_java_lang_StringBuilder_toString9_(gc_info,
 $r41, exception);
if(*exception != 0) {
 
return ; }
 $r43  =  -1 ;
edu_syr_pcpratts_gc_assign (gc_info, 
&$r43, java_lang_StringBuilder_initab850b60f96d11de8a390800200c9a660_(gc_info, exception));
if(*exception != 0) {
 
return ; }
 $r44  = java_lang_StringBuilder_append10_9_(gc_info,
 $r43,
  r42 , exception);
if(*exception != 0) {
 
return ; }
 $r45  = instance_getter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_summationCount(gc_info, r0, exception);
if(*exception != 0) {
 
return ; }
 $i26  = int__array_get(gc_info, $r45, i23, exception);
if(*exception != 0) {
 
return ; }
 $r46  = java_lang_Integer_toString9_5_(gc_info,  $i26 , exception);
if(*exception != 0) {
 
return ; }
 $r47  = java_lang_StringBuilder_append10_9_(gc_info,
 $r44,
  $r46 , exception);
if(*exception != 0) {
 
return ; }
 r48  = invoke_java_lang_StringBuilder_toString9_(gc_info,
 $r47, exception);
if(*exception != 0) {
 
return ; }
 $r49  =  -1 ;
edu_syr_pcpratts_gc_assign (gc_info, 
&$r49, java_lang_StringBuilder_initab850b60f96d11de8a390800200c9a660_(gc_info, exception));
if(*exception != 0) {
 
return ; }
 $r50  = java_lang_StringBuilder_append10_9_(gc_info,
 $r49,
  r48 , exception);
if(*exception != 0) {
 
return ; }
 $r51  = java_lang_StringBuilder_append10_9_(gc_info,
 $r50,
  edu_syr_pcpratts_string_constant(gc_info, (char *) ":", exception) , exception);
if(*exception != 0) {
 
return ; }
 r52  = invoke_java_lang_StringBuilder_toString9_(gc_info,
 $r51, exception);
if(*exception != 0) {
 
return ; }
 i27  =  0 ;
label26:
 $r53  = instance_getter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_newCenters(gc_info, r0, exception);
if(*exception != 0) {
 
return ; }
 $r54  = double__array__array_get(gc_info, $r53, i23, exception);
if(*exception != 0) {
 
return ; }
 $i28  = edu_syr_pcpratts_array_length(gc_info,  $r54 );
if ( i27  >=  $i28   ) goto label24;
 $r55  =  -1 ;
edu_syr_pcpratts_gc_assign (gc_info, 
&$r55, java_lang_StringBuilder_initab850b60f96d11de8a390800200c9a660_(gc_info, exception));
if(*exception != 0) {
 
return ; }
 $r56  = java_lang_StringBuilder_append10_9_(gc_info,
 $r55,
  r52 , exception);
if(*exception != 0) {
 
return ; }
 $r57  = instance_getter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_newCenters(gc_info, r0, exception);
if(*exception != 0) {
 
return ; }
 $r58  = double__array__array_get(gc_info, $r57, i23, exception);
if(*exception != 0) {
 
return ; }
 $d0  = double__array_get(gc_info, $r58, i27, exception);
if(*exception != 0) {
 
return ; }
 $r59  = java_lang_Double_toString9_8_(gc_info,  $d0 , exception);
if(*exception != 0) {
 
return ; }
 $r60  = java_lang_StringBuilder_append10_9_(gc_info,
 $r56,
  $r59 , exception);
if(*exception != 0) {
 
return ; }
 r52  = invoke_java_lang_StringBuilder_toString9_(gc_info,
 $r60, exception);
if(*exception != 0) {
 
return ; }
 $r61  = instance_getter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_newCenters(gc_info, r0, exception);
if(*exception != 0) {
 
return ; }
 $r62  = double__array__array_get(gc_info, $r61, i23, exception);
if(*exception != 0) {
 
return ; }
 $i29  = edu_syr_pcpratts_array_length(gc_info,  $r62 );
 $i30  =  $i29  -  1  ;
if ( i27  >=  $i30   ) goto label25;
 $r63  =  -1 ;
edu_syr_pcpratts_gc_assign (gc_info, 
&$r63, java_lang_StringBuilder_initab850b60f96d11de8a390800200c9a660_(gc_info, exception));
if(*exception != 0) {
 
return ; }
 $r64  = java_lang_StringBuilder_append10_9_(gc_info,
 $r63,
  r52 , exception);
if(*exception != 0) {
 
return ; }
 $r65  = java_lang_StringBuilder_append10_9_(gc_info,
 $r64,
  edu_syr_pcpratts_string_constant(gc_info, (char *) ", ", exception) , exception);
if(*exception != 0) {
 
return ; }
 r52  = invoke_java_lang_StringBuilder_toString9_(gc_info,
 $r65, exception);
if(*exception != 0) {
 
return ; }
label25:
 i27  =  i27  +  1  ;
goto label26;
label24:
 $r66  = static_getter_java_lang_System_out(gc_info, exception);
java_io_PrintStream_print0_9_(gc_info,
 $r66,
  edu_syr_pcpratts_string_constant(gc_info, (char *) "send message: \'", exception) , exception);
if(*exception != 0) {
 
return ; }
 $r67  = static_getter_java_lang_System_out(gc_info, exception);
java_io_PrintStream_print0_9_(gc_info,
 $r67,
  r52 , exception);
if(*exception != 0) {
 
return ; }
 $r68  = static_getter_java_lang_System_out(gc_info, exception);
java_io_PrintStream_println0_9_(gc_info,
 $r68,
  edu_syr_pcpratts_string_constant(gc_info, (char *) "\'", exception) , exception);
if(*exception != 0) {
 
return ; }
 r69  =  r30 ;
 i31  = edu_syr_pcpratts_array_length(gc_info,  r69 );
 i9  =  0 ;
label28:
if ( i9  >=  i31   ) goto label23;
 r5  = java_lang_String__array_get(gc_info, r69, i9, exception);
if(*exception != 0) {
 
return ; }
edu_syr_pcpratts_rootbeer_runtime_HamaPeer_send(gc_info,  r5 ,  r52 , exception);
if(*exception != 0) {
 
return ; }
 i9  =  i9  +  1  ;
goto label28;
label23:
 i23  =  i23  +  1  ;
goto label29;
label21:
edu_syr_pcpratts_rootbeer_runtime_HamaPeer_sync(gc_info, exception);
if(*exception != 0) {
 
return ; }
 $r70  = instance_getter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_centers(gc_info, r0, exception);
if(*exception != 0) {
 
return ; }
 $i32  = edu_syr_pcpratts_array_length(gc_info,  $r70 );
 $r71  = instance_getter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_centers(gc_info, r0, exception);
if(*exception != 0) {
 
return ; }
 $r72  = double__array__array_get(gc_info, $r71, 0, exception);
if(*exception != 0) {
 
return ; }
 $i33  = edu_syr_pcpratts_array_length(gc_info,  $r72 );
 r73  = double__array__array_new_multi_array(gc_info,  $i32 ,  $i33 , exception);
 $r74  = instance_getter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_centers(gc_info, r0, exception);
if(*exception != 0) {
 
return ; }
 $i34  = edu_syr_pcpratts_array_length(gc_info,  $r74 );
 r75  = int__array_new(gc_info,  $i34 , exception);
if ( i5  !=  0   ) goto label30;
 i35  = edu_syr_pcpratts_rootbeer_runtime_HamaPeer_getNumCurrentMessages(gc_info, exception);
if(*exception != 0) {
 
return ; }
 i36  =  0 ;
label38:
if ( i36  >=  i35   ) goto label31;
 r76  = edu_syr_pcpratts_rootbeer_runtime_HamaPeer_getCurrentStringMessage(gc_info, exception);
if(*exception != 0) {
 
return ; }
 $r77  = static_getter_java_lang_System_out(gc_info, exception);
java_io_PrintStream_print0_9_(gc_info,
 $r77,
  edu_syr_pcpratts_string_constant(gc_info, (char *) "got message: \'", exception) , exception);
if(*exception != 0) {
 
return ; }
 $r78  = static_getter_java_lang_System_out(gc_info, exception);
java_io_PrintStream_print0_9_(gc_info,
 $r78,
  r76 , exception);
if(*exception != 0) {
 
return ; }
 $r79  = static_getter_java_lang_System_out(gc_info, exception);
java_io_PrintStream_println0_9_(gc_info,
 $r79,
  edu_syr_pcpratts_string_constant(gc_info, (char *) "\'", exception) , exception);
if(*exception != 0) {
 
return ; }
 r80  = java_lang_String_split(gc_info,
 r76,
  edu_syr_pcpratts_string_constant(gc_info, (char *) ":", exception) ,
  3 , exception);
if(*exception != 0) {
 
return ; }
 $r81  = java_lang_String__array_get(gc_info, r80, 0, exception);
if(*exception != 0) {
 
return ; }
 i37  = java_lang_Integer_parseInt(gc_info,  $r81 , exception);
if(*exception != 0) {
 
return ; }
 $r82  = java_lang_String__array_get(gc_info, r80, 1, exception);
if(*exception != 0) {
 
return ; }
 i10  = java_lang_Integer_parseInt(gc_info,  $r82 , exception);
if(*exception != 0) {
 
return ; }
 $r83  = java_lang_String__array_get(gc_info, r80, 2, exception);
if(*exception != 0) {
 
return ; }
 r6  = java_lang_String_split(gc_info,
 $r83,
  edu_syr_pcpratts_string_constant(gc_info, (char *) ",", exception) , exception);
if(*exception != 0) {
 
return ; }
 i11  = edu_syr_pcpratts_array_length(gc_info,  r6 );
 r7  = double__array_new(gc_info,  i11 , exception);
 i12  =  0 ;
label33:
if ( i12  >=  i11   ) goto label32;
 $r84  = java_lang_String__array_get(gc_info, r6, i12, exception);
if(*exception != 0) {
 
return ; }
 $d1  = java_lang_Double_parseDouble(gc_info,  $r84 , exception);
if(*exception != 0) {
 
return ; }
double__array_set(gc_info, r7, i12,  $d1 , exception);
if(*exception != 0) {
 
return ; }
 i12  =  i12  +  1  ;
goto label33;
label32:
 $i38  = int__array_get(gc_info, r75, i37, exception);
if(*exception != 0) {
 
return ; }
if ( $i38  !=  0   ) goto label34;
double__array__array_set(gc_info, r73, i37,  r7 , exception);
if(*exception != 0) {
 
return ; }
goto label35;
label34:
 i39  =  0 ;
label37:
 $r85  = double__array__array_get(gc_info, r73, i37, exception);
if(*exception != 0) {
 
return ; }
 $i40  = edu_syr_pcpratts_array_length(gc_info,  $r85 );
if ( i39  >=  $i40   ) goto label35;
 $r86  = double__array__array_get(gc_info, r73, i37, exception);
if(*exception != 0) {
 
return ; }
 $d2  = double__array_get(gc_info, $r86, i39, exception);
if(*exception != 0) {
 
return ; }
 $d3  = double__array_get(gc_info, r7, i39, exception);
if(*exception != 0) {
 
return ; }
 $d4  =  $d2  +  $d3  ;
double__array_set(gc_info, $r86, i39,  $d4 , exception);
if(*exception != 0) {
 
return ; }
 i39  =  i39  +  1  ;
goto label37;
label35:
 $i43  = int__array_get(gc_info, r75, i37, exception);
if(*exception != 0) {
 
return ; }
 $i44  =  $i43  +  i10  ;
int__array_set(gc_info, r75, i37,  $i44 , exception);
if(*exception != 0) {
 
return ; }
 i36  =  i36  +  1  ;
goto label38;
label31:
 i45  =  0 ;
label43:
 $i46  = edu_syr_pcpratts_array_length(gc_info,  r73 );
if ( i45  >=  $i46   ) goto label39;
 $i47  = int__array_get(gc_info, r75, i45, exception);
if(*exception != 0) {
 
return ; }
if ( $i47  ==  0   ) goto label40;
 i48  =  0 ;
label42:
 $r88  = double__array__array_get(gc_info, r73, i45, exception);
if(*exception != 0) {
 
return ; }
 $i49  = edu_syr_pcpratts_array_length(gc_info,  $r88 );
if ( i48  >=  $i49   ) goto label40;
 $r89  = double__array__array_get(gc_info, r73, i45, exception);
if(*exception != 0) {
 
return ; }
 $d5  = double__array_get(gc_info, $r89, i48, exception);
if(*exception != 0) {
 
return ; }
 $i51  = int__array_get(gc_info, r75, i45, exception);
if(*exception != 0) {
 
return ; }
 $d6  = (double)  $i51 ;
 $d7  =  $d5  /  $d6  ;
double__array_set(gc_info, $r89, i48,  $d7 , exception);
if(*exception != 0) {
 
return ; }
 i48  =  i48  +  1  ;
goto label42;
label40:
 i45  =  i45  +  1  ;
goto label43;
label39:
 l52  =  0L ;
 i53  =  0 ;
label49:
 $i54  = edu_syr_pcpratts_array_length(gc_info,  r73 );
if ( i53  >=  $i54   ) goto label44;
 $i55  = int__array_get(gc_info, r75, i53, exception);
if(*exception != 0) {
 
return ; }
if ( $i55  ==  0   ) goto label45;
 d8  =  0.0 ;
 i56  =  0 ;
label47:
 $r90  = instance_getter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_centers(gc_info, r0, exception);
if(*exception != 0) {
 
return ; }
 $r91  = double__array__array_get(gc_info, $r90, i53, exception);
if(*exception != 0) {
 
return ; }
 $i57  = edu_syr_pcpratts_array_length(gc_info,  $r91 );
if ( i56  >=  $i57   ) goto label46;
 $r92  = instance_getter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_centers(gc_info, r0, exception);
if(*exception != 0) {
 
return ; }
 $r93  = double__array__array_get(gc_info, $r92, i53, exception);
if(*exception != 0) {
 
return ; }
 $d9  = double__array_get(gc_info, $r93, i56, exception);
if(*exception != 0) {
 
return ; }
 $r94  = double__array__array_get(gc_info, r73, i53, exception);
if(*exception != 0) {
 
return ; }
 $d10  = double__array_get(gc_info, $r94, i56, exception);
if(*exception != 0) {
 
return ; }
 $d11  =  $d9  -  $d10  ;
 $d12  = java_lang_Math_abs8_8_(gc_info,  $d11 , exception);
if(*exception != 0) {
 
return ; }
 d8  =  d8  +  $d12  ;
 i56  =  i56  +  1  ;
goto label47;
label46:
 $r95  = static_getter_java_lang_System_out(gc_info, exception);
java_io_PrintStream_print0_9_(gc_info,
 $r95,
  edu_syr_pcpratts_string_constant(gc_info, (char *) "calculateError: ", exception) , exception);
if(*exception != 0) {
 
return ; }
 $r96  = static_getter_java_lang_System_out(gc_info, exception);
java_io_PrintStream_println0_8_(gc_info,
 $r96,
  d8 , exception);
if(*exception != 0) {
 
return ; }
 $b58  = edu_syr_pcpratts_cmpl((double) d8 , (double) 0.0 );
if ( $b58  <=  0   ) goto label45;
 $r97  = instance_getter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_centers(gc_info, r0, exception);
if(*exception != 0) {
 
return ; }
 $r98  = double__array__array_get(gc_info, r73, i53, exception);
if(*exception != 0) {
 
return ; }
double__array__array_set(gc_info, $r97, i53,  $r98 , exception);
if(*exception != 0) {
 
return ; }
 l52  =  l52  +  1L  ;
label45:
 i53  =  i53  +  1  ;
goto label49;
label44:
instance_setter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_converged(gc_info, r0,  l52 , exception);
if(*exception != 0) {
 
return ; }
 $l59  = edu_syr_pcpratts_rootbeer_runtime_HamaPeer_getSuperstepCount(gc_info, exception);
if(*exception != 0) {
 
return ; }
instance_setter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_superstepCount(gc_info, r0,  $l59 , exception);
if(*exception != 0) {
 
return ; }
edu_syr_pcpratts_rootbeer_runtime_HamaPeer_reopenInput(gc_info, exception);
if(*exception != 0) {
 
return ; }
label30:
edu_syr_pcpratts_rootbeer_runtime_RootbeerGpu_syncthreads(gc_info, exception);
if(*exception != 0) {
 
return ; }
 $r99  = static_getter_java_lang_System_out(gc_info, exception);
java_io_PrintStream_print0_9_(gc_info,
 $r99,
  edu_syr_pcpratts_string_constant(gc_info, (char *) "m_converged: ", exception) , exception);
if(*exception != 0) {
 
return ; }
 $r100  = static_getter_java_lang_System_out(gc_info, exception);
 $l60  = instance_getter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_converged(gc_info, r0, exception);
if(*exception != 0) {
 
return ; }
java_io_PrintStream_println0_6_(gc_info,
 $r100,
  $l60 , exception);
if(*exception != 0) {
 
return ; }
 $l61  = instance_getter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_converged(gc_info, r0, exception);
if(*exception != 0) {
 
return ; }
 $b62  = edu_syr_pcpratts_cmp( $l61 ,  0L );
if ( $b62  !=  0   ) goto label50;
goto label51;
label50:
 $i63  = instance_getter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_maxIterations(gc_info, r0, exception);
if(*exception != 0) {
 
return ; }
if ( $i63  <=  0   ) goto label52;
 $i64  = instance_getter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_maxIterations(gc_info, r0, exception);
if(*exception != 0) {
 
return ; }
 $l65  = (long long)  $i64 ;
 $l66  = instance_getter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_superstepCount(gc_info, r0, exception);
if(*exception != 0) {
 
return ; }
 $b67  = edu_syr_pcpratts_cmp( $l65 ,  $l66 );
if ( $b67  >=  0   ) goto label52;
goto label51;
label52:
goto label55;
label51:
 $r101  = static_getter_java_lang_System_out(gc_info, exception);
java_io_PrintStream_println0_9_(gc_info,
 $r101,
  edu_syr_pcpratts_string_constant(gc_info, (char *) "Finished! Writing the assignments...", exception) , exception);
if(*exception != 0) {
 
return ; }
 $r102  = static_getter_java_lang_System_out(gc_info, exception);
java_io_PrintStream_println0_9_(gc_info,
 $r102,
  edu_syr_pcpratts_string_constant(gc_info, (char *) "Done.", exception) , exception);
if(*exception != 0) {
 
return ; }
return;
}
__device__ int int__array_get( char * gc_info, int thisref, int parameter0, int * exception){
int offset;
int length;
 char * thisref_deref;
offset = 32+(parameter0*4);
if(thisref == -1){
  *exception = 21352;
  return 0;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
length = edu_syr_pcpratts_getint(thisref_deref, 12);
if(parameter0 < 0 || parameter0 >= length){
  *exception = edu_syr_pcpratts_rootbeer_runtimegpu_GpuException_arrayOutOfBounds(gc_info, parameter0, thisref, length, exception);  return 0;
}
return *(( int *) &thisref_deref[offset]);
}
__device__ void int__array_set( char * gc_info, int thisref, int parameter0, int parameter1, int * exception){
int length;
 char * thisref_deref;
  if(thisref == -1){
    *exception = 21352;
    return;
  }
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
length = edu_syr_pcpratts_getint(thisref_deref, 12);
if(parameter0 < 0 || parameter0 >= length){
  *exception = edu_syr_pcpratts_rootbeer_runtimegpu_GpuException_arrayOutOfBounds(gc_info, parameter0, thisref, length, exception);  return;
}
*(( int *) &thisref_deref[32+(parameter0*4)]) = parameter1;
}
__device__ int int__array_new( char * gc_info, int size, int * exception){
int i;
int total_size;
int mod;
int thisref;
 char * thisref_deref;
total_size = (size * 4)+ 32;
mod = total_size % 8;
if(mod != 0)
  total_size += (8 - mod);
thisref = edu_syr_pcpratts_gc_malloc(gc_info, total_size);
if(thisref == -1){
  *exception = 21352;
  return -1;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
edu_syr_pcpratts_gc_set_count(thisref_deref, 0);
edu_syr_pcpratts_gc_set_color(thisref_deref, COLOR_GREY);
edu_syr_pcpratts_gc_set_type(thisref_deref, 3346);
edu_syr_pcpratts_gc_set_ctor_used(thisref_deref, 1);
edu_syr_pcpratts_gc_set_size(thisref_deref, total_size);
edu_syr_pcpratts_setint(thisref_deref, 12, size);
for(i = 0; i < size; ++i){
  int__array_set(gc_info, thisref, i, 0, exception);
}
return thisref;
}
__device__ void java_lang_IndexOutOfBoundsException_initab850b60f96d11de8a390800200c9a66_body0_9_( char * gc_info, int thisref, int parameter0, int * exception){
int r0 = -1;
int r1 = -1;
 r0  =  thisref ;
 r1  =  parameter0 ;
java_lang_RuntimeException_initab850b60f96d11de8a390800200c9a66_body0_9_(gc_info,
 thisref,
  r1 , exception);
return;
}
__device__ int at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVector_initab850b60f96d11de8a390800200c9a660_9_( char * gc_info, int parameter0, int * exception){
int r0 = -1;
int r1 = -1;
int r2 = -1;
int i0;
int $i1;
int $r3 = -1;
int $i2;
int $r4 = -1;
int $r5 = -1;
double $d0;
int $i3;
int $r6 = -1;
int $r7 = -1;
int thisref;
 char * thisref_deref;
thisref = -1;
edu_syr_pcpratts_gc_assign(gc_info, &thisref, edu_syr_pcpratts_gc_malloc(gc_info, 48));
if(thisref == -1){
  *exception = 21106;
  return -1;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
edu_syr_pcpratts_gc_set_count(thisref_deref, 1);
edu_syr_pcpratts_gc_set_color(thisref_deref, COLOR_GREY);
edu_syr_pcpratts_gc_set_type(thisref_deref, 2907);
edu_syr_pcpratts_gc_set_ctor_used(thisref_deref, 1);
edu_syr_pcpratts_gc_set_size(thisref_deref, 48);
edu_syr_pcpratts_gc_init_monitor(thisref_deref);
instance_setter_at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVector_m_vector(gc_info, thisref, -1, exception);
instance_setter_at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVector_m_index(gc_info, thisref, 0, exception);
 r0  =  thisref ;
 r1  =  parameter0 ;
 r2  = java_lang_String_split(gc_info,
 r1,
  edu_syr_pcpratts_string_constant(gc_info, (char *) ",", exception) , exception);
if(*exception != 0) {
 
return 0; }
if ( r2  ==  -1   ) goto label0;
 $i1  = edu_syr_pcpratts_array_length(gc_info,  r2 );
 $r3  = double__array_new(gc_info,  $i1 , exception);
instance_setter_at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVector_m_vector(gc_info, r0,  $r3 , exception);
if(*exception != 0) {
 
return 0; }
 i0  =  0 ;
label2:
 $i2  = edu_syr_pcpratts_array_length(gc_info,  r2 );
if ( i0  >=  $i2   ) goto label1;
 $r4  = instance_getter_at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVector_m_vector(gc_info, r0, exception);
if(*exception != 0) {
 
return 0; }
 $r5  = java_lang_String__array_get(gc_info, r2, i0, exception);
if(*exception != 0) {
 
return 0; }
 $d0  = java_lang_Double_parseDouble(gc_info,  $r5 , exception);
if(*exception != 0) {
 
return 0; }
double__array_set(gc_info, $r4, i0,  $d0 , exception);
if(*exception != 0) {
 
return 0; }
 i0  =  i0  +  1  ;
goto label2;
label1:
 $i3  = edu_syr_pcpratts_array_length(gc_info,  r2 );
instance_setter_at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVector_m_index(gc_info, r0,  $i3 , exception);
if(*exception != 0) {
 
return 0; }
goto label3;
label0:
 $r6  = static_getter_java_lang_System_out(gc_info, exception);
java_io_PrintStream_println0_9_(gc_info,
 $r6,
  edu_syr_pcpratts_string_constant(gc_info, (char *) "DenseDoubleVector no values found!", exception) , exception);
if(*exception != 0) {
 
return 0; }
 $r7  = double__array_new(gc_info,  128 , exception);
instance_setter_at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVector_m_vector(gc_info, r0,  $r7 , exception);
if(*exception != 0) {
 
return 0; }
instance_setter_at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVector_m_index(gc_info, r0,  0 , exception);
if(*exception != 0) {
 
return 0; }
label3:
return r0;
  return 0;
}
__device__ int at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVector_toArraya12_( char * gc_info, int thisref, int * exception){
int r0 = -1;
int r1 = -1;
int i0;
int $i1;
int $i2;
int $r2 = -1;
double $d0;
 r0  =  thisref ;
 $i1  = instance_getter_at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVector_m_index(gc_info, r0, exception);
if(*exception != 0) {
 
return 0; }
 r1  = double__array_new(gc_info,  $i1 , exception);
 i0  =  0 ;
label1:
 $i2  = instance_getter_at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVector_m_index(gc_info, r0, exception);
if(*exception != 0) {
 
return 0; }
if ( i0  >=  $i2   ) goto label0;
 $r2  = instance_getter_at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVector_m_vector(gc_info, r0, exception);
if(*exception != 0) {
 
return 0; }
 $d0  = double__array_get(gc_info, $r2, i0, exception);
if(*exception != 0) {
 
return 0; }
double__array_set(gc_info, r1, i0,  $d0 , exception);
if(*exception != 0) {
 
return 0; }
 i0  =  i0  +  1  ;
goto label1;
label0:
return  r1 ;
  return 0;
}
__device__ double at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_measureEuclidianDistance8_a12_a12_( char * gc_info, int thisref, int parameter0, int parameter1, int * exception){
int r0 = -1;
int r1 = -1;
int r2 = -1;
double d0;
int i0;
int i1;
double d1;
double $d2;
double $d3;
double $d4;
double $d5;
 r0  =  thisref ;
 r1  =  parameter0 ;
 r2  =  parameter1 ;
 d0  =  0.0 ;
 i0  = edu_syr_pcpratts_array_length(gc_info,  r1 );
 i1  =  0 ;
label1:
if ( i1  >=  i0   ) goto label0;
 $d2  = double__array_get(gc_info, r2, i1, exception);
if(*exception != 0) {
 
return 0; }
 $d3  = double__array_get(gc_info, r1, i1, exception);
if(*exception != 0) {
 
return 0; }
 d1  =  $d2  -  $d3  ;
 $d4  =  d1  *  d1  ;
 d0  =  d0  +  $d4  ;
 i1  =  i1  +  1  ;
goto label1;
label0:
 $d5  = java_lang_Math_sqrt8_8_(gc_info,  d0 , exception);
if(*exception != 0) {
 
return 0; }
return  $d5 ;
  return 0;
}
__device__ int instance_getter_java_lang_String_hash( char * gc_info, int thisref, int * exception){
 char * thisref_deref;
if(thisref == -1){
  *exception = 21352;
  return 0;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
return *(( int *) &thisref_deref[44]);
}
__device__ void instance_setter_java_lang_String_hash( char * gc_info, int thisref, int parameter0, int * exception){
 char * thisref_deref;
if(thisref == -1){
  *exception = 21352;
  return;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
*(( int *) &thisref_deref[44]) = parameter0;
}
__device__ void instance_setter_edu_syr_pcpratts_rootbeer_runtimegpu_GpuException_m_arrayLength( char * gc_info, int thisref, int parameter0, int * exception){
 char * thisref_deref;
if(thisref == -1){
  *exception = 21352;
  return;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
*(( int *) &thisref_deref[40]) = parameter0;
}
__device__ int instance_getter_java_lang_AbstractStringBuilder_count( char * gc_info, int thisref, int * exception){
 char * thisref_deref;
if(thisref == -1){
  *exception = 21352;
  return 0;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
return *(( int *) &thisref_deref[40]);
}
__device__ void instance_setter_java_lang_AbstractStringBuilder_count( char * gc_info, int thisref, int parameter0, int * exception){
 char * thisref_deref;
if(thisref == -1){
  *exception = 21352;
  return;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
*(( int *) &thisref_deref[40]) = parameter0;
}
__device__ int static_getter_java_lang_System_out( char * gc_info, int * exception){
 char * thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, 0);
return *(( int *) &thisref_deref[12]);
}
__device__ int instance_getter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_cache( char * gc_info, int thisref, int * exception){
 char * thisref_deref;
if(thisref == -1){
  *exception = 21352;
  return 0;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
return *(( int *) &thisref_deref[32]);
}
__device__ void instance_setter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_cache( char * gc_info, int thisref, int parameter0, int * exception){
 char * thisref_deref;
if(thisref == -1){
  *exception = 21352;
  return;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
*(( int *) &thisref_deref[32]) = parameter0;
}
__device__ void instance_setter_edu_syr_pcpratts_rootbeer_runtimegpu_GpuException_m_arrayIndex( char * gc_info, int thisref, int parameter0, int * exception){
 char * thisref_deref;
if(thisref == -1){
  *exception = 21352;
  return;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
*(( int *) &thisref_deref[36]) = parameter0;
}
__device__ int instance_getter_edu_syr_pcpratts_rootbeer_runtime_KeyValuePair_m_value( char * gc_info, int thisref, int * exception){
 char * thisref_deref;
if(thisref == -1){
  *exception = 21352;
  return 0;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
return *(( int *) &thisref_deref[36]);
}
__device__ void instance_setter_edu_syr_pcpratts_rootbeer_runtime_KeyValuePair_m_value( char * gc_info, int thisref, int parameter0, int * exception){
 char * thisref_deref;
if(thisref == -1){
  *exception = 21352;
  return;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
*(( int *) &thisref_deref[36]) = parameter0;
}
__device__ int instance_getter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_newCenters( char * gc_info, int thisref, int * exception){
 char * thisref_deref;
if(thisref == -1){
  *exception = 21352;
  return 0;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
return *(( int *) &thisref_deref[40]);
}
__device__ void instance_setter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_newCenters( char * gc_info, int thisref, int parameter0, int * exception){
 char * thisref_deref;
if(thisref == -1){
  *exception = 21352;
  return;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
*(( int *) &thisref_deref[40]) = parameter0;
}
__device__ int instance_getter_java_lang_Class_name( char * gc_info, int thisref, int * exception){
 char * thisref_deref;
if(thisref == -1){
  *exception = 21352;
  return 0;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
return *(( int *) &thisref_deref[32]);
}
__device__ int instance_getter_at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVectorList_m_index( char * gc_info, int thisref, int * exception){
 char * thisref_deref;
if(thisref == -1){
  *exception = 21352;
  return 0;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
return *(( int *) &thisref_deref[40]);
}
__device__ void instance_setter_at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVectorList_m_index( char * gc_info, int thisref, int parameter0, int * exception){
 char * thisref_deref;
if(thisref == -1){
  *exception = 21352;
  return;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
*(( int *) &thisref_deref[40]) = parameter0;
}
__device__ int instance_getter_at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVector_m_vector( char * gc_info, int thisref, int * exception){
 char * thisref_deref;
if(thisref == -1){
  *exception = 21352;
  return 0;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
return *(( int *) &thisref_deref[32]);
}
__device__ void instance_setter_at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVector_m_vector( char * gc_info, int thisref, int parameter0, int * exception){
 char * thisref_deref;
if(thisref == -1){
  *exception = 21352;
  return;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
*(( int *) &thisref_deref[32]) = parameter0;
}
__device__ long long instance_getter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_converged( char * gc_info, int thisref, int * exception){
 char * thisref_deref;
if(thisref == -1){
  *exception = 21352;
  return 0;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
return *(( long long *) &thisref_deref[48]);
}
__device__ void instance_setter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_converged( char * gc_info, int thisref, long long parameter0, int * exception){
 char * thisref_deref;
if(thisref == -1){
  *exception = 21352;
  return;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
*(( long long *) &thisref_deref[48]) = parameter0;
}
__device__ int static_getter_java_lang_Integer_sizeTable( char * gc_info, int * exception){
 char * thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, 0);
return *(( int *) &thisref_deref[8]);
}
__device__ int instance_getter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_summationCount( char * gc_info, int thisref, int * exception){
 char * thisref_deref;
if(thisref == -1){
  *exception = 21352;
  return 0;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
return *(( int *) &thisref_deref[44]);
}
__device__ void instance_setter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_summationCount( char * gc_info, int thisref, int parameter0, int * exception){
 char * thisref_deref;
if(thisref == -1){
  *exception = 21352;
  return;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
*(( int *) &thisref_deref[44]) = parameter0;
}
__device__ int static_getter_java_lang_Integer_DigitOnes( char * gc_info, int * exception){
 char * thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, 0);
return *(( int *) &thisref_deref[16]);
}
__device__ long long instance_getter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_superstepCount( char * gc_info, int thisref, int * exception){
 char * thisref_deref;
if(thisref == -1){
  *exception = 21352;
  return 0;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
return *(( long long *) &thisref_deref[56]);
}
__device__ void instance_setter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_superstepCount( char * gc_info, int thisref, long long parameter0, int * exception){
 char * thisref_deref;
if(thisref == -1){
  *exception = 21352;
  return;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
*(( long long *) &thisref_deref[56]) = parameter0;
}
__device__ int static_getter_java_lang_Integer_DigitTens( char * gc_info, int * exception){
 char * thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, 0);
return *(( int *) &thisref_deref[20]);
}
__device__ void instance_setter_java_lang_Throwable_cause( char * gc_info, int thisref, int parameter0, int * exception){
 char * thisref_deref;
if(thisref == -1){
  *exception = 21352;
  return;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
*(( int *) &thisref_deref[32]) = parameter0;
}
__device__ int instance_getter_at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVectorList_m_values( char * gc_info, int thisref, int * exception){
 char * thisref_deref;
if(thisref == -1){
  *exception = 21352;
  return 0;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
return *(( int *) &thisref_deref[32]);
}
__device__ void instance_setter_at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVectorList_m_values( char * gc_info, int thisref, int parameter0, int * exception){
 char * thisref_deref;
if(thisref == -1){
  *exception = 21352;
  return;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
*(( int *) &thisref_deref[32]) = parameter0;
}
__device__ void instance_setter_edu_syr_pcpratts_rootbeer_runtimegpu_GpuException_m_array( char * gc_info, int thisref, int parameter0, int * exception){
 char * thisref_deref;
if(thisref == -1){
  *exception = 21352;
  return;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
*(( int *) &thisref_deref[32]) = parameter0;
}
__device__ int instance_getter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_maxIterations( char * gc_info, int thisref, int * exception){
 char * thisref_deref;
if(thisref == -1){
  *exception = 21352;
  return 0;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
return *(( int *) &thisref_deref[64]);
}
__device__ int instance_getter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_centers( char * gc_info, int thisref, int * exception){
 char * thisref_deref;
if(thisref == -1){
  *exception = 21352;
  return 0;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
return *(( int *) &thisref_deref[36]);
}
__device__ int instance_getter_java_lang_String_count( char * gc_info, int thisref, int * exception){
 char * thisref_deref;
if(thisref == -1){
  *exception = 21352;
  return 0;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
return *(( int *) &thisref_deref[40]);
}
__device__ void instance_setter_java_lang_String_count( char * gc_info, int thisref, int parameter0, int * exception){
 char * thisref_deref;
if(thisref == -1){
  *exception = 21352;
  return;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
*(( int *) &thisref_deref[40]) = parameter0;
}
__device__ int instance_getter_edu_syr_pcpratts_rootbeer_runtime_KeyValuePair_m_key( char * gc_info, int thisref, int * exception){
 char * thisref_deref;
if(thisref == -1){
  *exception = 21352;
  return 0;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
return *(( int *) &thisref_deref[32]);
}
__device__ void instance_setter_edu_syr_pcpratts_rootbeer_runtime_KeyValuePair_m_key( char * gc_info, int thisref, int parameter0, int * exception){
 char * thisref_deref;
if(thisref == -1){
  *exception = 21352;
  return;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
*(( int *) &thisref_deref[32]) = parameter0;
}
__device__ int instance_getter_java_lang_AbstractStringBuilder_value( char * gc_info, int thisref, int * exception){
 char * thisref_deref;
if(thisref == -1){
  *exception = 21352;
  return 0;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
return *(( int *) &thisref_deref[32]);
}
__device__ void instance_setter_java_lang_AbstractStringBuilder_value( char * gc_info, int thisref, int parameter0, int * exception){
 char * thisref_deref;
if(thisref == -1){
  *exception = 21352;
  return;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
*(( int *) &thisref_deref[32]) = parameter0;
}
__device__ int instance_getter_at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVector_m_index( char * gc_info, int thisref, int * exception){
 char * thisref_deref;
if(thisref == -1){
  *exception = 21352;
  return 0;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
return *(( int *) &thisref_deref[40]);
}
__device__ void instance_setter_at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVector_m_index( char * gc_info, int thisref, int parameter0, int * exception){
 char * thisref_deref;
if(thisref == -1){
  *exception = 21352;
  return;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
*(( int *) &thisref_deref[40]) = parameter0;
}
__device__ int instance_getter_java_lang_String_value( char * gc_info, int thisref, int * exception){
 char * thisref_deref;
if(thisref == -1){
  *exception = 21352;
  return 0;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
return *(( int *) &thisref_deref[32]);
}
__device__ void instance_setter_java_lang_String_value( char * gc_info, int thisref, int parameter0, int * exception){
 char * thisref_deref;
if(thisref == -1){
  *exception = 21352;
  return;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
*(( int *) &thisref_deref[32]) = parameter0;
}
__device__ int instance_getter_java_lang_String_offset( char * gc_info, int thisref, int * exception){
 char * thisref_deref;
if(thisref == -1){
  *exception = 21352;
  return 0;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
return *(( int *) &thisref_deref[48]);
}
__device__ void instance_setter_java_lang_String_offset( char * gc_info, int thisref, int parameter0, int * exception){
 char * thisref_deref;
if(thisref == -1){
  *exception = 21352;
  return;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
*(( int *) &thisref_deref[48]) = parameter0;
}
__device__ void instance_setter_java_lang_Throwable_detailMessage( char * gc_info, int thisref, int parameter0, int * exception){
 char * thisref_deref;
if(thisref == -1){
  *exception = 21352;
  return;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
*(( int *) &thisref_deref[36]) = parameter0;
}
__device__ int static_getter_java_lang_Integer_digits( char * gc_info, int * exception){
 char * thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, 0);
return *(( int *) &thisref_deref[0]);
}
__device__ void java_lang_RuntimeException_initab850b60f96d11de8a390800200c9a66_body0_9_( char * gc_info, int thisref, int parameter0, int * exception){
int r0 = -1;
int r1 = -1;
 r0  =  thisref ;
 r1  =  parameter0 ;
java_lang_Exception_initab850b60f96d11de8a390800200c9a66_body0_9_(gc_info,
 thisref,
  r1 , exception);
return;
}
__device__ int java_lang_Integer_toString9_5_( char * gc_info, int parameter0, int * exception){
int i0;
int i1;
int r0 = -1;
int $i2;
int $i3;
int $i4;
int $r1 = -1;
 i0  =  parameter0 ;
if ( i0  !=  -2147483648   ) goto label0;
return  edu_syr_pcpratts_string_constant(gc_info, (char *) "-2147483648", exception) ;
label0:
if ( i0  >=  0   ) goto label1;
 $i2  = - i0 ;
 $i3  = java_lang_Integer_stringSize5_5_(gc_info,  $i2 , exception);
if(*exception != 0) {
 
return 0; }
 $i4  =  $i3  +  1  ;
goto label2;
label1:
 $i4  = java_lang_Integer_stringSize5_5_(gc_info,  i0 , exception);
if(*exception != 0) {
 
return 0; }
label2:
 i1  =  $i4 ;
 r0  = char__array_new(gc_info,  i1 , exception);
java_lang_Integer_getChars0_5_5_a14_(gc_info,  i0 ,  i1 ,  r0 , exception);
if(*exception != 0) {
 
return 0; }
 $r1  =  -1 ;
edu_syr_pcpratts_gc_assign (gc_info, 
&$r1, java_lang_String_initab850b60f96d11de8a390800200c9a660_5_5_a14_(gc_info,
  0 ,
  i1 ,
  r0 , exception));
if(*exception != 0) {
 
return 0; }
return  $r1 ;
  return 0;
}
__device__ int java_lang_Integer_toUnsignedString9_5_5_( char * gc_info, int parameter0, int parameter1, int * exception){
int i0;
int i1;
int r0 = -1;
int i2;
int i3;
int i4;
int $r1 = -1;
int $i5;
char $c6;
int $r2 = -1;
int $i7;
 i0  =  parameter0 ;
 i1  =  parameter1 ;
 r0  = char__array_new(gc_info,  32 , exception);
 i2  =  32 ;
 i3  =  1  <<  i1  ;
 i4  =  i3  -  1  ;
label0:
 i2  =  i2  +  -1  ;
 $r1  = static_getter_java_lang_Integer_digits(gc_info, exception);
 $i5  =  i0  &  i4  ;
 $c6  = char__array_get(gc_info, $r1, $i5, exception);
if(*exception != 0) {
 
return 0; }
char__array_set(gc_info, r0, i2,  $c6 , exception);
if(*exception != 0) {
 
return 0; }
 i0  = ( i0  >>  i1  ) & 0x7fffffff;
if ( i0  !=  0   ) goto label0;
 $r2  =  -1 ;
 $i7  =  32  -  i2  ;
edu_syr_pcpratts_gc_assign (gc_info, 
&$r2, java_lang_String_initab850b60f96d11de8a390800200c9a660_a14_5_5_(gc_info,
  r0 ,
  i2 ,
  $i7 , exception));
if(*exception != 0) {
 
return 0; }
return  $r2 ;
  return 0;
}
__device__ double double__array_get( char * gc_info, int thisref, int parameter0, int * exception){
int offset;
int length;
 char * thisref_deref;
offset = 32+(parameter0*8);
if(thisref == -1){
  *exception = 21352;
  return 0;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
length = edu_syr_pcpratts_getint(thisref_deref, 12);
if(parameter0 < 0 || parameter0 >= length){
  *exception = edu_syr_pcpratts_rootbeer_runtimegpu_GpuException_arrayOutOfBounds(gc_info, parameter0, thisref, length, exception);  return 0;
}
return *(( double *) &thisref_deref[offset]);
}
__device__ void double__array_set( char * gc_info, int thisref, int parameter0, double parameter1, int * exception){
int length;
 char * thisref_deref;
  if(thisref == -1){
    *exception = 21352;
    return;
  }
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
length = edu_syr_pcpratts_getint(thisref_deref, 12);
if(parameter0 < 0 || parameter0 >= length){
  *exception = edu_syr_pcpratts_rootbeer_runtimegpu_GpuException_arrayOutOfBounds(gc_info, parameter0, thisref, length, exception);  return;
}
*(( double *) &thisref_deref[32+(parameter0*8)]) = parameter1;
}
__device__ int double__array_new( char * gc_info, int size, int * exception){
int i;
int total_size;
int mod;
int thisref;
 char * thisref_deref;
total_size = (size * 8)+ 32;
mod = total_size % 8;
if(mod != 0)
  total_size += (8 - mod);
thisref = edu_syr_pcpratts_gc_malloc(gc_info, total_size);
if(thisref == -1){
  *exception = 21352;
  return -1;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
edu_syr_pcpratts_gc_set_count(thisref_deref, 0);
edu_syr_pcpratts_gc_set_color(thisref_deref, COLOR_GREY);
edu_syr_pcpratts_gc_set_type(thisref_deref, 2900);
edu_syr_pcpratts_gc_set_ctor_used(thisref_deref, 1);
edu_syr_pcpratts_gc_set_size(thisref_deref, total_size);
edu_syr_pcpratts_setint(thisref_deref, 12, size);
for(i = 0; i < size; ++i){
  double__array_set(gc_info, thisref, i, 0, exception);
}
return thisref;
}
__device__ double java_lang_Math_abs8_8_( char * gc_info, double parameter0, int * exception){
double d0;
char $b0;
double $d1;
 d0  =  parameter0 ;
 $b0  = edu_syr_pcpratts_cmpg((double) d0 , (double) 0.0 );
if ( $b0  >  0   ) goto label0;
 $d1  =  0.0  -  d0  ;
goto label1;
label0:
 $d1  =  d0 ;
label1:
return  $d1 ;
  return 0;
}
__device__ void at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_assignCenters0_5_a12_( char * gc_info, int thisref, int parameter0, int parameter1, int * exception){
int r0 = -1;
int i0;
int r1 = -1;
int i1;
int $r2 = -1;
int $i2;
int $r3 = -1;
int $r4 = -1;
int $r5 = -1;
int $r6 = -1;
int $i3;
int $r7 = -1;
int $r8 = -1;
double $d0;
double $d1;
double $d2;
int $r9 = -1;
int $i6;
int $i7;
int id;
char * mem;
char * trash;
char * mystery;
int count;
int old;
char * thisref_synch_deref;
if(thisref == -1){
  *exception = 21352;
  return;
}
id = getThreadId();
mem = edu_syr_pcpratts_gc_deref(gc_info, thisref);
trash = edu_syr_pcpratts_gc_deref(gc_info, 0) + 220;
mystery = trash - 8;
mem += 16;
count = 0;
while(count < 100){
  old = atomicCAS((int *) mem, -1 , id);
  *((int *) trash) = old;
  if(old == -1 || old == id){
  if ( thisref ==-1 ) {
 
    * exception = 11;
  }
  if ( * exception != 0 ) {
    edu_syr_pcpratts_exitMonitorMem ( gc_info , mem , old ) ;
    return;
  }
  thisref_synch_deref = edu_syr_pcpratts_gc_deref ( gc_info , thisref );
  * ( ( int * ) & thisref_synch_deref [ 20 ] ) = 20 ;
 r0  =  thisref ;
 i0  =  parameter0 ;
 r1  =  parameter1 ;
 $r2  = instance_getter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_summationCount(gc_info, r0, exception);
if(*exception != 0) {
 
edu_syr_pcpratts_exitMonitorMem(gc_info, mem, old);
return ; }
 $i2  = int__array_get(gc_info, $r2, i0, exception);
if(*exception != 0) {
 
edu_syr_pcpratts_exitMonitorMem(gc_info, mem, old);
return ; }
if ( $i2  !=  -1   ) goto label0;
 $r3  = instance_getter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_newCenters(gc_info, r0, exception);
if(*exception != 0) {
 
edu_syr_pcpratts_exitMonitorMem(gc_info, mem, old);
return ; }
double__array__array_set(gc_info, $r3, i0,  r1 , exception);
if(*exception != 0) {
 
edu_syr_pcpratts_exitMonitorMem(gc_info, mem, old);
return ; }
 $r4  = instance_getter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_summationCount(gc_info, r0, exception);
if(*exception != 0) {
 
edu_syr_pcpratts_exitMonitorMem(gc_info, mem, old);
return ; }
int__array_set(gc_info, $r4, i0,  0 , exception);
if(*exception != 0) {
 
edu_syr_pcpratts_exitMonitorMem(gc_info, mem, old);
return ; }
goto label1;
label0:
 i1  =  0 ;
label3:
 $r5  = instance_getter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_newCenters(gc_info, r0, exception);
if(*exception != 0) {
 
edu_syr_pcpratts_exitMonitorMem(gc_info, mem, old);
return ; }
 $r6  = double__array__array_get(gc_info, $r5, i0, exception);
if(*exception != 0) {
 
edu_syr_pcpratts_exitMonitorMem(gc_info, mem, old);
return ; }
 $i3  = edu_syr_pcpratts_array_length(gc_info,  $r6 );
if ( i1  >=  $i3   ) goto label2;
 $r7  = instance_getter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_newCenters(gc_info, r0, exception);
if(*exception != 0) {
 
edu_syr_pcpratts_exitMonitorMem(gc_info, mem, old);
return ; }
 $r8  = double__array__array_get(gc_info, $r7, i0, exception);
if(*exception != 0) {
 
edu_syr_pcpratts_exitMonitorMem(gc_info, mem, old);
return ; }
 $d0  = double__array_get(gc_info, $r8, i1, exception);
if(*exception != 0) {
 
edu_syr_pcpratts_exitMonitorMem(gc_info, mem, old);
return ; }
 $d1  = double__array_get(gc_info, r1, i1, exception);
if(*exception != 0) {
 
edu_syr_pcpratts_exitMonitorMem(gc_info, mem, old);
return ; }
 $d2  =  $d0  +  $d1  ;
double__array_set(gc_info, $r8, i1,  $d2 , exception);
if(*exception != 0) {
 
edu_syr_pcpratts_exitMonitorMem(gc_info, mem, old);
return ; }
 i1  =  i1  +  1  ;
goto label3;
label2:
 $r9  = instance_getter_at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_m_summationCount(gc_info, r0, exception);
if(*exception != 0) {
 
edu_syr_pcpratts_exitMonitorMem(gc_info, mem, old);
return ; }
 $i6  = int__array_get(gc_info, $r9, i0, exception);
if(*exception != 0) {
 
edu_syr_pcpratts_exitMonitorMem(gc_info, mem, old);
return ; }
 $i7  =  $i6  +  1  ;
int__array_set(gc_info, $r9, i0,  $i7 , exception);
if(*exception != 0) {
 
edu_syr_pcpratts_exitMonitorMem(gc_info, mem, old);
return ; }
label1:
edu_syr_pcpratts_exitMonitorMem(gc_info, mem, old);
return;
  }
 else {
    count++;
    if(count > 50 || (*((int *) mystery)) == 0){
      count = 0;
    }
  }
}
}
__device__ void java_lang_Exception_initab850b60f96d11de8a390800200c9a66_body0_9_( char * gc_info, int thisref, int parameter0, int * exception){
int r0 = -1;
int r1 = -1;
 r0  =  thisref ;
 r1  =  parameter0 ;
java_lang_Throwable_initab850b60f96d11de8a390800200c9a66_body0_9_(gc_info,
 thisref,
  r1 , exception);
return;
}
__device__ char char__array_get( char * gc_info, int thisref, int parameter0, int * exception){
int offset;
int length;
 char * thisref_deref;
offset = 32+(parameter0*4);
if(thisref == -1){
  *exception = 21352;
  return 0;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
length = edu_syr_pcpratts_getint(thisref_deref, 12);
if(parameter0 < 0 || parameter0 >= length){
  *exception = edu_syr_pcpratts_rootbeer_runtimegpu_GpuException_arrayOutOfBounds(gc_info, parameter0, thisref, length, exception);  return 0;
}
return *(( char *) &thisref_deref[offset]);
}
__device__ void char__array_set( char * gc_info, int thisref, int parameter0, char parameter1, int * exception){
int length;
 char * thisref_deref;
  if(thisref == -1){
    *exception = 21352;
    return;
  }
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
length = edu_syr_pcpratts_getint(thisref_deref, 12);
if(parameter0 < 0 || parameter0 >= length){
  *exception = edu_syr_pcpratts_rootbeer_runtimegpu_GpuException_arrayOutOfBounds(gc_info, parameter0, thisref, length, exception);  return;
}
*(( int *) &thisref_deref[32+(parameter0*4)]) = 0;
*(( char *) &thisref_deref[32+(parameter0*4)]) = parameter1;
}
__device__ int char__array_new( char * gc_info, int size, int * exception){
int i;
int total_size;
int mod;
int thisref;
 char * thisref_deref;
total_size = (size * 4)+ 32;
mod = total_size % 8;
if(mod != 0)
  total_size += (8 - mod);
thisref = edu_syr_pcpratts_gc_malloc(gc_info, total_size);
if(thisref == -1){
  *exception = 21352;
  return -1;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
edu_syr_pcpratts_gc_set_count(thisref_deref, 0);
edu_syr_pcpratts_gc_set_color(thisref_deref, COLOR_GREY);
edu_syr_pcpratts_gc_set_type(thisref_deref, 4335);
edu_syr_pcpratts_gc_set_ctor_used(thisref_deref, 1);
edu_syr_pcpratts_gc_set_size(thisref_deref, total_size);
edu_syr_pcpratts_setint(thisref_deref, 12, size);
for(i = 0; i < size; ++i){
  char__array_set(gc_info, thisref, i, 0, exception);
}
return thisref;
}
__device__ int edu_syr_pcpratts_rootbeer_runtime_KeyValuePair_initab850b60f96d11de8a390800200c9a660_13_13_( char * gc_info, int parameter0, int parameter1, int * exception){
int r0 = -1;
int r1 = -1;
int r2 = -1;
int thisref;
 char * thisref_deref;
thisref = -1;
edu_syr_pcpratts_gc_assign(gc_info, &thisref, edu_syr_pcpratts_gc_malloc(gc_info, 48));
if(thisref == -1){
  *exception = 21106;
  return -1;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
edu_syr_pcpratts_gc_set_count(thisref_deref, 2);
edu_syr_pcpratts_gc_set_color(thisref_deref, COLOR_GREY);
edu_syr_pcpratts_gc_set_type(thisref_deref, 3421);
edu_syr_pcpratts_gc_set_ctor_used(thisref_deref, 1);
edu_syr_pcpratts_gc_set_size(thisref_deref, 48);
edu_syr_pcpratts_gc_init_monitor(thisref_deref);
instance_setter_edu_syr_pcpratts_rootbeer_runtime_KeyValuePair_m_key(gc_info, thisref, -1, exception);
instance_setter_edu_syr_pcpratts_rootbeer_runtime_KeyValuePair_m_value(gc_info, thisref, -1, exception);
 r0  =  thisref ;
 r1  =  parameter0 ;
 r2  =  parameter1 ;
instance_setter_edu_syr_pcpratts_rootbeer_runtime_KeyValuePair_m_key(gc_info, r0,  r1 , exception);
if(*exception != 0) {
 
return 0; }
instance_setter_edu_syr_pcpratts_rootbeer_runtime_KeyValuePair_m_value(gc_info, r0,  r2 , exception);
if(*exception != 0) {
 
return 0; }
return r0;
  return 0;
}
__device__ int at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVectorList_initab850b60f96d11de8a390800200c9a660_( char * gc_info, int * exception){
int r0 = -1;
int $r1 = -1;
int thisref;
 char * thisref_deref;
thisref = -1;
edu_syr_pcpratts_gc_assign(gc_info, &thisref, edu_syr_pcpratts_gc_malloc(gc_info, 48));
if(thisref == -1){
  *exception = 21106;
  return -1;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
edu_syr_pcpratts_gc_set_count(thisref_deref, 1);
edu_syr_pcpratts_gc_set_color(thisref_deref, COLOR_GREY);
edu_syr_pcpratts_gc_set_type(thisref_deref, 2911);
edu_syr_pcpratts_gc_set_ctor_used(thisref_deref, 1);
edu_syr_pcpratts_gc_set_size(thisref_deref, 48);
edu_syr_pcpratts_gc_init_monitor(thisref_deref);
instance_setter_at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVectorList_m_values(gc_info, thisref, -1, exception);
instance_setter_at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVectorList_m_index(gc_info, thisref, 0, exception);
 r0  =  thisref ;
 $r1  = at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVector__array_new(gc_info,  8 , exception);
instance_setter_at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVectorList_m_values(gc_info, r0,  $r1 , exception);
if(*exception != 0) {
 
return 0; }
instance_setter_at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVectorList_m_index(gc_info, r0,  0 , exception);
if(*exception != 0) {
 
return 0; }
return r0;
  return 0;
}
__device__ int at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVectorList_getLength5_( char * gc_info, int thisref, int * exception){
int r0 = -1;
int $i0;
 r0  =  thisref ;
 $i0  = instance_getter_at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVectorList_m_index(gc_info, r0, exception);
if(*exception != 0) {
 
return 0; }
return  $i0 ;
  return 0;
}
__device__ int at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVector__array_get( char * gc_info, int thisref, int parameter0, int * exception){
int offset;
int length;
 char * thisref_deref;
offset = 32+(parameter0*4);
if(thisref == -1){
  *exception = 21352;
  return 0;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
length = edu_syr_pcpratts_getint(thisref_deref, 12);
if(parameter0 < 0 || parameter0 >= length){
  *exception = edu_syr_pcpratts_rootbeer_runtimegpu_GpuException_arrayOutOfBounds(gc_info, parameter0, thisref, length, exception);  return 0;
}
return *(( int *) &thisref_deref[offset]);
}
__device__ void at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVector__array_set( char * gc_info, int thisref, int parameter0, int parameter1, int * exception){
int length;
 char * thisref_deref;
  if(thisref == -1){
    *exception = 21352;
    return;
  }
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
length = edu_syr_pcpratts_getint(thisref_deref, 12);
if(parameter0 < 0 || parameter0 >= length){
  *exception = edu_syr_pcpratts_rootbeer_runtimegpu_GpuException_arrayOutOfBounds(gc_info, parameter0, thisref, length, exception);  return;
}
*(( int *) &thisref_deref[32+(parameter0*4)]) = parameter1;
}
__device__ int at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVector__array_new( char * gc_info, int size, int * exception){
int i;
int total_size;
int mod;
int thisref;
 char * thisref_deref;
total_size = (size * 4)+ 32;
mod = total_size % 8;
if(mod != 0)
  total_size += (8 - mod);
thisref = edu_syr_pcpratts_gc_malloc(gc_info, total_size);
if(thisref == -1){
  *exception = 21352;
  return -1;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
edu_syr_pcpratts_gc_set_count(thisref_deref, 0);
edu_syr_pcpratts_gc_set_color(thisref_deref, COLOR_GREY);
edu_syr_pcpratts_gc_set_type(thisref_deref, 11550);
edu_syr_pcpratts_gc_set_ctor_used(thisref_deref, 1);
edu_syr_pcpratts_gc_set_size(thisref_deref, total_size);
edu_syr_pcpratts_setint(thisref_deref, 12, size);
for(i = 0; i < size; ++i){
  at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVector__array_set(gc_info, thisref, i, -1, exception);
}
return thisref;
}
__device__ int double__array__array_get( char * gc_info, int thisref, int parameter0, int * exception){
int offset;
int length;
 char * thisref_deref;
offset = 32+(parameter0*4);
if(thisref == -1){
  *exception = 21352;
  return 0;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
length = edu_syr_pcpratts_getint(thisref_deref, 12);
if(parameter0 < 0 || parameter0 >= length){
  *exception = edu_syr_pcpratts_rootbeer_runtimegpu_GpuException_arrayOutOfBounds(gc_info, parameter0, thisref, length, exception);  return 0;
}
return *(( int *) &thisref_deref[offset]);
}
__device__ void double__array__array_set( char * gc_info, int thisref, int parameter0, int parameter1, int * exception){
int length;
 char * thisref_deref;
  if(thisref == -1){
    *exception = 21352;
    return;
  }
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
length = edu_syr_pcpratts_getint(thisref_deref, 12);
if(parameter0 < 0 || parameter0 >= length){
  *exception = edu_syr_pcpratts_rootbeer_runtimegpu_GpuException_arrayOutOfBounds(gc_info, parameter0, thisref, length, exception);  return;
}
*(( int *) &thisref_deref[32+(parameter0*4)]) = parameter1;
}
__device__ int double__array__array_new_multi_array( char * gc_info, int dim0, int dim1, int * exception){
int total_size = (dim0 * 8) + 32;
int index0;
int aref0;
int index1;
int aref1;
int mod;
int thisref;
 char * thisref_deref;
mod = total_size % 8;
if(mod != 0)
  total_size += (8 - mod);
thisref = edu_syr_pcpratts_gc_malloc(gc_info, total_size);
if(thisref == -1){
  *exception = 21352;
  return -1;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
edu_syr_pcpratts_gc_set_count(thisref_deref, 0);
edu_syr_pcpratts_gc_set_color(thisref_deref, COLOR_GREY);
edu_syr_pcpratts_gc_set_type(thisref_deref, 2894);
edu_syr_pcpratts_gc_set_ctor_used(thisref_deref, 1);
edu_syr_pcpratts_gc_set_size(thisref_deref, total_size);
edu_syr_pcpratts_setint(thisref_deref, 12, dim0);
for(index0 = 0; index0 < dim0; ++index0){
  aref0 = double__array_new(gc_info, dim1, exception);
  double__array__array_set(gc_info, thisref, index0, aref0, exception);
for(index1 = 0; index1 < dim1; ++index1){
  double__array_set(gc_info, aref0, index1, 0, exception);
}
}
return thisref;
}
__device__ void 
java_lang_System_arraycopy( char * gc_info, int src_handle, int srcPos, int dest_handle, int destPos, int length, int * exception){
  int i;
  int src_index;
  int dest_index;
   char * src_deref = edu_syr_pcpratts_gc_deref(gc_info, src_handle);
   char * dest_deref = edu_syr_pcpratts_gc_deref(gc_info, dest_handle);
  
  GC_OBJ_TYPE_TYPE src_type = edu_syr_pcpratts_gc_get_type(src_deref);
  GC_OBJ_TYPE_TYPE dest_type = edu_syr_pcpratts_gc_get_type(dest_deref);
  
  if(srcPos < destPos){
      if(0){
}
      else if(src_type == 4335 && dest_type == 4335){
        for(i = length - 1; i >= 0; --i){
          src_index = srcPos + i;
          dest_index = destPos + i;
        char__array_set(gc_info, dest_handle, dest_index, char__array_get(gc_info, src_handle, src_index, exception), exception);
        }
      }
  }
 else {
      if(0){
}
      else if(src_type == 4335 && dest_type == 4335){
        for(i = length - 1; i >= 0; --i){
          src_index = srcPos + i;
          dest_index = destPos + i;
        char__array_set(gc_info, dest_handle, dest_index, char__array_get(gc_info, src_handle, src_index, exception), exception);
        }
      }
  }
}
__device__ int at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVector_getLength5_( char * gc_info, int thisref, int * exception){
int r0 = -1;
int $i0;
 r0  =  thisref ;
 $i0  = instance_getter_at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVector_m_index(gc_info, r0, exception);
if(*exception != 0) {
 
return 0; }
return  $i0 ;
  return 0;
}
__device__ int invoke_java_lang_StringBuilder_toString9_( char * gc_info, int thisref, int * exception){
 char * thisref_deref;
GC_OBJ_TYPE_TYPE derived_type;
if(thisref == -1){
  *exception = -2;
return -1;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
derived_type = edu_syr_pcpratts_gc_get_type(thisref_deref);
if(0){
}
else if(derived_type == 1){
return java_lang_Object_toString9_(gc_info, thisref, exception);
}
else if(derived_type == 16901){
return java_lang_StringBuilder_toString9_(gc_info, thisref, exception);
}
return -1;
}
__device__ int java_lang_IllegalArgumentException_initab850b60f96d11de8a390800200c9a660_9_( char * gc_info, int parameter0, int * exception){
int r0 = -1;
int r1 = -1;
int thisref;
 char * thisref_deref;
thisref = -1;
edu_syr_pcpratts_gc_assign(gc_info, &thisref, edu_syr_pcpratts_gc_malloc(gc_info, 32));
if(thisref == -1){
  *exception = 21106;
  return -1;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
edu_syr_pcpratts_gc_set_count(thisref_deref, 0);
edu_syr_pcpratts_gc_set_color(thisref_deref, COLOR_GREY);
edu_syr_pcpratts_gc_set_type(thisref_deref, 21377);
edu_syr_pcpratts_gc_set_ctor_used(thisref_deref, 1);
edu_syr_pcpratts_gc_set_size(thisref_deref, 32);
edu_syr_pcpratts_gc_init_monitor(thisref_deref);
instance_setter_java_lang_Throwable_cause(gc_info, thisref, -1, exception);
instance_setter_java_lang_Throwable_detailMessage(gc_info, thisref, -1, exception);
 r0  =  thisref ;
 r1  =  parameter0 ;
java_lang_RuntimeException_initab850b60f96d11de8a390800200c9a66_body0_9_(gc_info,
 thisref,
  r1 , exception);
return r0;
  return 0;
}
__device__ int at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVectorList_get11_5_( char * gc_info, int thisref, int parameter0, int * exception){
int r0 = -1;
int i0;
int $r1 = -1;
int $r2 = -1;
 r0  =  thisref ;
 i0  =  parameter0 ;
 $r1  = instance_getter_at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVectorList_m_values(gc_info, r0, exception);
if(*exception != 0) {
 
return 0; }
 $r2  = at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVector__array_get(gc_info, $r1, i0, exception);
if(*exception != 0) {
 
return 0; }
return  $r2 ;
  return 0;
}
__device__ int java_lang_String_hashCode5_( char * gc_info, int thisref, int * exception){
int r0 = -1;
int i0;
int i1;
int i2;
int r1 = -1;
int i3;
int $i4;
int $i5;
char $c6;
 r0  =  thisref ;
 i0  = instance_getter_java_lang_String_hash(gc_info, r0, exception);
if(*exception != 0) {
 
return 0; }
 i1  = instance_getter_java_lang_String_count(gc_info, r0, exception);
if(*exception != 0) {
 
return 0; }
if ( i0  !=  0   ) goto label0;
if ( i1  <=  0   ) goto label0;
 i2  = instance_getter_java_lang_String_offset(gc_info, r0, exception);
if(*exception != 0) {
 
return 0; }
 r1  = instance_getter_java_lang_String_value(gc_info, r0, exception);
if(*exception != 0) {
 
return 0; }
 i3  =  0 ;
label3:
if ( i3  >=  i1   ) goto label2;
 $i5  =  31  *  i0  ;
 $i4  =  i2 ;
 i2  =  i2  +  1  ;
 $c6  = char__array_get(gc_info, r1, $i4, exception);
if(*exception != 0) {
 
return 0; }
 i0  =  $i5  +  $c6  ;
 i3  =  i3  +  1  ;
goto label3;
label2:
instance_setter_java_lang_String_hash(gc_info, r0,  i0 , exception);
if(*exception != 0) {
 
return 0; }
label0:
return  i0 ;
  return 0;
}
__device__ int edu_syr_pcpratts_rootbeer_runtimegpu_GpuException_arrayOutOfBounds( char * gc_info, int parameter0, int parameter1, int parameter2, int * exception){
int i0;
int i1;
int i2;
int $r0 = -1;
int r1 = -1;
 i0  =  parameter0 ;
 i1  =  parameter1 ;
 i2  =  parameter2 ;
 $r0  =  -1 ;
edu_syr_pcpratts_gc_assign (gc_info, 
&$r0, edu_syr_pcpratts_rootbeer_runtimegpu_GpuException_initab850b60f96d11de8a390800200c9a660_(gc_info, exception));
if(*exception != 0) {
 
return 0; }
 r1  =  $r0 ;
instance_setter_edu_syr_pcpratts_rootbeer_runtimegpu_GpuException_m_arrayLength(gc_info, r1,  i2 , exception);
if(*exception != 0) {
 
return 0; }
instance_setter_edu_syr_pcpratts_rootbeer_runtimegpu_GpuException_m_arrayIndex(gc_info, r1,  i0 , exception);
if(*exception != 0) {
 
return 0; }
instance_setter_edu_syr_pcpratts_rootbeer_runtimegpu_GpuException_m_array(gc_info, r1,  i1 , exception);
if(*exception != 0) {
 
return 0; }
return  r1 ;
  return 0;
}
__device__ int java_lang_String_initab850b60f96d11de8a390800200c9a660_5_5_a14_( char * gc_info, int parameter0, int parameter1, int parameter2, int * exception){
int r0 = -1;
int i0;
int i1;
int r1 = -1;
int thisref;
 char * thisref_deref;
thisref = -1;
edu_syr_pcpratts_gc_assign(gc_info, &thisref, edu_syr_pcpratts_gc_malloc(gc_info, 64));
if(thisref == -1){
  *exception = 21106;
  return -1;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
edu_syr_pcpratts_gc_set_count(thisref_deref, 1);
edu_syr_pcpratts_gc_set_color(thisref_deref, COLOR_GREY);
edu_syr_pcpratts_gc_set_type(thisref_deref, 2905);
edu_syr_pcpratts_gc_set_ctor_used(thisref_deref, 1);
edu_syr_pcpratts_gc_set_size(thisref_deref, 64);
edu_syr_pcpratts_gc_init_monitor(thisref_deref);
instance_setter_java_lang_String_value(gc_info, thisref, -1, exception);
instance_setter_java_lang_String_count(gc_info, thisref, 0, exception);
instance_setter_java_lang_String_hash(gc_info, thisref, 0, exception);
instance_setter_java_lang_String_offset(gc_info, thisref, 0, exception);
 r0  =  thisref ;
 i0  =  parameter0 ;
 i1  =  parameter1 ;
 r1  =  parameter2 ;
instance_setter_java_lang_String_value(gc_info, r0,  r1 , exception);
if(*exception != 0) {
 
return 0; }
instance_setter_java_lang_String_offset(gc_info, r0,  i0 , exception);
if(*exception != 0) {
 
return 0; }
instance_setter_java_lang_String_count(gc_info, r0,  i1 , exception);
if(*exception != 0) {
 
return 0; }
return r0;
  return 0;
}
__device__ double java_lang_Math_sqrt8_8_( char * gc_info, double parameter0, int * exception){
double d0;
double $d1;
 d0  =  parameter0 ;
 $d1  = java_lang_StrictMath_sqrt(gc_info,  d0 , exception);
if(*exception != 0) {
 
return 0; }
return  $d1 ;
  return 0;
}
__device__ int java_util_Arrays_copyOfRangea14_a14_5_5_( char * gc_info, int parameter0, int parameter1, int parameter2, int * exception){
int r0 = -1;
int i0;
int i1;
int i2;
int $r1 = -1;
int r2 = -1;
int $r3 = -1;
int $r4 = -1;
int $r5 = -1;
int $r6 = -1;
int $r7 = -1;
int $i3;
int $i4;
int $i5;
 r0  =  parameter0 ;
 i0  =  parameter1 ;
 i1  =  parameter2 ;
 i2  =  i1  -  i0  ;
if ( i2  >=  0   ) goto label0;
 $r3  =  -1 ;
 $r1  =  -1 ;
edu_syr_pcpratts_gc_assign (gc_info, 
&$r1, java_lang_StringBuilder_initab850b60f96d11de8a390800200c9a660_(gc_info, exception));
if(*exception != 0) {
 
return 0; }
 $r4  = java_lang_StringBuilder_append10_5_(gc_info,
 $r1,
  i0 , exception);
if(*exception != 0) {
 
return 0; }
 $r5  = java_lang_StringBuilder_append10_9_(gc_info,
 $r4,
  edu_syr_pcpratts_string_constant(gc_info, (char *) " > ", exception) , exception);
if(*exception != 0) {
 
return 0; }
 $r6  = java_lang_StringBuilder_append10_5_(gc_info,
 $r5,
  i1 , exception);
if(*exception != 0) {
 
return 0; }
 $r7  = invoke_java_lang_StringBuilder_toString9_(gc_info,
 $r6, exception);
if(*exception != 0) {
 
return 0; }
edu_syr_pcpratts_gc_assign (gc_info, 
&$r3, java_lang_IllegalArgumentException_initab850b60f96d11de8a390800200c9a660_9_(gc_info,
  $r7 , exception));
if(*exception != 0) {
 
return 0; }
 *exception =  $r3 ;
return 0;
label0:
 r2  = char__array_new(gc_info,  i2 , exception);
 $i3  = edu_syr_pcpratts_array_length(gc_info,  r0 );
 $i4  =  $i3  -  i0  ;
 $i5  = java_lang_Math_min5_5_5_(gc_info,  $i4 ,  i2 , exception);
if(*exception != 0) {
 
return 0; }
java_lang_System_arraycopy(gc_info,  r0 ,  i0 ,  r2 ,  0 ,  $i5 , exception);
if(*exception != 0) {
 
return 0; }
return  r2 ;
  return 0;
}
__device__ int java_lang_Object_toString9_( char * gc_info, int thisref, int * exception){
int r0 = -1;
int $r1 = -1;
int $r2 = -1;
int $r3 = -1;
int $r4 = -1;
int $r5 = -1;
int $i0;
int $r6 = -1;
int $r7 = -1;
int $r8 = -1;
 r0  =  thisref ;
 $r1  =  -1 ;
edu_syr_pcpratts_gc_assign (gc_info, 
&$r1, java_lang_StringBuilder_initab850b60f96d11de8a390800200c9a660_(gc_info, exception));
if(*exception != 0) {
 
return 0; }
 $r2  = java_lang_Object_getClass(gc_info,
 r0, exception);
if(*exception != 0) {
 
return 0; }
 $r3  = java_lang_Class_getName(gc_info,
 $r2, exception);
if(*exception != 0) {
 
return 0; }
 $r4  = java_lang_StringBuilder_append10_9_(gc_info,
 $r1,
  $r3 , exception);
if(*exception != 0) {
 
return 0; }
 $r5  = java_lang_StringBuilder_append10_9_(gc_info,
 $r4,
  edu_syr_pcpratts_string_constant(gc_info, (char *) "@", exception) , exception);
if(*exception != 0) {
 
return 0; }
 $i0  = invoke_java_lang_Object_hashCode(gc_info,
 r0, exception);
if(*exception != 0) {
 
return 0; }
 $r6  = java_lang_Integer_toHexString9_5_(gc_info,  $i0 , exception);
if(*exception != 0) {
 
return 0; }
 $r7  = java_lang_StringBuilder_append10_9_(gc_info,
 $r5,
  $r6 , exception);
if(*exception != 0) {
 
return 0; }
 $r8  = invoke_java_lang_StringBuilder_toString9_(gc_info,
 $r7, exception);
if(*exception != 0) {
 
return 0; }
return  $r8 ;
  return 0;
}
__device__ int invoke_java_lang_Object_hashCode( char * gc_info, int thisref, int * exception){
 char * thisref_deref;
GC_OBJ_TYPE_TYPE derived_type;
if(thisref == -1){
  *exception = -2;
return -1;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
derived_type = edu_syr_pcpratts_gc_get_type(thisref_deref);
if(0){
}
else if(derived_type == 1){
return java_lang_Object_hashCode(gc_info, thisref, exception);
}
else if(derived_type == 2905){
return java_lang_String_hashCode5_(gc_info, thisref, exception);
}
return -1;
}
__device__ int edu_syr_pcpratts_rootbeer_runtimegpu_GpuException_initab850b60f96d11de8a390800200c9a660_( char * gc_info, int * exception){
int r0 = -1;
int thisref;
 char * thisref_deref;
thisref = -1;
edu_syr_pcpratts_gc_assign(gc_info, &thisref, edu_syr_pcpratts_gc_malloc(gc_info, 48));
if(thisref == -1){
  *exception = 21106;
  return -1;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
edu_syr_pcpratts_gc_set_count(thisref_deref, 0);
edu_syr_pcpratts_gc_set_color(thisref_deref, COLOR_GREY);
edu_syr_pcpratts_gc_set_type(thisref_deref, 3608);
edu_syr_pcpratts_gc_set_ctor_used(thisref_deref, 1);
edu_syr_pcpratts_gc_set_size(thisref_deref, 48);
edu_syr_pcpratts_gc_init_monitor(thisref_deref);
instance_setter_edu_syr_pcpratts_rootbeer_runtimegpu_GpuException_m_array(gc_info, thisref, 0, exception);
instance_setter_edu_syr_pcpratts_rootbeer_runtimegpu_GpuException_m_arrayIndex(gc_info, thisref, 0, exception);
instance_setter_edu_syr_pcpratts_rootbeer_runtimegpu_GpuException_m_arrayLength(gc_info, thisref, 0, exception);
 r0  =  thisref ;
return r0;
  return 0;
}
__device__ int java_lang_Integer_stringSize5_5_( char * gc_info, int parameter0, int * exception){
int i0;
int i1;
int $r0 = -1;
int $i2;
int $i3;
 i0  =  parameter0 ;
 i1  =  0 ;
label1:
 $r0  = static_getter_java_lang_Integer_sizeTable(gc_info, exception);
 $i2  = int__array_get(gc_info, $r0, i1, exception);
if(*exception != 0) {
 
return 0; }
if ( i0  >  $i2   ) goto label0;
 $i3  =  i1  +  1  ;
return  $i3 ;
label0:
 i1  =  i1  +  1  ;
goto label1;
  return 0;
}
__device__ int java_lang_Integer_toHexString9_5_( char * gc_info, int parameter0, int * exception){
int i0;
int $r0 = -1;
 i0  =  parameter0 ;
 $r0  = java_lang_Integer_toUnsignedString9_5_5_(gc_info,  i0 ,  4 , exception);
if(*exception != 0) {
 
return 0; }
return  $r0 ;
  return 0;
}
__device__ int java_lang_Math_min5_5_5_( char * gc_info, int parameter0, int parameter1, int * exception){
int i0;
int i1;
int $i2;
 i0  =  parameter0 ;
 i1  =  parameter1 ;
if ( i0  >  i1   ) goto label0;
 $i2  =  i0 ;
goto label1;
label0:
 $i2  =  i1 ;
label1:
return  $i2 ;
  return 0;
}
__device__ int java_lang_StringIndexOutOfBoundsException_initab850b60f96d11de8a390800200c9a660_5_( char * gc_info, int parameter0, int * exception){
int r0 = -1;
int i0;
int $r1 = -1;
int $r2 = -1;
int $r3 = -1;
int $r4 = -1;
int thisref;
 char * thisref_deref;
thisref = -1;
edu_syr_pcpratts_gc_assign(gc_info, &thisref, edu_syr_pcpratts_gc_malloc(gc_info, 32));
if(thisref == -1){
  *exception = 21106;
  return -1;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
edu_syr_pcpratts_gc_set_count(thisref_deref, 0);
edu_syr_pcpratts_gc_set_color(thisref_deref, COLOR_GREY);
edu_syr_pcpratts_gc_set_type(thisref_deref, 22978);
edu_syr_pcpratts_gc_set_ctor_used(thisref_deref, 1);
edu_syr_pcpratts_gc_set_size(thisref_deref, 32);
edu_syr_pcpratts_gc_init_monitor(thisref_deref);
instance_setter_java_lang_Throwable_cause(gc_info, thisref, -1, exception);
instance_setter_java_lang_Throwable_detailMessage(gc_info, thisref, -1, exception);
 r0  =  thisref ;
 i0  =  parameter0 ;
 $r1  =  -1 ;
edu_syr_pcpratts_gc_assign (gc_info, 
&$r1, java_lang_StringBuilder_initab850b60f96d11de8a390800200c9a660_(gc_info, exception));
if(*exception != 0) {
 
return 0; }
 $r2  = java_lang_StringBuilder_append10_9_(gc_info,
 $r1,
  edu_syr_pcpratts_string_constant(gc_info, (char *) "String index out of range: ", exception) , exception);
if(*exception != 0) {
 
return 0; }
 $r3  = java_lang_StringBuilder_append10_5_(gc_info,
 $r2,
  i0 , exception);
if(*exception != 0) {
 
return 0; }
 $r4  = invoke_java_lang_StringBuilder_toString9_(gc_info,
 $r3, exception);
if(*exception != 0) {
 
return 0; }
java_lang_IndexOutOfBoundsException_initab850b60f96d11de8a390800200c9a66_body0_9_(gc_info,
 thisref,
  $r4 , exception);
return r0;
  return 0;
}
__device__ void at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVectorList_add0_11_( char * gc_info, int thisref, int parameter0, int * exception){
int r0 = -1;
int r1 = -1;
int r2 = -1;
int i0;
int $r3 = -1;
int $i1;
int $i2;
int $i3;
int $i4;
int $r5 = -1;
int $i5;
int $i6;
int $i7;
int $i8;
int $r6 = -1;
int $r7 = -1;
 r0  =  thisref ;
 r1  =  parameter0 ;
 $r3  = instance_getter_at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVectorList_m_values(gc_info, r0, exception);
if(*exception != 0) {
 
return ; }
 $i1  = instance_getter_at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVectorList_m_index(gc_info, r0, exception);
if(*exception != 0) {
 
return ; }
at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVector__array_set(gc_info, $r3, $i1,  r1 , exception);
if(*exception != 0) {
 
return ; }
 $i2  = instance_getter_at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVectorList_m_index(gc_info, r0, exception);
if(*exception != 0) {
 
return ; }
 $i3  =  $i2  +  1  ;
instance_setter_at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVectorList_m_index(gc_info, r0,  $i3 , exception);
if(*exception != 0) {
 
return ; }
 $i4  = instance_getter_at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVectorList_m_index(gc_info, r0, exception);
if(*exception != 0) {
 
return ; }
 $r5  = instance_getter_at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVectorList_m_values(gc_info, r0, exception);
if(*exception != 0) {
 
return ; }
 $i5  = edu_syr_pcpratts_array_length(gc_info,  $r5 );
if ( $i4  !=  $i5   ) goto label0;
 $i6  = instance_getter_at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVectorList_m_index(gc_info, r0, exception);
if(*exception != 0) {
 
return ; }
 $i7  =  $i6  *  2  ;
 r2  = at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVector__array_new(gc_info,  $i7 , exception);
 i0  =  0 ;
label2:
 $i8  = instance_getter_at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVectorList_m_index(gc_info, r0, exception);
if(*exception != 0) {
 
return ; }
if ( i0  >=  $i8   ) goto label1;
 $r6  = instance_getter_at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVectorList_m_values(gc_info, r0, exception);
if(*exception != 0) {
 
return ; }
 $r7  = at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVector__array_get(gc_info, $r6, i0, exception);
if(*exception != 0) {
 
return ; }
at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVector__array_set(gc_info, r2, i0,  $r7 , exception);
if(*exception != 0) {
 
return ; }
 i0  =  i0  +  1  ;
goto label2;
label1:
instance_setter_at_illecker_hama_hybrid_examples_kmeans_DenseDoubleVectorList_m_values(gc_info, r0,  r2 , exception);
if(*exception != 0) {
 
return ; }
label0:
return;
}
__device__ void java_lang_Throwable_initab850b60f96d11de8a390800200c9a66_body0_9_( char * gc_info, int thisref, int parameter0, int * exception){
int r0 = -1;
int r1 = -1;
 r0  =  thisref ;
 r1  =  parameter0 ;
instance_setter_java_lang_Throwable_cause(gc_info, r0,  r0 , exception);
if(*exception != 0) {
 
return ; }
java_lang_Throwable_fillInStackTrace(gc_info,
 r0, exception);
if(*exception != 0) {
 
return ; }
instance_setter_java_lang_Throwable_detailMessage(gc_info, r0,  r1 , exception);
if(*exception != 0) {
 
return ; }
return;
}
__device__ void java_lang_Integer_getChars0_5_5_a14_( char * gc_info, int parameter0, int parameter1, int parameter2, int * exception){
int i0;
int i1;
int r0 = -1;
int i2;
char c3;
int i4;
int i5;
int $i6;
int $i7;
int $i8;
int $i9;
int $i10;
int i11;
int $r1 = -1;
char $c12;
int $r2 = -1;
char $c13;
int $i14;
int i15;
int $i16;
int $i17;
int $i18;
int i19;
int $r3 = -1;
char $c20;
int i21;
 i0  =  parameter0 ;
 i1  =  parameter1 ;
 r0  =  parameter2 ;
 i2  =  i1 ;
 c3  =  0 ;
if ( i0  >=  0   ) goto label0;
 c3  =  45 ;
 i0  = - i0 ;
label0:
if ( i0  <  65536   ) goto label1;
 i4  =  i0  /  100  ;
 $i6  =  i4  <<  6  ;
 $i7  =  i4  <<  5  ;
 $i8  =  $i6  +  $i7  ;
 $i9  =  i4  <<  2  ;
 $i10  =  $i8  +  $i9  ;
 i5  =  i0  -  $i10  ;
 i0  =  i4 ;
 i11  =  i2  +  -1  ;
 $r1  = static_getter_java_lang_Integer_DigitOnes(gc_info, exception);
 $c12  = char__array_get(gc_info, $r1, i5, exception);
if(*exception != 0) {
 
return ; }
char__array_set(gc_info, r0, i11,  $c12 , exception);
if(*exception != 0) {
 
return ; }
 i2  =  i11  +  -1  ;
 $r2  = static_getter_java_lang_Integer_DigitTens(gc_info, exception);
 $c13  = char__array_get(gc_info, $r2, i5, exception);
if(*exception != 0) {
 
return ; }
char__array_set(gc_info, r0, i2,  $c13 , exception);
if(*exception != 0) {
 
return ; }
goto label0;
label1:
 $i14  =  i0  *  52429  ;
 i15  = ( $i14  >>  19  ) & 0x7fffffff;
 $i16  =  i15  <<  3  ;
 $i17  =  i15  <<  1  ;
 $i18  =  $i16  +  $i17  ;
 i19  =  i0  -  $i18  ;
 i2  =  i2  +  -1  ;
 $r3  = static_getter_java_lang_Integer_digits(gc_info, exception);
 $c20  = char__array_get(gc_info, $r3, i19, exception);
if(*exception != 0) {
 
return ; }
char__array_set(gc_info, r0, i2,  $c20 , exception);
if(*exception != 0) {
 
return ; }
 i0  =  i15 ;
if ( i0  !=  0   ) goto label1;
goto label4;
label4:
if ( c3  ==  0   ) goto label5;
 i21  =  i2  +  -1  ;
char__array_set(gc_info, r0, i21,  c3 , exception);
if(*exception != 0) {
 
return ; }
label5:
return;
}
__device__ int java_lang_String__array_get( char * gc_info, int thisref, int parameter0, int * exception){
int offset;
int length;
 char * thisref_deref;
offset = 32+(parameter0*4);
if(thisref == -1){
  *exception = 21352;
  return 0;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
length = edu_syr_pcpratts_getint(thisref_deref, 12);
if(parameter0 < 0 || parameter0 >= length){
  *exception = edu_syr_pcpratts_rootbeer_runtimegpu_GpuException_arrayOutOfBounds(gc_info, parameter0, thisref, length, exception);  return 0;
}
return *(( int *) &thisref_deref[offset]);
}
__device__ void java_lang_String__array_set( char * gc_info, int thisref, int parameter0, int parameter1, int * exception){
int length;
 char * thisref_deref;
  if(thisref == -1){
    *exception = 21352;
    return;
  }
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
length = edu_syr_pcpratts_getint(thisref_deref, 12);
if(parameter0 < 0 || parameter0 >= length){
  *exception = edu_syr_pcpratts_rootbeer_runtimegpu_GpuException_arrayOutOfBounds(gc_info, parameter0, thisref, length, exception);  return;
}
*(( int *) &thisref_deref[32+(parameter0*4)]) = parameter1;
}
__device__ int java_lang_String__array_new( char * gc_info, int size, int * exception){
int i;
int total_size;
int mod;
int thisref;
 char * thisref_deref;
total_size = (size * 4)+ 32;
mod = total_size % 8;
if(mod != 0)
  total_size += (8 - mod);
thisref = edu_syr_pcpratts_gc_malloc(gc_info, total_size);
if(thisref == -1){
  *exception = 21352;
  return -1;
}
thisref_deref = edu_syr_pcpratts_gc_deref(gc_info, thisref);
edu_syr_pcpratts_gc_set_count(thisref_deref, 0);
edu_syr_pcpratts_gc_set_color(thisref_deref, COLOR_GREY);
edu_syr_pcpratts_gc_set_type(thisref_deref, 2903);
edu_syr_pcpratts_gc_set_ctor_used(thisref_deref, 1);
edu_syr_pcpratts_gc_set_size(thisref_deref, total_size);
edu_syr_pcpratts_setint(thisref_deref, 12, size);
for(i = 0; i < size; ++i){
  java_lang_String__array_set(gc_info, thisref, i, -1, exception);
}
return thisref;
}
__device__ int
edu_syr_pcpratts_classConstant(int type_num){
  int * temp = (int *) m_Local[2];   
  return temp[type_num];
}
__device__  char *
edu_syr_pcpratts_gc_deref(char * gc_info, int handle){
  char * data_arr = (char * ) m_Local[0];
  long long lhandle = handle;
  lhandle = lhandle << 4;
  return &data_arr[lhandle];
}
__device__ int
edu_syr_pcpratts_gc_malloc(char * gc_info, int size){
  unsigned long long space_size = m_Local[1];
  unsigned long long ret = edu_syr_pcpratts_gc_malloc_no_fail(gc_info, size);
  unsigned long long end = ret + size + 8L;
  if(end >= space_size){
    return -1;
  }
  return (int) (ret >> 4);
}
__device__ unsigned long long
edu_syr_pcpratts_gc_malloc_no_fail(char * gc_info, int size){
  unsigned long long * addr = (unsigned long long *) (gc_info + TO_SPACE_FREE_POINTER_OFFSET);
  if(size % 16 != 0){
    size += (16 - (size %16));
  }
  unsigned long long ret;
  ret = atomicAdd(addr, size);
  return ret;
}
__device__  void
edu_syr_pcpratts_gc_init(char * to_space, size_t space_size, int * java_lang_class_refs){
  if(threadIdx.x == 0){
    m_Local[0] = (size_t) to_space;
    m_Local[1] = (size_t) space_size;
    m_Local[2] = (size_t) java_lang_class_refs;
  }
}
__global__ void entry(char * gc_info, char * to_space, int * handles, 
  long long * to_space_free_ptr, long long * space_size, int * exceptions,
  int * java_lang_class_refs, HostDeviceInterface * h_d_interface,
  int num_blocks) {
  
  host_device_interface = h_d_interface;
  
  
  edu_syr_pcpratts_gc_init(to_space, *space_size, java_lang_class_refs);
  __syncthreads();
  int loop_control = blockIdx.x * blockDim.x + threadIdx.x;
  if(loop_control >= num_blocks){
  
    return;
  }
 else {
    int handle = handles[loop_control];
    int exception = 0;   
    at_illecker_hama_hybrid_examples_kmeans_KMeansHybridKernelOld_gpuMethod0_(gc_info, handle, &exception);
    exceptions[loop_control] = exception;
  
    unsigned long long * addr = ( unsigned long long * ) (gc_info + TO_SPACE_FREE_POINTER_OFFSET);
    *to_space_free_ptr = *addr;
  }
}

