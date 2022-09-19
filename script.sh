#!/bin/bash

arg1=$1
DIR="/var/tmp/pulsemeeter-nightly"

delete_cache() {
	echo "Deleting cache dir"
	git -C $DIR gc --prune=all
	rm -r $DIR
}

download() {
	echo "Downloading Pulsemeeter with nightly branch"
	git clone --quiet --branch nightly https://github.com/theRealCarneiro/pulsemeeter.git $DIR
}

install() {
	if [ "$arg1" == "no-sudo" ]
	then
		echo "Installing without sudo rights."
		pip install $DIR
	else
		sudo pip install $DIR
	fi
}

pull() {
	echo "Pulling the newest version"
	git -C $DIR config advice.detachedHead false
	if ! git -C $DIR fetch origin nightly || ! git -C $DIR checkout origin/nightly
	then
		return 1
	fi
	return 0
}

if [ "$arg1" == "delete-cache" ]
then
	delete_cache
	exit 0
fi

# DOWNLOAD the repo if isn't already downloaded
if [ ! -d "$DIR" ]
then
	download
fi

# PULL the repo
pull
if [ $? == 1 ]
then
	# downloads again if it cannot pull
	echo "Could not update the git repository."
	echo "deleting the cache repo"
	delete_cache
	echo "redownloading..."
	download
fi

echo
echo "----------"
echo

echo "Installing using Pip"

if [ "$arg1" == "no-sudo" ]
then
	echo "Installing without sudo rights."
	pip install --upgrade --force-reinstall $DIR
else
	sudo pip install --upgrade --force-reinstall $DIR
fi

echo
echo "----------"

echo
echo "LATEST 10 COMMITS (top is newest)"
echo
echo
git --no-pager -C $DIR log -10 --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
exit 0
