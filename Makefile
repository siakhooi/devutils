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

test-install:
	sudo apt install -f ./siakhooi-devutils_1.0.0_amd64.deb
	sudo apt remove -y siakhooi-devutils

delete-tags:
	git tag --delete 1.0.0
	git push --delete origin 1.0.0
docker-build-rpm:
	docker run --rm -v $(CURDIR):/workspaces docker.io/siakhooi/devcontainer:rpm44 scripts/build-rpms.sh
docker-build-deb:
	docker run --rm -v $(CURDIR):/workspaces docker.io/siakhooi/devcontainer:deb2604 scripts/build-deb.sh
