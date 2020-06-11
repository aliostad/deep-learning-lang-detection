#-------------------------------------------------------------
# Entorno Python
#-------------------------------------------------------------
# virtualenvwrapper
export WORKON_HOME=$HOME/.virtualenvs
export VIRTUALENVWRAPPER_HOOK_DIR=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Workspace
source /usr/bin/virtualenvwrapper.sh

export PYTHONPATH=$PYTHONPATH::


function pypi(){
    repo=$1;
    if [ ! "$repo" ]; then
        repo="pypi"
    elif [ "$repo" == "test" ]; then
        repo="pypitest"
    fi
    python2 setup.py sdist upload -r "$repo"
}

function pypi-register(){
    repo=$1;
    if [ ! "$repo" ]; then
        repo="pypi"
    elif [ "$repo" == "test" ]; then
        repo="pypitest"
    fi
    python2 setup.py register -r "$repo"
}

function mkvenv(){
    venv="$1";
     if [ ! "$venv" ]; then
        venv="venv";
     fi
    virtualenv -p /usr/bin/python "$venv";
    source "$venv/bin/activate";
}

function mkvenv2(){
    venv="$1";
     if [ ! "$venv" ]; then
        venv="venv";
     fi
    virtualenv -p /usr/bin/python2 "$venv";
    source "$venv/bin/activate";
}

function destroy(){
    venv="$VIRTUAL_ENV";
    deactivate
    rm -rf "$VIRTUAL_ENV";
    echo "Destroying $venv";
}
