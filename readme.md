# OXZD Custom Wrapper for HiveOS

This setup uses the **OXZD Miner**, configured via the Custom User Config to write the correct`oxzd_config.json` file for OXZD, to define the primary mining algorithm and optional idle algorithms for both GPU and CPU.

---

# Architecture Versions Explained

OXZD provides multiple optimized builds for different **CPU architectures**.  
Choosing the correct version ensures **maximum performance** and **compatibility** with your hardware.

---

## Available Builds


| File Name | Architecture | GPU Support | CPU Generation | Description | Example CPUs |
|------------|---------------|--------------|----------------|--------------|---------------|
| **`oxzd_HiveOS_x86_64_latest.tar.gz`** | Generic x86-64 | ✅ CUDA (GPU+ CPU) | All 64-bit CPUs | Universal build — compatible with any 64-bit Intel or AMD processor. Recommended if unsure which version to choose. | Intel i5-8600K, AMD FX-8350, Xeon E5-2680 |
| **`oxzd_HiveOS_x86_64_c_latest.tar.gz`** | Generic x86-64 | ❌ CPU-only | All 64-bit CPUs | Same as above but **without CUDA support**. Best for **CPU-only mining rigs** or HiveOS setups without GPUs. | Intel i3-6100, AMD Ryzen 3 1200 |
| **`oxzd_HiveOS_znver2_latest.tar.gz`** | AMD Zen 2 | ✅ CUDA (GPU + CPU) | Ryzen 3000 Series / EPYC 7002 | Optimized for **Ryzen 3000**, **Threadripper 3000**, and **EPYC 7002** CPUs. Includes AVX2 and Zen 2 instruction tuning. | Ryzen 9 3950X, Ryzen 5 3600, EPYC 7702P |
| **`oxzd_HiveOS_znver2_c_latest.tar.gz`** | AMD Zen 2 | ❌ CPU-only | Ryzen 3000 Series / EPYC 7002 | Same as above but **CPU-only** (no CUDA). Smaller file size and lighter build. | Ryzen 7 3700X, Ryzen 9 3900XT |
| **`oxzd_HiveOS_znver4_latest.tar.gz`** | AMD Zen 4 | ✅ CUDA (GPU + CPU) | Ryzen 7000 Series / EPYC 9004 | Optimized for **Ryzen 7000**, **Threadripper 7000**, and **EPYC 9004** CPUs. Includes AVX-512 support and Zen 4 tuning. | Ryzen 9 7950X, Ryzen 7 7800X3D, EPYC 9654 |
| **`oxzd_HiveOS_znver4_c_latest.tar.gz`** | AMD Zen 4 | ❌ CPU-only | Ryzen 7000 Series / EPYC 9004 | CPU-only build — no CUDA. Ideal for mining only on CPU cores. | Ryzen 9 7900, Ryzen 5 7600 |

---

---

## Configuration

All settings are defined in the HiveOS Custom User Config.  

---

### Example Custom User Config

```json
{
  "main_algo_gpu": "neptune",
  "main_algo_cpu": "neptune",
  "gpu_idle_command": "/hive/miners/XDminer--algo XD --pool poolhub.io:3111 --wallet 75LEzrt2vH27WqidfHgNSbhSjw5Ev4AH27MLZ.$(hostname)",
  "cpu_idle_command": "/hive/miners/XDminer--algo XD --pool poolhub.io:3111 --wallet 75LEzrt2vH27WqidfHgNSbhSjw5Ev4AH27MLZ.$(hostname)",
  "npt_address": "YOUR_NEPTUNE_ADDRESS",
  "npt_url": "stratum+ssl://eu.poolhub.io:4444"
  "worker_name": "HiveOS_Rig_01"
}
```

---

## Required Fields

| Field | Description | Values |
|-------|--------------|--------|
| `main_algo_gpu` | Primary algorithm for GPU (what you want to mine). | `"neptune"` or `""` |
| `main_algo_cpu` | Primary algorithm for CPU (what you want to mine). | `"neptune"`, `"xelis"` or `""` |
| `npt_address` | Your Neptune (NPT) wallet address. Required if `main_algo_gpu` or `main_algo_cpu` is set to `neptune`. | Any valid NPT address |
| `xelis_address` | Your Xelis wallet address. Required if `main_algo_cpu` is set to `xelis`. | Any valid Xelis address |

> **Important:**  
> At least one of the primary algorithms (`main_algo_gpu` or `main_algo_cpu`) must be set.

---

## Idle Algorithms (Optional)

These algorithms run when the primary algorithm is idle or has no tasks.

| Field | Description | Values |
|--------|--------------|--------|
| `gpu_idle_command` | Idle algorithm for GPU. | 
| `cpu_idle_command` | Idle algorithm for CPU. | 
| `worker_name` | (Optional) Your rig name in the pool. Defaults to the HiveOS hostname. | Any string |

---

## Advanced Pool Settings (Optional)

If you wish to use custom pools, you can define the following fields:

| Field | Description | Default |
|--------|--------------|----------|
| `npt_url` | Neptune pool URL | `stratum+ssl://eu.poolhub.io:4444` |
| `xelis_url` | Xelis pool URL | `` |
| `tari_url` | Tari pool URL | `` |

---

## Notes

- Ensure the HiveOS Custom User Config is properly formatted.
- Empty fields should be represented as empty strings (`""`), not `null`.
- Restart the miner after making configuration changes.

---

## Example Setup

If you want to mine **Neptune** on GPU and **XD** on idle:

```json
{
  "main_algo_gpu": "neptune",
  "npt_address": "nolgam1cplzv...",
  "gpu_idle_command": "/hive/miners/XDminer--algo XD --pool poolhub.io:3111 --wallet 75LEzrt2vH27WqidfHgNSbhSjw5Ev4AH27MLZ.$(hostname)",
}
```

This will:
- Use Neptune for GPU mining.
- Switch to Qubic automatically when no Neptune jobs are available.


## Support

For setup guides, troubleshooting, and community support, visit:  
👉 [https://discord.poolhub.io](https://discord.poolhub.io)
