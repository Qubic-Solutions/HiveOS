#!/usr/bin/env bash
source /hive/miners/custom/rqiner-x86-cuda/h-manifest.conf

start_time=$(date +%s)

get_cpu_temps () {
  local t_core=`cpu-temp`
  local i=0
  local l_num_cores=$1
  local l_temp=
  for (( i=0; i < ${l_num_cores}; i++ )); do
    l_temp+="$t_core "
  done
  echo ${l_temp[@]} | tr " " "\n" | jq -cs '.'
}

get_cpu_fans () {
  local t_fan=0
  local i=0
  local l_num_cores=$1
  local l_fan=
  for (( i=0; i < ${l_num_cores}; i++ )); do
    l_fan+="$t_fan "
  done
  echo ${l_fan[@]} | tr " " "\n" | jq -cs '.'
}

get_cpu_bus_numbers () {
  local i=0
  local l_num_cores=$1
  local l_numbers=
  for (( i=0; i < ${l_num_cores}; i++ )); do
    l_numbers+="null "
  done
  echo ${l_numbers[@]} | tr " " "\n" | jq -cs '.'
}

get_miner_uptime(){
    local start_time=$(cat "/tmp/miner_start_time")
    local current_time=$(date +%s)
    let uptime=current_time-start_time
    echo $uptime
}

get_log_time_diff(){
  local a=0
  let a=`date +%s`-`stat --format='%Y' $log_name`
  echo $a
}

get_average_cpu_its() {
echo $(awk -F'|' '/Average:/ {split($3, a, " "); avg=a[2]} END{print avg}' "${CUSTOM2_LOG_BASENAME}.log")

}

get_average_its() {
   echo $(awk -F'|' '/Average\(10\):/ {split($3, a, " "); for (i in a) {if (a[i] ~ /Average\(10\):/) avg=a[i+1]}} END{print avg}' "${CUSTOM_LOG_BASENAME}.log")

}
get_accepted_solutions() {

	echo $(tail -n 1 "${CUSTOM_LOG_BASENAME}.log" | grep 'Solutions' | awk -F'Solutions: ' '{print $2}')
}


# GPUs

gpu_count=`cat /var/run/hive/gpu-detect.json | jq -r '.[] | select(.brand=="nvidia" or .brand=="amd" or .brand=="cpu") | .busid' | cut -d ':' -f 1 | wc -l`
#echo "nbre_gpu= $gpu_count"

gpu_temp=$(jq '.temp' <<< $gpu_stats)
gpu_fan=$(jq '.fan' <<< $gpu_stats)
gpu_bus=$(jq '.busids' <<< $gpu_stats)

gpu_stats=$(< $GPU_STATS_JSON)
readarray -t gpu_stats < <( jq --slurp -r -c '.[]  | .busids, .brand, .temp, .fan | join(" ")' $GPU_STATS_JSON  2>/dev/null)
cpu0=(${gpu_stats[1]:0:3})
#echo "cpu0 ?  = $cpu0 "

if [ $cpu0 == "cpu" ]; then
for (( i=0; i < ${gpu_count}; i++ )); do
temp[$i]=$(jq .[$((i+1))] <<< $gpu_temp)
fan[$i]=$(jq .[$((i+1))] <<< $gpu_fan)
busid=$(jq .[$((i+1))] <<< $gpu_bus)
bus_numbers[$i]=$(echo $busid | cut -d ":" -f1 | cut -c2- | awk -F: '{ printf "%d\n",("0x"$1) }')
done
else
for (( i=0; i < ${gpu_count}; i++ )); do
temp[$i]=$(jq .[$i] <<< $gpu_temp)
fan[$i]=$(jq .[$i] <<< $gpu_fan)
busid=$(jq .[$i] <<< $gpu_bus)
bus_numbers[$i]=$(echo $busid | cut -d ":" -f1 | cut -c2- | awk -F: '{ printf "%d\n",("0x"$1) }')
done
fi

uptime=$(get_miner_uptime)
[[ $uptime -lt 60 ]] && head -n 50 $log_name > $log_head_name
echo "miner uptime is: $uptime"

cpu_temp=`cpu-temp`
[[ $cpu_temp = "" ]] && cpu_temp=null

cpu_is_working=$( [[ -f "$conf_cpu" ]] && echo "yes" || echo "no" )

stats=""
algo="qubic"
uptime=$(get_miner_uptime)
hcpu=$(get_average_cpu_its)
hgpu=$(get_average_its)
khs=$(echo $hgpu + $hcpu | bc)
#khs=$(get_average_its)
khs=`echo $khs | awk '{print $1/1000}'`
hs_units="hs"


lines_to_process=$gpu_count
while IFS= read -r line; do

    if echo "$line" | grep -q "GPU[0-9]\+.*it/s"; then
        # Extract the GPU ID
        gpu=$(echo "$line" grep  GPU  | awk -F' ' '{print $4}' | sed 's/GPU//;s/://' | sed 's/ //g')
	      #echo "Working on gpu $gpu"
       
        # Extract the iteration rate (it/s value)
	      iterrate=$(echo "$line" | awk '{print $(NF -1)}')

	      echo "hs[$gpu]=$iterrate"

        # Store the it/s value in the associative array
        hs[$gpu]=$iterrate
    fi
#done < <(tail -n "$lines_to_process" "${CUSTOM_LOG_BASENAME}.log")
done < <(grep -E '(NVIDIA|AMD)' "${CUSTOM_LOG_BASENAME}.log" | tail -n "$lines_to_process")


#ver=$(awk '{print$2}'  "/tmp/.rqiner-x86-cuda-version" )
ver="0.5.0_bygdd"

total_khs=$khs
ac=$(get_accepted_solutions)
rj=0
stats=$(jq -nc \
        --arg khs "$total_khs" \
        --argjson hs "`echo ${hs[@]} | tr " " "\n" | jq -cs '.'`" \
	--arg hs_units "$hs_units" \
	--arg uptime "$uptime" \
        --arg ver "$ver" \
        --arg ac "$ac" --arg rj "$rj" \
        --arg algo "$algo" \
	--argjson temp "`echo ${temp[@]} | tr " " "\n" | jq -cs '.'`" \
        --argjson fan "`echo ${fan[@]} | tr " " "\n" | jq -cs '.'`" \
    	  --argjson bus_numbers "`echo ${bus_numbers[@]} | tr " " "\n" | jq -cs '.'`" \
        '{$khs, $hs, $hs_units, $temp, $fan, $ver, $uptime, $algo, ar: [$ac, $rj], $bus_numbers}')



# debug output

echo algo : $algo
echo total_khs : $khs
echo units : $hs_units
echo stats: $stats
echo khs cpu : $(get_average_cpu_its)
echo ----------
