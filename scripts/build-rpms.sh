#!/usr/bin/env bash
#
# Description: Build an RPM package from the source files.
# Usage: ./build-rpms.sh [options]
#

set -euo pipefail

if [[ ! -f ./build.env ]]; then
	echo "Error: build.env file not found. Please create it with the necessary variables."
	exit 1
fi
# shellcheck disable=SC1091
source ./build.env
if [[ -z "${PACKAGE_NAME:-}" ]]; then
	echo "Error: PACKAGE_NAME variable not set in build.env."
	exit 1
fi

# ===== Constants =====
readonly SOURCE=src
readonly TARGET=~/rpmbuild/BUILD/

# ===== Argument Parsing =====
parse_args() {
	while getopts "h" opt; do
		case "${opt}" in
		h)
			usage
			exit 0
			;;
		*)
			usage
			exit 1
			;;
		esac
	done
	shift $((OPTIND - 1))
}
# ===== Helper Functions =====
clean_rpmbuild() {
	rm -rf ~/rpmbuild
}
setup_rpmbuild_tree() {
	rpmdev-setuptree
}
copy_spec_file() {
	cp $SOURCE/RPMS/"${PACKAGE_NAME}".spec ~/rpmbuild/SPECS
}
build_man_pages() {
	# Man Pages
	mkdir -p $TARGET/usr/share/man/man1/
	pandoc $SOURCE/md/"${PACKAGE_NAME}".1.md -s -t man |
		gzip -9 >$TARGET/usr/share/man/man1/"${PACKAGE_NAME}".1.gz
}
copy_license_file() {
	cp -vf ./LICENSE "$TARGET"
}
build_rpm_package() {
	rpmlint ~/rpmbuild/SPECS/"${PACKAGE_NAME}".spec
	rpmbuild -bb -vv ~/rpmbuild/SPECS/"${PACKAGE_NAME}".spec
	cp -vf ~/rpmbuild/RPMS/noarch/"${PACKAGE_NAME}"-*.rpm .
}
query_rpm_package() {
	tree ~/rpmbuild/
	rpm -ql ~/rpmbuild/RPMS/noarch/"${PACKAGE_NAME}"-*.rpm
}
generate_rpm_checksums() {
	rpm_file=$(basename "$(ls ./"${PACKAGE_NAME}"-*.rpm)")
	sha256sum "$rpm_file" >"$rpm_file.sha256sum"
	sha512sum "$rpm_file" >"$rpm_file.sha512sum"
}
# ===== Main Logic =====
main() {

	parse_args "$@"

	clean_rpmbuild
	setup_rpmbuild_tree

	copy_spec_file
	build_man_pages

	copy_license_file

	build_rpm_package
	query_rpm_package
	generate_rpm_checksums
}

# ===== Entrypoint =====
main "$@"
