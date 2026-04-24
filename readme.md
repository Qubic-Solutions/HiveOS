# OXZD Custom Wrapper for HiveOS

This setup uses the **OXZD Miner**, configured via the Custom User Config to write the correct `oxzd_config.json` file for OXZD, to define the primary mining algorithm and optional idle command for GPU or CPU.

---

# Architecture Versions Explained

OXZD provides multiple optimized builds for different **CPU architectures**.  
Choosing the correct version ensures **maximum performance** and **compatibility** with your hardware.

---

## Available Builds

| File Name | Version | Architecture | GPU Support | CPU Generation | Description | Example CPUs |
|------------|---------|---------------|--------------|----------------|--------------|---------------|
| **`oxzd_HiveOS_x86_64_latest.tar.gz`** | 0.8.1 | Generic x86-64 | ✅ CUDA (GPU + CPU) | All 64-bit CPUs | Universal build — compatible with any 64-bit Intel or AMD processor. Recommended if unsure which version to choose. | Intel i5-8600K, AMD FX-8350, Xeon E5-2680 |
| **`oxzd_HiveOS_x86_64_c_latest.tar.gz`** | 0.7.5 | Generic x86-64 | ❌ CPU-only | All 64-bit CPUs | Without CUDA support. Best for **CPU-only mining rigs** or HiveOS setups without GPUs. | Intel i3-6100, AMD Ryzen 3 1200 |
| **`oxzd_HiveOS_znver2_latest.tar.gz`** | 0.8.1 | AMD Zen 2 | ✅ CUDA (GPU + CPU) | Ryzen 3000 Series / EPYC 7002 | Optimized for **Ryzen 3000**, **Threadripper 3000**, and **EPYC 7002** CPUs. Includes AVX2 and Zen 2 instruction tuning. | Ryzen 9 3950X, Ryzen 5 3600, EPYC 7702P |
| **`oxzd_HiveOS_znver2_c_latest.tar.gz`** | 0.7.5 | AMD Zen 2 | ❌ CPU-only | Ryzen 3000 Series / EPYC 7002 | CPU-only (no CUDA). Smaller file size and lighter build. | Ryzen 7 3700X, Ryzen 9 3900XT |
| **`oxzd_HiveOS_znver4_latest.tar.gz`** | 0.8.1 | AMD Zen 4 | ✅ CUDA (GPU + CPU) | Ryzen 7000 Series / EPYC 9004 | Optimized for **Ryzen 7000**, **Threadripper 7000**, and **EPYC 9004** CPUs. Includes AVX-512 support and Zen 4 tuning. | Ryzen 9 7950X, Ryzen 7 7800X3D, EPYC 9654 |
| **`oxzd_HiveOS_znver4_c_latest.tar.gz`** | 0.7.5 | AMD Zen 4 | ❌ CPU-only | Ryzen 7000 Series / EPYC 9004 | CPU-only build — no CUDA. Ideal for mining only on CPU cores. | Ryzen 9 7900, Ryzen 5 7600 |

---

## Configuration

All settings are defined in the HiveOS **Custom User Config**.

---

### GPU + CPU Builds (`_latest`) — OXZD 0.8.1

Supported GPU algorithms: `neptune`, `xnt`  
The `gpu_idle_command` accepts any external miner command (e.g. lolminer, rigel, trex).

#### Example Custom User Config

```json
{
  "main_algo_gpu": "neptune",
  "npt_address": "YOUR_NEPTUNE_ADDRESS",
  "npt_url": "stratum+ssl://eu.poolhub.io:4444",
  "gpu_idle_command": "./lolminer --algo ETHW --pool ethw.pool.io:4444 --user YOUR_WALLET.$(hostname)",
  "worker_name": "HiveOS_Rig_01"
}
```

#### Required Fields

| Field | Description | Values |
|-------|-------------|--------|
| `main_algo_gpu` | Primary GPU algorithm | `"neptune"` or `"xnt"` |
| `npt_address` | Neptune wallet address. Required if `main_algo_gpu` is `neptune`. | Any valid NPT address |
| `xnt_address` | XNT wallet address. Required if `main_algo_gpu` is `xnt`. | Any valid XNT address |

#### Optional Fields

| Field | Description | Default |
|-------|-------------|---------|
| `gpu_idle_command` | External miner command to run during GPU idle phases | — |
| `npt_url` | Neptune pool URL | `stratum+ssl://eu.poolhub.io:4444` |
| `xnt_url` | XNT pool URL | `stratum+ssl://eu.poolhub.io:30111` |
| `worker_name` | Rig name shown in pool. Defaults to HiveOS hostname. | Any string |

---

### CPU-only Builds (`_c_latest`) — OXZD 0.7.5

Supported CPU algorithms: `neptune`, `xelis`  
The `cpu_idle_command` accepts any external miner command (e.g. xmrig, cpuminer).

#### Example Custom User Config

```json
{
  "main_algo_cpu": "neptune",
  "npt_address": "YOUR_NEPTUNE_ADDRESS",
  "npt_url": "stratum+ssl://eu.poolhub.io:4444",
  "cpu_idle_command": "./xmrig --algo rx/0 --url pool.io:3333 --user YOUR_WALLET",
  "worker_name": "HiveOS_CPU_Rig_01"
}
```

#### Required Fields

| Field | Description | Values |
|-------|-------------|--------|
| `main_algo_cpu` | Primary CPU algorithm | `"neptune"` or `"xelis"` |
| `npt_address` | Neptune wallet address. Required if `main_algo_cpu` is `neptune`. | Any valid NPT address |
| `xelis_address` | Xelis wallet address. Required if `main_algo_cpu` is `xelis`. | Any valid Xelis address |

#### Optional Fields

| Field | Description | Default |
|-------|-------------|---------|
| `cpu_idle_command` | External miner command to run during CPU idle phases | — |
| `cpu_threads` | Number of CPU threads to use. Defaults to all available threads. | Any positive integer |
| `npt_url` | Neptune pool URL | `stratum+ssl://eu.poolhub.io:4444` |
| `xelis_url` | Xelis pool URL | `stratum+tcp://xelis.mine.zergpool.com:4444` |
| `worker_name` | Rig name shown in pool. Defaults to HiveOS hostname. | Any string |

---

## Notes

- Ensure the HiveOS Custom User Config is properly formatted JSON.
- Empty fields should be represented as empty strings (`""`), not `null`.
- Restart the miner after making configuration changes.
- The `_latest` builds (0.8.1) require at least **CUDA 12.2** and a compatible NVIDIA GPU driver.

---

## Support

For setup guides, troubleshooting, and community support, visit:  
👉 [https://discord.poolhub.io](https://discord.poolhub.io)
