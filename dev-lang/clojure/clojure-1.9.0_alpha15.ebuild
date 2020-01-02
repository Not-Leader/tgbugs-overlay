# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
JAVA_PKG_IUSE="source test"

inherit java-pkg-2 java-ant-2

MY_P=${PN}-${PV/_/-}

DESCRIPTION="A dynamic programming language that targets the Java Virtual Machine"
HOMEPAGE="https://clojure.org/"
SRC_URI="https://github.com/clojure/clojure/tarball/${MY_P} -> ${MY_P}.tar.gz"

LICENSE="EPL-1.0 Apache-2.0 BSD"
SLOT="1.9"
KEYWORDS="~amd64 ~x86 ~x86-linux"
IUSE=""
RESTRICT="test" # patches welcome to fix the test

RDEPEND=">=virtual/jre-1.6"
DEPEND=">=virtual/jdk-1.6"

S=${WORKDIR}/clojure-clojure-ee065c3

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar ${MY_P/_/-}.jar
	java-pkg_dolauncher  ${PN}-${SLOT} --main clojure.main
	dodoc changes.md CONTRIBUTING.md readme.txt
}
