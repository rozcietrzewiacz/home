" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2008 Jul 02
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
"if has('mouse')
"  set mouse=a
"endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

"----------------------------------------------------
if v:progname =~? "gvim"
	colorscheme evening
"else
"	set tabline=%!MyTabLine()
endif


"set showtabline=1 " 2=always
"autocmd GUIEnter * hi! TabLineFill term=underline cterm=underline gui=underline
"autocmd GUIEnter * hi! TabLineSel term=bold,reverse,underline
"\ ctermfg=11 ctermbg=12 guifg=#ffff00 guibg=#0000ff gui=underline

let g:Tex_SmartQuoteOpen = "\"`"
let g:Tex_SmartQuoteClose = "\"'"
let g:Tex_DefaultTargetFormat = "pdf"
let g:Tex_ViewRule_pdf = "evince"

"se noai
"!!!! bo auto-wciecie jest MEGA wkurwiajace przy wklejaniu
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode
"

se softtabstop=4
se shiftwidth=4
se expandtab

" To avoid having *~ files net to original in their dirs
set backupdir =~/.vim/backups_dir,.
set directory=~/.vim/backups_dir,.

"############## DIR-listing (netrw) mode setup
        let g:netrw_preview   = 1
        let g:netrw_liststyle = 3
        let g:netrw_winsize   = 30


" Fixes screen<->vim interaction - per
" http://vim.wikia.com/wiki/GNU_Screen_integration
if match($TERM, "screen")!=-1
  set term=xterm
endif

let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
