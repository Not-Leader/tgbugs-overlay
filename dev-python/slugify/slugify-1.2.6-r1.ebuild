# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( pypy pypy3 python3_{5,6} )
inherit distutils-r1

DESCRIPTION="A Python Slugify application that handles Unicode"

HOMEPAGE="https://github.com/un33k/python-slugify"
SRC_URI="mirror://pypi/p/python-${PN}/python-${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-python/unidecode-0.04.16[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

RESTRICT="test"

S="${WORKDIR}/python-${P}"
