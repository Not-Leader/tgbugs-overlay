# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit pax-utils

DESCRIPTION="General purpose, multi-paradigm Lisp-Scheme programming language"
HOMEPAGE="https://racket-lang.org/"
SRC_URI="minimal? ( https://download.racket-lang.org/installers/${PV}/${PN}-minimal-${PV}-src-builtpkgs.tgz ) !minimal? ( https://download.racket-lang.org/installers/${PV}/${P}-src-builtpkgs.tgz )"
LICENSE="LGPL-3 MIT Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="doc +futures +jit minimal +places +readline +threads +X"
REQUIRED_USE="futures? ( jit )"

RDEPEND="dev-db/sqlite:3
	media-libs/libpng:0
	x11-libs/cairo[X?]
	x11-libs/pango[X?]
	virtual/libffi
	virtual/jpeg:0
	readline? ( dev-libs/libedit )
	X? ( x11-libs/gtk+[X?] )"
RDEPEND="${RDEPEND} !dev-tex/slatex"

DEPEND="${RDEPEND}"

S="${WORKDIR}/${P}/src"

src_prepare() {
	rm -r bc/foreign/libffi || die 'failed to remove bundled libffi'
	eapply_user
}

src_configure() {
	# According to vapier, we should use the bundled libtool
	# such that we don't preclude cross-compile. Thus don't use
	# --enable-lt=/usr/bin/libtool
	econf \
		--docdir="${EPREFIX}"/usr/share/doc/${PF} \
		--enable-shared \
		--enable-float \
		--enable-libffi \
		--enable-foreign \
		--disable-libs \
		--disable-strip \
		--enable-useprefix \
		$(use_enable X gracket) \
		$(use_enable doc docs) \
		$(use_enable jit) \
		$(use_enable places) \
		$(use_enable futures) \
		$(use_enable threads pthread)
}

src_compile() {
	if use jit; then
		# When the JIT is enabled, a few binaries need to be pax-marked
		# on hardened systems (bug 613634). The trick is to pax-mark
		# them before they're used later in the build system. The
		# following order for racketcgc and racket3m was determined by
		# digging through the Makefile in src/racket to find out which
		# targets would build those binaries but not use them.
		pushd bc
		emake cgc-core
		pax-mark m .libs/racketcgc
		pushd gc2
		emake all
		popd
		pax-mark m .libs/racket3m
		popd
	fi

	default
}

src_install() {
	default

	if use jit; then
		# The final binaries need to be pax-marked, too, if you want to
		# actually use them. The src_compile marking get lost somewhere
		# in the install process.
		for f in mred mzscheme racket; do
			pax-mark m "${D}/usr/bin/${f}"
		done

		use X && pax-mark m "${D}/usr/$(get_libdir)/racket/gracket"
	fi
	# raco needs decompressed files for packages doc installation bug 662424
	if use doc; then
		docompress -x /usr/share/doc/${PF}
	fi
	find "${ED}" \( -name "*.a" -o -name "*.la" \) -delete || die
}
