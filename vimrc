"source ~/.vimclangcomp
set wildmenu
set wildmode=list:longest

runtime ~/.vim/bundle/vim_bundles/structgen/structgen.vim

if has("autocmd")
filetype plugin indent on
execute pathogen#infect()
autocmd BufNewFile *.h source ~/.vim/bundle/vim_bundles/hheader/hheader.vim
""autocmd BufNewFile t_*.h 
autocmd BufNewFile main.c source ~/.vim/bundle/vim_bundles/cmain/cmain.vim
autocmd BufNewFile *.c source ~/.vim/bundle/vim_bundles/cheader/cheader.vim
autocmd BufNewFile *.php source ~/.vim/bundle/vim_bundles/phpheader/phpheader.vim
autocmd BufNewFile Makefile source ~/.vim/bundle/vim_bundles/makef/makef.vim
autocmd BufNewFile Makefilelib source ~/.vim/bundle/vim_bundles/makeflib/makeflib.vim
autocmd BufReadPost * if line("'\"") | exe "normal '\"" | endif
endif " has ("autocmd")

"Show current line
"""""""""""""""""""""""""""""
"=> Status line
"""""""""""""""""""""""""""""
" " Always show the status line
set laststatus=2

set showcmd
set nowrap
set noendofline binary
set nu

syntax on
set autoindent
set shiftwidth=4
set softtabstop=4
set tabstop=4
set noexpandtab
set ruler

set scrolloff=5

set history=400
set showmatch
set hlsearch
set incsearch

filetype on

noremap <C-l> :match
inoremap <C-l> <Esc>:match
noremap <C-o> :call Struct("")
inoremap <C-o> <Esc>:call Struct("")
noremap <C-Tab> gt
noremap <C-S-Tab> gT
map <Esc>Oq 1
map <Esc>Or 2
map <Esc>Os 3
map <Esc>Ot 4
map <Esc>Ou 5
map <Esc>Ov 6
map <Esc>Ow 7
map <Esc>Ox 8
map <Esc>Oy 9
map <Esc>Op 0
map <Esc>On .
map <Esc>OQ /
map <Esc>OR *
map <kPlus> +
map <Esc>OS -
map! <Esc>Oq 1
map! <Esc>Or 2
map! <Esc>Os 3
map! <Esc>Ot 4
map! <Esc>Ou 5
map! <Esc>Ov 6
map! <Esc>Ow 7
map! <Esc>Ox 8
map! <Esc>Oy 9
map! <Esc>Op 0
map! <Esc>On .
map! <Esc>OQ /
map! <Esc>OR *
map! <kPlus> +
map! <Esc>OS -


"highlight ExtraWhitespace ctermbg=red ctermfg=white guibg=red
"match ExtraWhitespace /\s\n/
set list
set listchars=trail:-,tab:>-
highlight SpecialKey guifg=blue ctermfg=lightblue
highlight ExtraWhitespace ctermbg=red guibg=red
highlight MissingWhitespace ctermbg=green guibg=green
highlight CKeywSpaceNext ctermbg=green guibg=green
highlight CKeywSpPar ctermbg=green guibg=green
highlight CKeywReturn ctermbg=green guibg=green
highlight EOFErr ctermbg=red guibg=red
"au BufWinEnter * silent loadview
au BufWinEnter *.,*.h let w:m1=matchadd('ErrorMsg', '\%>80v.\+', -1)
au BufWinEnter *.c,*.h let w:m2=matchadd('ExtraWhitespace', '\s\+$\| \+\ze\t\|  \+\|\t\zs \+', -1)
au BufWinEnter *.c,*.h let w:m3=matchadd('MissingWhitespace', ',[^ ]', -1)
au BufWinEnter *.c,*.h let w:m4=matchadd('CKeywSpaceNext', '\(ifndef\|define\|while\|return\|const\|typedef\|extern\|unsigned\)[^ ]', -1)
au BufWinEnter *.c let w:m5=matchadd('CKeywReturn', 'return [^(;]', -1)
au BufWinEnter *.c,*.h let w:m6=matchadd('CKeywSpPar', '[^a-zA-Z_0-9]\(while\|if\)\([^ a-zA-Z_0-9]\| [^(]\)', -1)
set mouse=a