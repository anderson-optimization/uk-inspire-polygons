
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