setup-builder:
	docker buildx create --use --name builder
setup-platforms:
	docker run --privileged --rm tonistiigi/binfmt --install all
build: setup-platforms
	docker buildx build . -t miaumiau --builder builder --load --platform=linux/arm64
run:
	docker run -it --platform=linux/arm64 miaumiau:latest /bin/bootc container lint
build-image:
	sudo podman run \
	--rm \
	-it \
	--privileged \
	--pull=newer \
	--security-opt label=type:unconfined_t \
	-v /var/lib/containers/storage:/var/lib/containers/storage \
	quay.io/centos-bootc/bootc-image-builder:latest \
	--type iso \
	ghcr.io/prog-r-amer/pingipie:main
debug:
	sudo podman run \
	--rm \
	-it \
	--privileged \
	--pull=newer \
	--security-opt label=type:unconfined_t \
	-v /var/lib/containers/storage:/var/lib/containers/storage \
	quay.io/centos-bootc/bootc-image-builder:latest \
	manifest ghcr.io/prog-r-amer/pingipie:main
upstream:
	docker run -it --privileged \
		--platform=linux/arm64 --device=/dev/sdd:/dev/sdd \
		ghcr.io/prog-r-amer/pingipie:main /bin/bootc install to-disk --filesystem=ext4 /dev/sdd --source-imgref=registry:ghcr.io/prog-r-amer/pingipie:main --wipe
yolo:
	docker run -it --pid=host --platform=linux/arm64 --privileged \
		--device=/dev/sdd:/dev/sdd \
		-v /proc:/proc -v /sys:/sys -v /dev:/dev miaumiau \
		/bin/bootc install to-disk --source-imgref containers-storage:docker.io/library/miaumiau:latest /dev/sdd --wipe --generic-image
