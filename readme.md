# How to Run HiveOS (GPU/CPU)

Welcome to Qubic.Solutions mining guide for HiveOS. Follow the instructions below to set up and run your miner effectively.

## **Mining URL**
- **URL:** [Qubic.Solutions](https://qubic.solutions)

## **Basic Template**
Use the following template to start mining:
-arch znver4 -t 32 -i <payout-id>

## **Log Monitoring**
- **CPU log:** `tail -f /var/log/miner/custom/custom_cpu.log`
- **GPU log:** `tail -f /var/log/miner/custom/custom_gpu.log`

## **1. Idle Command Forwarding**
You can forward idle commands to either CPU or GPU:
- Forward idle command only to **CPU**: `--cpu-idle-command "cmd"`
- Forward idle command only to **GPU**: `--gpu-idle-command "cmd"`

## **2. Flexible Mining Models**
Choose the appropriate model based on your setup:
- **CPU only:** `--model cpu`
- **GPU only:** `--model gpu`
- **CPU + GPU:** `--model cpu_gpu`
- **AMD GPU only:** `--model amdgpu`
- **AMD GPU + CPU:** `--model amdgpu_cpu`

## **3. Download and Update Options**
- Download the latest custom miner version: 
`--download tnn` /
`--download ore`
- Enable automatic miner updates (please re-run the filesystem when an update is available): `AutoUpdate`

## **4. Example with Extra Config Arguments (CPU only + Ore mining + Auto Update)**
```
--model cpu
--download-ore
-arch cascadelake
-t 32
-i Your_Qubic-Wallet
--cpu-idle-command "/hive/miners/custom/OreMinePoolWorker_hiveos/ore-mine-pool-linux worker --route-server-url http://route.oreminepool.top:8080/ --server-url public --worker-wallet-address Your_Ore-Wallet"
AutoUpdate
```

## **5. Troubleshooting**
If the miner is not starting, run the following command:
```apt update && echo "deb http://cz.archive.ubuntu.com/ubuntu jammy main" >> /etc/apt/sources.list && apt update && apt install tmux -y && apt install libc6 -y```

You must create a new line for each new command with `--` and `AutoUpdate`.

## **Check Your Stats**
- **Official Stats:** [https://pool.qubic.solutions/info?miner=YOURIDHERE](https://pool.qubic.solutions/info?miner=YOURIDHERE)
- **MinerNinja Stats:** [http://qubic.commando.sh/](http://qubic.commando.sh/)

## **6. Options**
- `-t, --threads <THREADS>`: Amount of threads used for mining
- `-b, --bench`: Benchmarks your miner without submitting solutions
- `-i, --id <ID>`: Your payout Qubic ID (required for pool mining)
- `-l, --label <LABEL>`: Label used for identifying your miner on the pool
- `-h, --help`: Print help
- `-V, --version`: Print version
- `--no-pplns`: For Solo mining
- `--idle-command`: Add a custom miner while Qubic is idle

## **7. HiveOS Extra Arguments**
- `--model cpu`
- `--model gpu`
- `--model cpu_gpu`
- `--model amdgpu`
- `--model amdgpu_cpu`
