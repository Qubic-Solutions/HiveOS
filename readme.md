# OXZD Custom Wrapper for HiveOS

This setup uses the **OXZD Miner**, configured via the Custom User Config to write the correct`oxzd_config.json` file for OXZD, to define the primary mining algorithm and optional idle algorithms for both GPU and CPU.

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
