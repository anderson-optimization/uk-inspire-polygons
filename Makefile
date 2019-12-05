
IMAGE="andersonopt/doc-fetch"

build:
	docker build -t ${IMAGE} .

deploy:
	docker push ${IMAGE}

inspect:
	docker run -it --rm \
		-v ${REPO_DIR}:/var/task \
		--env "DISPLAY" \
		-v "/tmp/.X11-unix:/tmp/.X11-unix:rw" \
		${IMAGE} /bin/bash

.PHONY: build test

extract_archive:
	cd archive
	for i in *.zip; 
	do 
		echo $i
		name=$(basename $i .zip) 
		mkdir -p $name
		unzip -o -d ./$name $i
	done
