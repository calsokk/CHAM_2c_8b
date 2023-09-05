#ifndef MVP_PUBLIC_F3_MVP_FPGA_LIB_H
#define MVP_PUBLIC_F3_MVP_FPGA_LIB_H
#include <errno.h>
#include <fcntl.h>
#include <pthread.h>
#include <semaphore.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>
#include <sys/mman.h>

#include "mvp_public/util/common.h"
#include "mvp_public/F3/mvp_fpga_reg.h"

#define NUM_KERNEL      1                            // number of kernel in one device
#define DMA_SIZE_MIN    1                            // lower limit of dma size
#define BUFFER_SIZE     1024
#define NUM_TASK        1000                           // Task numbers

#define RESULTS_VERIFY  1                            // 1 represents open results verification, 0 represents close

enum mvp_fpga_compute_result {success = 0, err_level = 1,err_col_size = 2, err_split = 4, err_index = 8, err_mat_len = 16};

#define pcie_resource_path "/sys/bus/pci/devices/0000:00:08.0/resource"
typedef struct f3_config_st {
  int board_id = -1;
  uint32_t bar_num;
  uint64_t bar_start;
  uint64_t bar_end;
  uint64_t bar_size;
} f3_config_t[1];

int obtain_fpga_dev_name(f3_config_t config) {
    ssize_t buf_size = 0;
    char *bar_str = NULL;
    FILE * fp_res = fopen(pcie_resource_path, "r");

    config->bar_num = 0;
    if ( fp_res == NULL) {
        printf("Open %s fail.\n", pcie_resource_path);
        return (-1);
    }
    for(uint32_t i = 0; i <= config->bar_num; i++) {
        getline(&bar_str, (size_t*)&buf_size, fp_res);
    }
    sscanf(bar_str, "0x%lx 0x%lx", &(config->bar_start), &(config->bar_end));
    config->bar_size = config->bar_end - config->bar_start + 1;
    if((config->bar_start == 0) && (config->bar_end == 0)) {
        printf("The device do not have Bar %d\n",  config->bar_num);
        exit(1);
    }
    free(bar_str);
    // printf("fpga_reg_read bar_start=0x%lx, bar_end=%lx, bar_size=%lx\n", bar_start, bar_end, bar_size);
    fclose(fp_res);
    return 0;
}

int fpga_memory_operate(void *buffer,
                        uint64_t addr, int size, int opcode) {
  int ret, fpga_fd;
  if (opcode == 0) {
      // printf("open %s addr=0x%x, size=0x%x \n", FPGA_XDMA_DDR1_WRITE_DEV_NAME, addr, size);
      ret = open(FPGA_XDMA_DDR1_WRITE_DEV_NAME, O_RDWR);
  } else {
      // printf("open %s addr=0x%x, size=0x%x \n", FPGA_XDMA_DDR1_READ_DEV_NAME, addr, size);
      ret = open(FPGA_XDMA_DDR1_READ_DEV_NAME, O_RDWR);
  }

  if (ret < 0) {
    GM_LOG_ERROR("[ ERR ] open %s error! (%s)", "DUMMY DEVICE",
           strerror(errno));
    fflush(stdout);
    return ret;
  }
  fpga_fd = ret;
  ssize_t ret_value;

  if (opcode == 0) {
    ret_value = pwrite(fpga_fd, buffer, size, addr);
  } else {
    ret_value = pread(fpga_fd, buffer, size, addr);
  }
  if (size != ret_value) {
    printf("[ ERR ] error! (expected %d, need %ld)\n", size, ret_value);
    close(fpga_fd);
    return -1;
  }
  // if (opcode == 0)
  //   printf("close %s addr=0x%x, size=0x%x \n", FPGA_XDMA_DDR1_WRITE_DEV_NAME, addr, size);
  // else
  //   printf("close %s addr=0x%x, size=0x%x \n", FPGA_XDMA_DDR1_READ_DEV_NAME, addr, size);

  close(fpga_fd);
  return 0;
}

