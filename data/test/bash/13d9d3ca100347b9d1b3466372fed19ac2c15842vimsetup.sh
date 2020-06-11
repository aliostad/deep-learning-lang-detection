function setup_vim_files {
    mkdir ~/.vim
    mkdir ~/.vim/autoload
    mkdir ~/.vim/bundle
    curl -Sso ~/.vimautoload/pathogen.vim https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim
    cd ~/.vim/bundle/
    git clone git://github.com/tpope/vim-sensible.git
    git clone https://github.com/mintplant/vim-literate-coffeescript.git
    git clone https://github.com/kchmck/vim-coffee-script.git
    git clone https://github.com/scrooloose/nerdtree.git
    git clone https://github.com/scrooloose/syntastic.git
}
function write_vimrc {

    local VIMRC=~/.vimrc

    rm -f $VIMRC
    append $VIMRC "map <F7> :tabp"
    append $VIMRC "map <F9> :tabe"
    append $VIMRC "map <F8> :tabn"
    append $VIMRC "map <F12> :NERDTreeTabsToggle"
    append $VIMRC "map ,o :NERDTreeSteppedOpen"
    append $VIMRC "map ,c :NERDTreeSteppedClose"
    append $VIMRC "execute pathogen#infect()"
    append $VIMRC "syntax on"
    append $VIMRC "filetype plugin indent on"
    append $VIMRC "set expandtab"
    append $VIMRC "set shiftwidth=2"
    append $VIMRC "set softtabstop=2"
    append $VIMRC "g:nerdtree_tabs_open_on_console_startup=1"

}
setup_vim_files
write_vimrc

