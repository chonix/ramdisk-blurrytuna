RQA='0:"0: Disabled", 1:"1", 2:"2"'
NM='0:"0: All", 1:"1: Simple Only", 2:"2: None"'

cat << CTAG
{
    name:I/O,
    elements:[
        { SPane:{
		title:"I/O Scheduler",
		description:"Set the active I/O elevator algorithm. The scheduler decides how to prioritize I/O requests and how to handle them."
        }},
	{ SOptionList:{
		default:`echo $(/res/synapse/actions/bracket-option /sys/block/mmcblk0/queue/scheduler)`,
		action:"bracket-option /sys/block/mmcblk0/queue/scheduler",
		values:[
`
			for IOSCHED in \`cat /sys/block/mmcblk0/queue/scheduler | sed -e 's/\]//;s/\[//'\`; do
			  echo "\"$IOSCHED\","
			done
`
		]
	}},
        { SPane:{
		title:"Block Queue",
		description:"Set the internal storage block device I/O parameters."
        }},
	{ SSeekBar:{
		title:"Read-Ahead Buffer",
		description:"Maximum amount to read-ahead for filesystems on the internal storage.",
		max:4096, min:128, unit:" kB", step:128,
		default:`cat /sys/block/mmcblk0/queue/read_ahead_kb`,
				action:"generic /sys/block/mmcblk0/queue/read_ahead_kb"
	}},
	{ SSeekBar:{
		title:"NR Requests",
		description:"Maximum number of read (or write) requests that can be queued to the scheduler in the block layer.",
		max:2048, min:128, step:128,
		default:`cat /sys/block/mmcblk0/queue/nr_requests`,
				action:"generic /sys/block/mmcblk0/queue/nr_requests"
	}},
	{ SSeekBar:{
		title:"RQ Affinity",
		description:"Try to have scheduler requests complete on the CPU core they were made from. Higher is more aggressive. Some kernels only support 0-1.",
		default:`cat /sys/block/mmcblk0/queue/rq_affinity`,
				action:"generic /sys/block/mmcblk0/queue/rq_affinity",
		values:{
`
			echo $RQA
`
		}
	}},
	{ SSeekBar:{
		title:"No Merges",
		description:"Types of merges (prioritization) the scheduler queue for this storage device allows.",
		default:`cat /sys/block/mmcblk0/queue/nomerges`,
				action:"generic /sys/block/mmcblk0/queue/nomerges",
		values:{
`
			echo $NM
`
		}
	}},
	{ SCheckBox:{
		description:"Draw entropy from spinning (rotational) storage.",
                label:"Add Random",
                default:`cat /sys/block/mmcblk0/queue/add_random`,
                action:"generic /sys/block/mmcblk0/queue/add_random"
        }},
	{ SCheckBox:{
		description:"Maintain I/O statistics for this storage device. Disabling will break I/O monitoring apps.",
                label:"I/O Stats",
                default:`cat /sys/block/mmcblk0/queue/iostats`,
                action:"generic /sys/block/mmcblk0/queue/iostats"
        }},
	{ SCheckBox:{
		description:"Treat device as rotational storage.",
                label:"Rotational",
                default:`cat /sys/block/mmcblk0/queue/rotational`,
                action:"generic /sys/block/mmcblk0/queue/rotational"
        }},
    ]
}
CTAG
