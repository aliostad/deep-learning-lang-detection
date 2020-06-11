function zsh_recompile() {
  autoload -U zrecompile
  [[ -f ~/.zshrc ]] && zrecompile -p ~/.zshrc
  [[ -f ~/.zshrc.zwc.old ]] && rm -f ~/.zshrc.zwc.old

  for f in ~/.zsh/**/*.zsh; do
    [[ -f $f ]] && zrecompile -p $f
    [[ -f $f.zwc.old ]] && rm -f $f.zwc.old
  done

  [[ -f ~/.zcompdump ]] && zrecompile -p ~/.zcompdump
  [[ -f ~/.zcompdump.zwc.old ]] && rm -f ~/.zcompdump.zwc.old

  source ~/.zshrc
}

function crypted_truths {
    /Applications/TrueCrypt.app/Contents/MacOS/TrueCrypt -t -k "" --protect-hidden=no ~/Documents/work ~/src/relevance
}

function clone_clojure_repo {
    git clone git@github.com:clojure/$1
}

function make_clojure_dev {
    mkdir -p ~/src/opensource/clojure
    cd ~/src/opensource/clojure
    clone_clojure_repo clojure
    clone_clojure_repo clojurescript
    clone_clojure_repo clojure-contrib
    clone_clojure_repo algo.generic
    clone_clojure_repo algo.monads
    clone_clojure_repo build.poms
    clone_clojure_repo clojure.github.com
    clone_clojure_repo core.incubator
    clone_clojure_repo core.logic
    clone_clojure_repo core.unify
    clone_clojure_repo data.csv
    clone_clojure_repo data.enlive
    clone_clojure_repo data.finger-tree
    clone_clojure_repo data.json
    clone_clojure_repo data.priority-map
    clone_clojure_repo data.xml
    clone_clojure_repo data.zip
    clone_clojure_repo io.incubator
    clone_clojure_repo java.classpath
    clone_clojure_repo java.data
    clone_clojure_repo java.internal.invoke
    clone_clojure_repo java.jmx
    clone_clojure_repo java.jdbc
    clone_clojure_repo math.combinatorics
    clone_clojure_repo math.numeric-tower
    clone_clojure_repo net.ring
    clone_clojure_repo test.benchmark
    clone_clojure_repo test.generative
    clone_clojure_repo tools.cli
    clone_clojure_repo tools.logging
    clone_clojure_repo tools.macro
    clone_clojure_repo tools.namespace
    clone_clojure_repo tools.nrepl
    cd clojure
    mvn package
}

function extract {
    echo Extracting $1 ...
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1  ;;
            *.tar.gz)    tar xzf $1  ;;
            *.bz2)       bunzip2 $1  ;;
            *.rar)       rar x $1    ;;
            *.gz)        gunzip $1   ;;
            *.tar)       tar xf $1   ;;
            *.tbz2)      tar xjf $1  ;;
            *.tgz)       tar xzf $1  ;;
            *.zip)       unzip $1   ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1  ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

function ss {
    if [ -e script/rails ]; then
        script/rails server $@
    else
        script/server $@
    fi
}

function sc {
    if [ -e script/rails ]; then
        script/rails console $@
    else
        script/console $@
    fi
}

function sg {
    if [ -e script/rails ]; then
        script/rails generate $@
    else
        script/generate $@
    fi
}

# Re-acquire forwarded SSH key
# from http://tychoish.com/rhizome/9-awesome-ssh-tricks/
function ssh-reagent {
    for agent in /tmp/ssh-*/agent.*; do
        export SSH_AUTH_SOCK=$agent
        if ssh-add -l 2>&1 > /dev/null; then
            echo Found working SSH Agent:
            ssh-add -l
            return
        fi
    done
    echo Cannot find ssh agent - maybe you should reconnect and forward it?
}
