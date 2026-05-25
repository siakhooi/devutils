#!/usr/bin/env bash
#
# Description: Build a Debian package from the source files.
# Usage: ./build-deb.sh [options]
#

set -euo pipefail

# shellcheck disable=SC1091
source ./build.env

# ===== Constants =====
readonly TARGET=target
readonly SOURCE=src

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
copy_control_files() {
	mkdir -p "$TARGET/DEBIAN"
	cp -vr "$SOURCE/DEBIAN"/* "$TARGET/DEBIAN/"
}
build_man_pages() {
	# Man Pages
	mkdir -p $TARGET/usr/share/man/man1/
	pandoc $SOURCE/md/"${PACKAGE_NAME}".1.md -s -t man | gzip -9 >$TARGET/usr/share/man/man1/"${PACKAGE_NAME}".1.gz
}
build_deb_package() {
	fakeroot dpkg-deb --build -Zxz $TARGET
}
rename_deb_package() {
	dpkg-name ${TARGET}.deb
}
generate_checksums() {
	DEBFILE=$(basename "$(ls ./*.deb)")
	sha256sum "$DEBFILE" >"$DEBFILE.sha256sum"
	sha512sum "$DEBFILE" >"$DEBFILE.sha512sum"
}
list_deb_contents() {
	DEBFILE=$(ls ./*.deb)
	dpkg --contents "$DEBFILE"
}
# ===== Main Logic =====
main() {

	parse_args "$@"
	copy_control_files
	build_man_pages

	build_deb_package
	rename_deb_package

	generate_checksums
	list_deb_contents
}
# ===== Entrypoint =====
main "$@"
