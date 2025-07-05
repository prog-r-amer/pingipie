setup-builder:
	docker buildx create --use --name builder
setup-platforms:
	docker run --privileged --rm tonistiigi/binfmt --install all
build: setup-platforms
	docker buildx build . -t miaumiau --builder builder --load --platform=linux/arm64
run:
	docker run -it --platform=linux/arm64 miaumiau
upstream:
	docker run -it --privileged \
		--device=/dev/sdd:/dev/sdd \
		ghcr.io/ublue-os/ucore-minimal:latest /bin/bootc install to-disk --filesystem=ext4 /dev/sdd --source-imgref=registry:ghcr.io/ublue-os/ucore-minimal:latest --wipe
yolo:
	docker run -it --pid=host --platform=linux/arm64 --privileged \
		--device=/dev/sdd:/dev/sdd \
		-v /proc:/proc -v /sys:/sys -v /dev:/dev miaumiau \
		/bin/bootc install to-disk --source-imgref containers-storage:docker.io/library/miaumiau:latest /dev/sdd --wipe --generic-image
