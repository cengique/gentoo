# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )
inherit distutils-r1 virtualx

DESCRIPTION="Python tools to manipulate graphs and complex networks"
HOMEPAGE="https://networkx.github.io/ https://github.com/networkx/networkx"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="examples extras pandas scipy test xml yaml"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/decorator-4.3.0[${PYTHON_USEDEP}]
	>=dev-python/matplotlib-2.2.2[${PYTHON_USEDEP}]
	extras? (
		>=dev-python/pydot-1.2.4[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			>=dev-python/pygraphviz-1.5[${PYTHON_USEDEP}]
			>=sci-libs/gdal-1.10.0[python,${PYTHON_USEDEP}]
		' python3_{6,7,8})
	)
	pandas? (
		>=dev-python/pandas-0.23.3[${PYTHON_USEDEP}]
	)
	scipy? ( >=dev-python/scipy-1.1.0[${PYTHON_USEDEP}] )
	xml? ( >=dev-python/lxml-4.2.3[${PYTHON_USEDEP}] )
	yaml? ( >=dev-python/pyyaml-3.13[${PYTHON_USEDEP}] )"
BDEPEND="
	test? ( >=dev-python/scipy-1.1.0[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}"/${P}-py38.patch
	"${FILESDIR}"/${P}-py39.patch
)

src_prepare() {
	# incompatible deps?
	sed -e 's:test_multigraph_edgelist_tuples:_&:' \
		-i networkx/drawing/tests/test_pylab.py || die

	distutils-r1_src_prepare
}

src_test() {
	virtx distutils-r1_src_test
}

python_install_all() {
	use examples && dodoc -r examples

	distutils-r1_python_install_all
}