int fpga_reg_read(f3_config_t config, uint64_t offset, uint32_t *value) {
    void * map_base, *ops_vaddr;
    int fd_mem;

    if ((fd_mem = open("/dev/mem", O_RDWR|O_SYNC)) == -1) {
        printf("Open %s fail.\n", "/dev/mem");
        return (-1);
    }

    map_base = mmap(NULL, config->bar_size, PROT_READ, MAP_SHARED, fd_mem, config->bar_start);
    if (map_base == (void *) -1) {
        printf("mmap %s fail.\n", "/dev/mem");
        return (-1);
    }
    ops_vaddr = map_base + offset;
    *value = *(uint32_t *)ops_vaddr;
    // printf("Read offset=0x%lx, Value=0x%x\n", offset, *value);

    if (munmap(map_base, config->bar_size) == -1) {
        printf("unmap %s fail.\n", "/dev/mem");
        return (-1);
    }
    close(fd_mem);

    return 0;
}

int fpga_reg_write_array(f3_config_t config, std::vector<uint64_t> offset_array, std::vector<uint32_t> value_array) {
    void * map_base, *ops_vaddr;
    int fd_mem;

    if ((fd_mem = open("/dev/mem", O_RDWR|O_SYNC)) == -1) {
        printf("Open %s fail.\n", "/dev/mem");
        return (-1);
    }

    map_base = mmap(NULL, config->bar_size, PROT_WRITE, MAP_SHARED, fd_mem, config->bar_start);
    if (map_base == (void *) -1) {
        printf("mmap %s fail.\n", "/dev/mem");
        return (-1);
    }
    for (long unsigned int i=0; i<offset_array.size(); i++) {
      ops_vaddr = map_base + offset_array[i];
      *((uint32_t *) ops_vaddr) = value_array[i];
    }

    // printf("WriteValue=0x%x\n", *((uint32_t *) (ops_vaddr)));

    if (munmap(map_base, config->bar_size) == -1) {
        printf("unmap %s fail.\n", "/dev/mem");
        return (-1);
    }
    close(fd_mem);

    return 0;
}

int fpga_reg_write(f3_config_t config, uint64_t offset, uint32_t value) {
    void * map_base, *ops_vaddr;
    int fd_mem;

    if ((fd_mem = open("/dev/mem", O_RDWR|O_SYNC)) == -1) {
        printf("Open %s fail.\n", "/dev/mem");
        return (-1);
    }

    map_base = mmap(NULL, config->bar_size, PROT_WRITE, MAP_SHARED, fd_mem, config->bar_start);
    if (map_base == (void *) -1) {
        printf("mmap %s fail.\n", "/dev/mem");
        return (-1);
    }
    ops_vaddr = map_base + offset;
    *((uint32_t *) ops_vaddr) = value;
    // printf("WriteValue=0x%x\n", *((uint32_t *) (ops_vaddr)));

    if (munmap(map_base, config->bar_size) == -1) {
        printf("unmap %s fail.\n", "/dev/mem");
        return (-1);
    }
    close(fd_mem);

    return 0;
}

int KernelInit(unsigned long *h_ksk[], int ksk_length, int chuck_size) {
    //create FaaSRuntime
  sem_t *fpga_mutex = NULL;
  fpga_mutex = sem_open("mvp_fpga", O_CREAT | O_RDWR, 0666, 1);
  sem_wait(fpga_mutex);
  std::vector<uint64_t> reg_offset_arr;
  std::vector<uint32_t> reg_val_arr;
  reg_offset_arr.clear();
  reg_val_arr.clear();

  f3_config_t dev_config;
  if (0 != obtain_fpga_dev_name(dev_config)) {
    return -1;
  }

  {
    int ksk_index;
    for (ksk_index = 0; ksk_index < ksk_length; ksk_index++) {
      // printf("Value of h_ksk[%d] = %p\n", ksk_index, h_ksk[ksk_index]);
      fpga_memory_operate(h_ksk[ksk_index], KSK_DEV_BASE_ADDR + chuck_size * ksk_index, chuck_size, 0);
    }

    reg_offset_arr.push_back((uint64_t)(MVP_REG_OFFSET + MVP_PROCESS_START_OFFSET)); reg_val_arr.push_back((uint32_t)0x00000000);
    reg_offset_arr.push_back((uint64_t)(MVP_REG_OFFSET + MVP_COMMAND_OFFSET)); reg_val_arr.push_back((uint32_t)0x00000000);
    reg_offset_arr.push_back((uint64_t)(MVP_REG_OFFSET + MVP_KSK_DEV_MEM_LOW_OFFSET)); reg_val_arr.push_back((uint32_t)KSK_DEV_BASE_ADDR);
    reg_offset_arr.push_back((uint64_t)(MVP_REG_OFFSET + MVP_KSK_DEV_MEM_HIGH_OFFSET)); reg_val_arr.push_back((uint32_t)0x00000000);
    reg_offset_arr.push_back((uint64_t)(MVP_REG_OFFSET + MVP_PROCESS_START_OFFSET)); reg_val_arr.push_back((uint32_t)0x00000001);

    fpga_reg_write_array(dev_config, reg_offset_arr, reg_val_arr);
    uint32_t data_u32;
    int trycount;
    for (trycount = 0; trycount < 100000; trycount++) {
      fpga_reg_read(dev_config, (MVP_REG_OFFSET + MVP_OUTPUT_DATA_READY_OFFSET), &data_u32);
      // printf("read val=%d", data_u32);
      if (data_u32 % 2) {
        // printf("ksk final read val=%d\n", data_u32);
        break;
      }
    }
  }
  sem_post(fpga_mutex);
  sem_close(fpga_mutex);

  return 0;
}


