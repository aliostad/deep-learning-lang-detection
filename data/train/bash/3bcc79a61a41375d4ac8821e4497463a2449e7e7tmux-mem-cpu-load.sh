#
# tmux-mem-cpu-load
#


TMCL=tmux-mem-cpu-load-2.2.2
TMCL_SRC=https://github.com/thewtex/tmux-mem-cpu-load/archive/v2.2.2.tar.gz

# download/install tmux-mem-cpu-load in ~/.local/bin
if [ ! -x ${HOME}/.local/bin/tmux-mem-cpu-load ]; then
    check_executable wget
    check_executable cmake
    check_executable g++
    check_executable make

    pushd /tmp
    wget ${TMCL_SRC}
    tar -xvf $(basename ${TMCL_SRC})
    cd ${TMCL}

    cmake -D BUILD_TESTING=false .
    make
    cp tmux-mem-cpu-load ${HOME}/.local/bin/

    cd ..
    rm -rf ${TMCL} $(basename ${TMCL_SRC})

    popd
fi
