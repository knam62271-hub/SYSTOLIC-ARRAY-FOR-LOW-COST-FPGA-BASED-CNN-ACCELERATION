# SYSTOLIC-ARRAY-FOR-LOW-COST-FPGA-BASED-CNN-ACCELERATION
**- Overview of Systolic Array Architecture and FPGA Implementation Optimization Techniques**

**List of technical topics**

## Table of Contents
- [architecture_overview](#architecture_overview)
- [processing_element_design](#processing_element_design)
- [frequency_layout_optimization](#frequency_layout_optimization)
- [design_space_exploration_tools](#design_space_exploration_tools)
- [flexibility_scalability](#flexibility_scalability)
- [system_performance](#system_performance)
- [conclusion](#conclusion)

---

## architecture_overview

Description: A grid of locally-connected Processing Elements (PEs) in which data flows rhythmically across the array on every clock cycle.

| Attribute | Value | Note |
|---|---|---|
| Structure | Regular 2D grid | Local connections between PEs |
| Data reuse | Very high | Reduces memory bandwidth |
| Parallelism | High | Increases throughput |
| Flagship application | Google TPU | Core architecture |
| Performance vs. CPU/GPU | 15X–30X faster | Compared at the same era |
| Energy efficiency | 30X–80X higher | Compared to CPU/GPU |

---

## processing_element_design

Reference: `PE core / MAC unit`

| Technique | Approach | Effect |
|---|---|---|
| bit_level_mac | Uses AND gates, counters, and shifters instead of a traditional multiplier | Reduces energy 99x, reduces DSP usage, increases PE throughput 15x |
| lut_based_arch | Uses LUTs to skip intermediate computation steps, retrieving results directly from a bit-level matrix | Significantly reduces latency |
| dsp_dynamic_config | Integrates the ReLU activation function directly into the DSP slice | Saves LUT resources (Transformer accelerator) |

---

## frequency_layout_optimization

Challenge: CAD tools often distort the regular array structure, resulting in low operating frequency.

| Solution | Description | Result |
|---|---|---|
| front_end_segmentation | Splits overly long DSP accumulation chains | Shortens the combinational data path |
| back_end_floorplanning | Manual placement + XDC constraint files to fix PE locations | Increases frequency by 1.29x, reaching 588 MHz |
| dsp_direct_instantiation | Directly instantiates DSP macros instead of relying on automatic synthesis | Precise datapath control, maximizes performance |

---

## design_space_exploration_tools

| Tool | Function | Effect |
|---|---|---|
| AFHRE | Predicts hardware resources (DSP, BRAM, LUT, FF) | 40X–610X faster than Vivado HLS |
| Systimator | Analysis tool for low-cost FPGAs (e.g. Artix 7), supports Feature Map reuse & Filter reuse | Finds the array configuration that best fits memory constraints |

---

## flexibility_scalability

| Architecture | Characteristics | Application |
|---|---|---|
| Systolic-CNN | OpenCL-based, 1-D Systolic Array, run-time reconfigurable, time-shared | AlexNet, ResNet, YOLO (no kernel recompilation needed) |
| Transformer Accelerator | Performs matrix multiplication/addition, transpose, and ReLU concurrently | Handles MHA (Multi-Head Attention) and FFN blocks |

---

## system_performance

| Metric | Description | Result |
|---|---|---|
| TPU_latency_priority | Prioritizes latency over average throughput | Meets end-user response requirements |
| int8_vs_float | Uses 8-bit integers instead of floating point | Saves 6x energy, 6x area |
| memory_bound | CNN performance is usually limited by external memory bandwidth | Rather than the array's compute capability |

---

## conclusion

The combination of innovative PE architectures, smart physical placement methods, and fast estimation tools is turning the Systolic Array into a standard solution for deploying complex AI models on both resource-constrained edge devices and large-scale data centers.

**References:**
- Frequency Improvement of Systolic Array-Based CNNs on FPGAs
- High-Frequency Systolic Array-Based Transformer Accelerator
- Systolic_CNN: An OpenCL-defined Scalable Run-time-flexible Architecture
