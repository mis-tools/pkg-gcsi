#!/usr/bin/env bash
set -e
#set -x
script_dir=$(dirname "$0")
cwd=`pwd`

old_method=true
if [[ "$old_method" == true ]]; then
    # use a hardcoded version of itk, downloaded
    # as a tar ball and compiled from source
    #itk_version="4.5.0"
    #itk_version="4.7.2"
    itk_version=4.8.2
    itk_dir_prefix="InsightToolkit"
    outputdir=$2
    source ${script_dir}/dwn_itk.sh $itk_dir_prefix $itk_version $outputdir

    itk_dir="$outputdir/$itk_dir_prefix-$itk_version"
else
    # use git submodule checkout version of itk,
    # needs to have added itk as git submodule deps/ITK
    itk_dir="deps/ITK"
fi

# build dependencies
build_script=$1
source $build_script $itk_dir

sh ${script_dir}/download_and_extract_boost.sh

# make
build_dir="build"
install_dir="../debian/usr"
#rm -rf ${build_dir} ${install_dir}
mkdir -p ${build_dir}
cd ${build_dir}
cmake ../deps/gcsi/ \
-DCMAKE_INSTALL_PREFIX=${install_dir} \
-DCMAKE_BUILD_TYPE=Release \
-DBOOST_ROOT=$cwd/$boost_1_46_1/ \
-DITK_DIR=$cwd/$itk_dir/build \
-DCMAKE_INSTALL_RPATH_USE_LINK_PATH=TRUE \
-DCMAKE_EXE_LINKER_FLAGS="-static" 
n=`nproc`
make -j $n
make install
cd $cwd
