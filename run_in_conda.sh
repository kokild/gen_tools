# Run a command in the given conda env
# You have to be in base env to run this command
# Usage: sh run_in_conda.sh <env_name>  command [arg1 [arg2] ... ]

function usage
{
	echo "Usage: sh run_in_conda.sh <env_name>  command [arg1 [arg2] ... ]"
}

function main
{
	if ! which conda >/dev/null 2>&1
	then
		echo "Cannot find conda!"
		return 1
	fi

	if [ `conda info | grep "active environment" | cut -d: -f2` != base ]
	then
		echo "You must be in base env to start with"
		echo "Please do 'conda deactivate'"
		return 2
	#else
	#	echo "Good, you are in base"
	fi

	env_name=$1
	shift

	#Validate env_name
	if [ -z "$env_name" -o -z "$1" ]
	then
		usage
		return 3
	fi

	if ! conda info --envs 2>/dev/null | grep -q -w $env_name
	then
		echo "There is no conda env named: $env_name"
		usage
		return 4
	fi

	cmd="source $CONDA_PREFIX/etc/profile.d/conda.sh && conda activate $CONDA_PREFIX/envs/$env_name > /dev/null 2>&1"
	cmd=$cmd" && $@ ; conda deactivate"
	#echo "Full cmd is:[$cmd]"
	eval $cmd
}

main "$@"
