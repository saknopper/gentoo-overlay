# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

KEYWORDS="~amd64 ~x86"

DESCRIPTION="NSS MySQL Library"
HOMEPAGE="https://github.com/saknopper/libnss-mysql"
SRC_URI="https://github.com/saknopper/libnss-mysql/releases/download/v${PV}/${PN}-${PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
IUSE="debug static-libs"

DEPEND="dev-db/mysql-connector-c:="
RDEPEND="${DEPEND}"

DOCS=( AUTHORS DEBUGGING FAQ INSTALL NEWS README THANKS
	UPGRADING ChangeLog
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	# Usually, authentication libraries don't belong into usr.
	# But here, it's required that the lib is in the same dir
	# as libmysql, because else failures may occur on boot if
	# udev tries to access a user / group that doesn't exist
	# on the system before /usr is mounted.
	econf --libdir="/usr/$(get_libdir)" \
		$(use_enable debug) \
		$(use_enable static-libs static)
}

src_install() {
	default

	use static-libs || find "${D}" -name '*.la' -delete

	newdoc sample/README README.sample

	local subdir
	for subdir in sample/{linux,freebsd,complex,minimal} ; do
		docinto "${subdir}"
		dodoc "${subdir}/"{*.sql,*.cfg}
	done
}
