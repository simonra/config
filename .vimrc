"To copy out of vim, shift+select with mouse

set encoding=utf-8
set history=50
set ignorecase
"Allows the use of the mouse, allways
set mouse=a
"No error bells of any kind
set noeb vb t_vb=
"Line numbers
set number
"Shows row and colum pos of charet
set ruler
set showcmd
"Sets the displayed tab-size
set tabstop=2
"How many columns autoindented text (<< and >>) is indented with
set shiftwidth=2
"wraps lines when you reach the end
"<,>,h, and l are for normal and visual, 
" [, and ] are for the arrow keys in insert and replace mode
set whichwrap+=>,l,]
set whichwrap+=<,h,[
"Enable syntax highlighting
syntax on
"Use dark background so the highlighting makes sense in the environments I usually use
set background=dark
"Automatically indent new line the same as last one
set autoindent
"Command-line autocomplete
set wildmode=longest,list
set wildmenu
"Make the statusline show the filepath in a more sensible way
"F is for full path, y is filetype
set statusline=%<%F\ %h%m%r%y%=%-14.(%l,%c%V%)\ %P
"Show path and charet position info on separate line
set laststatus=2
