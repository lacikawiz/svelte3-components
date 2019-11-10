#!/bin/sh
cwd="$( cd "$( dirname "$0" )" >/dev/null 2>&1 && pwd )"
# cd $DIR
# cwd=$(pwd)
target=~/svelte3

if grep -Fxq "componentTest" ${target}/last.run
then
	echo "Purge not needed."
    # code if found
else
	cd ${target}
	./purge.sh
	cd ${cwd}
    # code if not found
fi

rsync -avu --delete ../*.svelte ${target}/src
rsync -avu --delete ../*.js ${target}/src

cd ${target}
rm public/*

npm run build

cp -u ./public/* ${cwd}/
echo "componentTest" >${target}/last.run
