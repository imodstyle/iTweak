#!/system/bin/sh
# Fine tune kernel parameter
# Author: @imodstyle based of KTweak by tytydraco
# ×××××××××××××××××××××××××× #

sleep 30

# Limit max perf event processing time to this much CPU usage
#echo 5 > /proc/sys/kernel/perf_cpu_time_max_percent

# Execute child process before parent after fork
#echo 1 > /proc/sys/kernel/sched_child_runs_first

# Preliminary requirement for the following values
#echo 0 > /proc/sys/kernel/sched_tunable_scaling

# Reduce the maximum scheduling period for lower latency
#echo 4000000 > /proc/sys/kernel/sched_latency_ns

# Schedule this ratio of tasks in the guarenteed sched period
#echo 500000 > /proc/sys/kernel/sched_min_granularity_ns

# Require preeptive tasks to surpass half of a sched period in vmruntime
#echo 2000000 > /proc/sys/kernel/sched_wakeup_granularity_ns

# Reduce the frequency of task migrations
#echo 5000000 > /proc/sys/kernel/sched_migration_cost_ns

# Improve real time latencies by reducing the scheduler migration time
#echo 32 > /proc/sys/kernel/sched_nr_migrate

# Disable scheduler statistics to reduce overhead
echo 0 > /proc/sys/kernel/sched_schedstats

# Disable unnecessary printk logging
echo off > /proc/sys/kernel/printk_devkmsg
echo "0 0 0 0" > /proc/sys/kernel/printk

# Start non-blocking echoback later
#echo 10 > /proc/sys/vm/dirty_background_ratio

# Start blocking echoback later
#echo 30 > /proc/sys/vm/dirty_ratio

# Require dirty memory to stay in memory for longer
#echo 3000 > /proc/sys/vm/dirty_expire_centisecs

# Run the dirty memory flusher threads less often
#echo 3000 > /proc/sys/vm/dirty_writeback_centisecs

# Disable read-ahead for swap devices
#echo 0 > /proc/sys/vm/page-cluster

# Update /proc/stat less often to reduce jitter
echo 10 > /proc/sys/vm/stat_interval

# Swap to the swap device at a fair rate
#echo 100 > /proc/sys/vm/swappiness

# Fairly prioritize page cache and file structures
#echo 100 > /proc/sys/vm/vfs_cache_pressure

# Enable Explicit Congestion Control
echo 1 > /proc/sys/net/ipv4/tcp_ecn

# Enable fast socket open for receiver and sender
echo 3 > /proc/sys/net/ipv4/tcp_fastopen

# Change IO Sched to SSG and fine tune
for queue in /sys/block/*/queue
do
	# Choose the first governor available
	avail_scheds="$(cat "$queue/scheduler")"
	for sched in ssg none bfq kyber mq-deadline
	do
		if [[ "$avail_scheds" == *"$sched"* ]]
		then
			echo "$sched" > "$queue/scheduler"
			break
		fi
	done

	# Do not use I/O as a source of randomness
	echo 0 > "$queue/add_random"

	# Disable I/O statistics accounting
	echo 0 > "$queue/iostats"

	# Reduce heuristic read-ahead in exchange for I/O latency
	echo 128 > "$queue/read_ahead_kb"

	# Reduce the maximum number of I/O requests in exchange for latency
	echo 64 > "$queue/nr_requests"
done

# Change TCP Congest to BBR if avail
# Choose the first tcp congest available
avail_tcp="$(cat /proc/sys/net/ipv4/tcp_available_congestion_control)"
for congest in bbr westwood cubic
do
	if [[ "$avail_tcp" == *"$congest"* ]]
	then
		echo "$congest" > /proc/sys/net/ipv4/tcp_congestion_control
		break
	fi
done
