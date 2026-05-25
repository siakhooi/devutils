clean:
	rm -rf target *.deb *.deb.sha256sum *.deb.sha512sum
build-deb:
	./scripts/build-deb.sh
build-rpm:
	scripts/build-rpms.sh
set-version:
	scripts/set-version.sh
create-release:
	scripts/create-release.sh
all-deb: clean set-version build-deb
all-rpm: clean set-version build-rpm

test-man:
	pandoc src/md/siakhooi-devutils.1.md -s -t man | man -l -

root := justfile_directory()
docker-test:
	docker run --rm -v {{ root }}:/workspaces docker.io/siakhooi/devcontainer:deb2604 scripts/bats-test.sh

docker-build-rpm:
	docker run --rm -v {{ root }}:/workspaces docker.io/siakhooi/devcontainer:rpm44 scripts/build-rpms.sh
docker-build-deb:
	docker run --rm -v {{ root }}:/workspaces docker.io/siakhooi/devcontainer:deb2604 scripts/build-deb.sh

all: clean set-version docker-build-deb docker-build-rpm