/*****************************************************************
 * This function migrates polynomials and runs MVP
 * h_vec_data & h_mat_data & h_result must be 4KB align :
 *posix_memalign(X,4096,size) vec_chuck_size = 0x18000 (96k) , mat_chuck_size =
 *0x30000 (192k)
 *****************************************************************/
int KernelRun(unsigned int n, unsigned int m, unsigned long *h_vec_data[],
              int vec_length, int vec_chuck_size, unsigned long *h_mat_data[],
              int mat_length, int mat_chuck_size, long unsigned int *h_result) {
  sem_t *fpga_mutex = NULL;
  sem_t *fpga_buffer_mutex = NULL;
  sem_t *double_buffer_select = NULL;

  int buffer_index;

  // output size = 128 KB
  int outputsize = 0x20000;

  // First Input Slot : 0x10000000 ~ 0x80000000
  // Second Input Slot : 0x80000000 ~ 0xf0000000
  // 1.75GB Per Slot
  unsigned int input_addr = FIRST_INPUT_DATA_DEV_BASE_ADDR;

  // First Output Slot : 0xF0000000 ~ 0xF1000000
  // Second Output Slot : 0xF1000000 ~ 0xF2000000
  // 16MB Per Slot
  unsigned int output_addr = FIRST_OUTPUT_DATA_DEV_BASE_ADDR;

  f3_config_t dev_config;
  if (0 != obtain_fpga_dev_name(dev_config)) {
    return -1;
  }

  fpga_mutex = sem_open("mvp_fpga", O_CREAT | O_RDWR, 0666, 1);
  fpga_buffer_mutex = sem_open("mvp_fpga_buffer", O_CREAT | O_RDWR, 0666, 2);
  double_buffer_select = sem_open("mvp_fpga_index", O_CREAT | O_RDWR, 0666, 1);
  int status = 0;
  sem_wait(fpga_buffer_mutex);
  {
    if (sem_trywait(double_buffer_select) == 0) {
      buffer_index = 0;
    } else {
      buffer_index = 1;
    }
    if (buffer_index == 0) {
      input_addr = SECOND_INPUT_DATA_DEV_BASE_ADDR;
      output_addr = SECOND_OUTPUT_DATA_DEV_BASE_ADDR;
    }

    auto start = std::chrono::steady_clock::now();
    // Upload Vec
    int vec_input_index;
    for (vec_input_index = 0; vec_input_index < vec_length; vec_input_index++) {
      // printf("[ Start Upload Vec Input ] %d\n", vec_input_index);
      fpga_memory_operate(h_vec_data[vec_input_index],
                          input_addr + vec_chuck_size * vec_input_index,
                          vec_chuck_size, 0);
    }

    // Upload Mat After Vec on Device Memory
    int mat_addr_offset;
    mat_addr_offset = vec_chuck_size * vec_length;
    int mat_input_index;
    for (mat_input_index = 0; mat_input_index < mat_length; mat_input_index++) {
      // printf("[ Start Upload Mat Input ] %d\n", mat_input_index);
      fpga_memory_operate(h_mat_data[mat_input_index],
          input_addr + mat_addr_offset + mat_chuck_size * mat_input_index,
          mat_chuck_size, 0);
    }
    auto end = std::chrono::steady_clock::now();
    unsigned long time_data_copy = std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count();
    printf("kernel time_data_copy = %ldms\n", time_data_copy);

    // calc input args
    unsigned int level = log2(n);
    unsigned int col_size = m;
    unsigned int n_split = ceil(m / 4096.0);
    unsigned int n_index = 1;
    if (m < 4096) {
      n_split = 1;
      unsigned int tmp = log2(4096 / m);
      n_index = pow(2, tmp);
    }
    unsigned int mat_len = n * n_split / n_index;
    sem_wait(fpga_mutex);
    {
      std::vector<uint64_t> reg_offset_arr;
      std::vector<uint32_t> reg_val_arr;
      reg_offset_arr.clear();
      reg_val_arr.clear();
      reg_offset_arr.push_back((uint64_t)(MVP_REG_OFFSET + MVP_PROCESS_START_OFFSET)); reg_val_arr.push_back((uint32_t)0x00000000);
      reg_offset_arr.push_back((uint64_t)(MVP_REG_OFFSET + MVP_COMMAND_OFFSET)); reg_val_arr.push_back((uint32_t)0x00000001);
      reg_offset_arr.push_back((uint64_t)(MVP_REG_OFFSET + MVP_LEVEL_OFFSET)); reg_val_arr.push_back((uint32_t)level);
      reg_offset_arr.push_back((uint64_t)(MVP_REG_OFFSET + MVP_COL_SIZE_OFFSET)); reg_val_arr.push_back((uint32_t)col_size);
      reg_offset_arr.push_back((uint64_t)(MVP_REG_OFFSET + MVP_N_SPLIT_OFFSET)); reg_val_arr.push_back((uint32_t)n_split);
      reg_offset_arr.push_back((uint64_t)(MVP_REG_OFFSET + MVP_N_INDEX_OFFSET)); reg_val_arr.push_back((uint32_t)n_index);
      reg_offset_arr.push_back((uint64_t)(MVP_REG_OFFSET + MVP_H_MAT_LEN_OFFSET)); reg_val_arr.push_back((uint32_t)mat_len);
      reg_offset_arr.push_back((uint64_t)(MVP_REG_OFFSET + MVP_H_VEC_DATA_MEM_LOW_OFFSET)); reg_val_arr.push_back((uint32_t)input_addr);
      reg_offset_arr.push_back((uint64_t)(MVP_REG_OFFSET + MVP_H_VEC_DATA_MEM_HIGH_OFFSET)); reg_val_arr.push_back((uint32_t)0x00000000);
      reg_offset_arr.push_back((uint64_t)(MVP_REG_OFFSET + MVP_OUTPUT_DATA_MEM_LOW_OFFSET)); reg_val_arr.push_back((uint32_t)output_addr);
      reg_offset_arr.push_back((uint64_t)(MVP_REG_OFFSET + MVP_OUTPUT_DATA_MEM_HIGH_OFFSET)); reg_val_arr.push_back((uint32_t)0x00000000);
      // Start
      reg_offset_arr.push_back((uint64_t)(MVP_REG_OFFSET + MVP_PROCESS_START_OFFSET)); reg_val_arr.push_back((uint32_t)0x00000001);
      fpga_reg_write_array(dev_config, reg_offset_arr, reg_val_arr);

      start = std::chrono::steady_clock::now();
      unsigned int data_u32;
      int trycount;
      for (trycount = 0; trycount < 10000000; trycount++) {
        fpga_reg_read(dev_config, (MVP_REG_OFFSET + MVP_OUTPUT_DATA_READY_OFFSET), &data_u32);
        if (data_u32 % 2) {
          // printf("runtime final read val=%d\n", data_u32);
          status = data_u32;
          break;
        }
      }
      end = std::chrono::steady_clock::now();
      unsigned long time_data_compute = std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count();
      printf("kernel time_data_compute = %ldms\n", time_data_compute);
    }
    sem_post(fpga_mutex);
    fpga_memory_operate(h_result, output_addr, outputsize, 1);

  }
  sem_post(fpga_buffer_mutex);
  if (buffer_index == 0) {
    sem_post(double_buffer_select);
  }
  sem_close(double_buffer_select);
  sem_close(fpga_buffer_mutex);
  sem_close(fpga_mutex);

  if (status > 1){
    return status >> 8; // mvp_fpga_compute_result
  }

  return (0);
}

#endif  // MVP_PUBLIC_F3_MVP_FPGA_LIB_H
