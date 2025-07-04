setup-builder:
	docker buildx create --use --name builder
setup-platforms:
	docker run --privileged --rm tonistiigi/binfmt --install all
build: setup-platforms
	docker buildx build . -t miaumiau --builder builder --load --platform=linux/arm64
run:
	docker run -it --platform=linux/arm64 miaumiau
yolo:
	docker run -it --platform=linux/arm64 --privileged --device=/dev/sdd:/dev/sdd miaumiau \
			/bin/bootc install to-disk --source-imgref containers-storage:docker.io/library/miaumiau:latest /dev/sdd
