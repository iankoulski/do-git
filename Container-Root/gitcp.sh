#!/bin/bash

help(){
	echo ""
	echo "Usage: $0 <git_url> <dest_path> [uid] [mode]"
	echo ""
	echo "       Downloads the specified github source location to the destination local path"
        echo "       git_url   - required, github URL to download"
        echo "       dest_path - required, destination local path"
        echo "       user_id   - optional, user_id to set on dest_path"
	echo "       mode      - optional, --no-cone(default)|--cone, do not(default) include files from parent folder"
	echo ""
}

parse_git_url(){
	echo "Parsing url: $git_url"
	git_repo_url=$(echo $git_url | cut -d '/' -f 1-5)
	git_repo_org=$(echo $git_url | cut -d '/' -f 4)
	git_repo_name=$(echo $git_url | cut -d '/' -f 5)
	keyword=$(echo $git_url | cut -d '/' -f 6)
	if [ "$keyword" == "tree" ]; then
		git_branch=$(echo $git_url | cut -d '/' -f 7)
		git_path=$(echo $git_url | cut -d '/' -f 8-)
	else
		git_branch=""
		git_path=$(echo $git_url | cut -d '/' -f 6-)
	fi
	git_abs_path="/${git_path}"
	
	
	echo "Git repo url: $git_repo_url"
	echo "Git repo org: $git_repo_org"
        echo "Git repo name: $git_repo_name"
	echo "Git branch: $git_branch"
	echo "Git path: $git_path"
        echo "Git abs path: $git_abs_path"
}


if [ "$2" == "" ]; then
	help
else
	git_url=$1
	dest_path=$2
	user_id=$3
        if [ "$user_id" == "" ]; then
		user_id=0
	fi
	mode=$4
	if [ "$mode" == "" ]; then
		mode=--no-cone
	fi
	parse_git_url $git_url
	pushd /tmp
        if [ "$git_abs_path" == "/" ]; then
		git clone $git_repo_url
	else
		git clone --no-checkout $git_repo_url
	fi

	pushd $git_repo_name
        if [ ! "$git_abs_path" == "/" ]; then
		git sparse-checkout init $mode
		git sparse-checkout set $git_abs_path
	fi
	git checkout ${git_branch}

	mkdir -p $dest_path
	src_path=$git_path
	if [ "$src_path" == "" ]; then src_path="."; fi
	cp -rf $src_path/. $dest_path

	echo "user_id=${user_id}"
	echo "dest_path=$dest_path"
	chown -R ${user_id}:${user_id} $dest_path
	
	popd
	rm -rf $git_repo_name 

	tree -L 1 $dest_path

fi

