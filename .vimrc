"=============================================================================
"                               common config                                "
"=============================================================================
" be iMproved, required
set nocompatible
" set search highlight
set hlsearch
" set mapleader
let mapleader=","
" turn on filetype detection, ftplugin, indent
filetype plugin indent on
" enable syntax highlight
syntax on
" set backspace
set backspace=indent,eol,start
function! OpenVim(mode)
    if a:mode=="full"
        echo "Switching to full-feature gvim ..."
        silent exe "!unsetenv my_vim_light; setenv my_vim_full;gvim ".expand('%:p')
    elseif a:mode=="light"
        echo "Switching to light-feature gvim ..."
        silent exe "!unsetenv my_vim_full; setenv my_vim_light;gvim ".expand('%:p')
    endif
    if len(filter(range(1,bufnr('$')),'buflisted(v:val)'))=="1"
        silent exe "quit"
    else
        silent exe "bwipeout"
    endif
endfunction
" open in full-feature gvim
nnoremap <silent> <leader>v :call OpenVim("full")<CR>
" open in light gvim
nnoremap <silent> <leader>V :call OpenVim("light")<CR>
" force quit
nnoremap <leader>q :q!<CR>
"=============================================================================
"                      full & light-feature vim config                       "
"=============================================================================
if has("unix") && (exists("$my_vim_full") || exists("$my_vim_light")) || has("win32") || has("macunix")
    "==================
    "  vundle plugin  "
    "==================
    if has("win32")
        set rtp+=$vim/vimfiles/bundle/Vundle.vim
        call vundle#begin("$vim/vimfiles/bundle")
    else
        set rtp+=~/.vim/bundle/Vundle.vim
        call vundle#begin()
    endif
    Plugin 'gmarik/Vundle.vim'
    Plugin 'L9'
    Plugin 'scrooloose/nerdcommenter'
    Plugin 'SingleCompile'
    Plugin 'matchit.zip'
    Plugin 'altercation/vim-colors-solarized'
    Plugin 'NLKNguyen/papercolor-theme'
    Plugin 'ShowMarks'
    Plugin 'Raimondi/delimitMate'
    Plugin 'Shougo/neocomplete.vim'
    Plugin 'godlygeek/tabular'
    Plugin 'SirVer/ultisnips'
    Plugin 'honza/vim-snippets'
    Plugin 'hdima/python-syntax'
    Plugin 'vim-airline/vim-airline'
    Plugin 'vim-airline/vim-airline-themes'
    "Plugin 'kien/ctrlp.vim'
    if has("unix") || has("macunix")
        Plugin 'powerman/vim-plugin-viewdoc'
    endif
    Plugin 'FuzzyFinder'
    Plugin 'michalbachowski/vim-wombat256mod'
    if has("unix") && exists("$my_vim_full") || has("win32") || has("macunix")
        Plugin 'Yggdroot/indentLine'
        "Plugin 'Valloric/YouCompleteMe'
        Plugin 'scrooloose/syntastic'
    endif
    call vundle#end()
    "================
    "  key mapping  "
    "================
    if has("gui_running")
        " set CTRL+s to save if gvim
        inoremap <C-s> <esc>:w<CR>a
        nnoremap <C-s> :w<CR>
        " set CTRL+c to copy in system's clipboard
        vmap <C-c> "+y
        " set CTRL+v to paste from system's clipboard
        inoremap <C-v> <C-r>+
    endif
    " buffer swap
    nnoremap <s-h> :bp<CR>
    nnoremap <s-l> :bn<CR>
    " Wrapped lines goes down/up to next row, rather than next line in file.
    noremap j gj
    noremap k gk
    " Yank from the cursor to the end of the line, to be consistent with C and D.
    noremap Y y$
    " split space seperated words to lines
    nnoremap <leader><space> :%s/ /\r/g<CR>
    " automatically highlight word under cursor
    autocmd CursorMoved * exe exists("HlUnderCursor")?HlUnderCursor?printf('match IncSearch /\V\<%s\>/', escape(expand('<cword>'),'/\')):'match none':""
    nnoremap <silent> <leader>h :exe "let HlUnderCursor=exists(\"HlUnderCursor\")?HlUnderCursor*-1+1:1"<CR>
    " Visual shifting (does not exit Visual mode)
    vnoremap < <gv
    vnoremap > >gv
    " Easier horizontal scrolling
    map zl zL
    map zh zH
    " toggle wrap
    nnoremap <leader>w :set wrap!<CR>
    " test if file exists
    function! TestExists(mode)
        if a:mode=="normal"
            let s:filename=expand("<cfile>")
        elseif a:mode=="visual"
            let s:filename=getreg('*',1)
        endif
        if !empty(glob(s:filename))
            echohl MoreMsg
            echo "Exists !(File: ".s:filename.")"
            echohl None
        else
            echohl WarningMsg
            echo "Does not exists !(File: ".s:filename.")"
            echohl None
        endif
    endfunction

    nnoremap <silent> te :call TestExists("normal")<CR>
    vnoremap <silent> te <Esc>:call TestExists("visual")<CR>
    " make file executable
    function! MakeExecutable()
        let filename=expand("%:p")
        if executable(filename) == 0
            silent exe "!chmod a+x ".shellescape(filename)
            if v:shell_error
                echohl WarningMsg
                echo 'Could not make this file executable!'
                echohl None
            else
                if ! &l:modified
                    silent exe "edit"
                endif
                echohl MoreMsg
                echo "Made this file executable!"
                echohl None
            endif
        else
            silent exe "!chmod -x ".shellescape(filename)
            if v:shell_error
                echohl WarningMsg
                echo 'Could not make this file not executable!'
                echohl None
            else
                if ! &l:modified
                    silent exe "edit"
                endif
                echohl WarningMsg
                echo "Make this file not executable!"
                echohl None
            endif
        endif
    endfunction
    nnoremap <silent> <leader>x :call MakeExecutable()<CR>
    " open snippets
    nnoremap <leader>es :UltiSnipsEdit<CR>
    " toggle show menu bar
    map <silent> <F2> :if &guioptions =~# 'm' <Bar> set guioptions-=m <Bar> else <Bar> set guioptions+=m <Bar> endif <CR>
    " open configuration file with short key
    if has("win32")
        nnoremap <leader>ev :e $vim/_vimrc<CR>
    else
        nnoremap <leader>ev :e $HOME/.vimrc<CR>
        nnoremap <leader>ec :e $HOME/.cshrc<CR>
    endif
    " paste from system clipboard
    if has("gui_running")
        imap <S-Insert> <esc>"+pa
    endif
    " save buffer
    nnoremap <leader>s :w<CR>
    " use tab to choose item im pop menu
    inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<C-g>u\<Tab>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<C-g>u\<Tab>"
    " open folding with space
    nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>
    " force quit
    nnoremap <leader>q :q!<CR>
    function! ToggleFont(mode)
        if a:mode=="shrink"
            if has("win32")
                set guifont=DejaVu_Sans_Mono_for_Powerline:h9
            else
                set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 9
            endif
            set linespace=0
        elseif a:mode=="enlarge"
            if has("win32")
                set guifont=DejaVu_Sans_Mono_for_Powerline:h12
            else
                set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 12
            endif
            set linespace=0
        endif
    endfunction
    " fullscreen or maximize
    if has("gui_running")
        if has("unix")
            function! ToggleFullScreen()
                call system("wmctrl -r :ACTIVE: -b toggle,fullscreen")
            endfunction

            function! MaximizeWin()
                call system("wmctrl -r :ACTIVE: -b add,maximized_vert,maximized_horz")
            endfunction

            nnoremap <F11> :call ToggleFullScreen()<CR>
            nnoremap <silent> <F4> :call MaximizeWin()<CR>:call ToggleFont("shrink")<CR>
            nnoremap <silent> <c-F4> :call ToggleFont("enlarge")<CR>
        else
            nnoremap <silent> <F4> :call ToggleFont("shrink")<CR>
            nnoremap <silent> <c-F4> :call ToggleFont("enlarge")<CR>
        endif
    endif
    " backup current line
    nnoremap <leader>y m'yyP :call NERDComment(0,"toggle")<CR>`'
    " Delete trailing white space on save, useful for Python and CoffeeScript
    nnoremap <leader>S :%s/\s\+$//ge<CR>
    " toggle highlight search
    nmap <silent> <leader>/ :set hlsearch!<CR>
    " Visual mode pressing * or # searches for the current selection
    vnoremap  * y/<C-R>=escape(@", '\\/.*$^~[]')<CR><CR>
    vnoremap  # y?<C-R>=escape(@", '\\/.*$^~[]')<CR><CR>
    " Visual mode pressing <leader>n to get count of current selection
    vnoremap <silent> <leader>n y:%s/<C-R>=escape(@", '\\/.*$^~[]')<CR>//gn<CR>
    " When you press gv you vimgrep after the selected text
    vnoremap gv y:vimgrep /<C-R>=escape(@", '\\/.*$^~[]')<CR>/ **/*
    " When you press <leader>h you can search and replace the selected text
    vnoremap <leader>h y:%s/<C-R>=escape(@", '\\/.*$^~[]')<CR>//g<Left><Left>
    " When you search with vimgrep, open quickfix window to display your results
    map <leader>o :botright cope<cr>
    " reformat
    noremap <F9> gggqG
    "================
    "  vim options  "
    "================
    " set omnifunc complete
    if has("autocmd") && exists("+omnifunc")
        autocmd Filetype * if &omnifunc == ""|setlocal omnifunc=syntaxcomplete#Complete|endif
    endif
    " keep indention of previous line
    set autoindent
    " show cursor position
    set ruler
    " set 7 lines to the cursor when moving vertically using j/k
    "set scrolloff=7
    " Don't redraw while executing macros (good performance config)
    set lazyredraw
    " change buffer without saving
    set hidden
    " do not blink
    set novisualbell
    " no swap file
    set noswapfile
    " linespace
    set linespace=1
    " don't ring error bell
    set noerrorbells
    " history length
    set history=50
    " show command just excuted
    set showcmd
    " show completion for commands
    set wildmenu
    " ignore case when searching
    set ignorecase smartcase
    " do not show file path on tab
    set guitablabel=[%N]\ %m%t
    " color theme
    if has("gui_running")
        if exists("$my_vim_full")
            set background=dark
            colorscheme solarized
        elseif exists("$my_vim_light")
            set background=light
            colorscheme PaperColor
        else
            set background=dark
            colorscheme solarized
        endif
    endif
    " set expandtab
    set expandtab
    " set font
    if has("win32")
        set guifont=DejaVu_Sans_Mono_for_Powerline:h12
        set guifontwide=DejaVu_Sans_Mono_for_Powerline:h12
    elseif has("unix")
        set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 12
        set guifontwide=DejaVu\ Sans\ Mono\ for\ Powerline\ 12
    endif
    " set encoding
    set fileencodings=utf-8,gb18030,gbk,gb2312,cp936,ucs-bom
    set termencoding=utf-8
    set encoding=utf-8
    " avoid messy code
    if has("win32")
        set langmenu=zh_CN.UTF-8
        language messages zh_CN.UTF-8
    endif
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim
    " show line number
    set number
    " new vertically split window is no the right
    set splitright
    " no horizontally split window is below old
    set splitbelow
    " set fileformats
    set fileformats=unix,dos
    " set tab width
    set tabstop=4
    set softtabstop=4
    " set indention width
    set shiftwidth =4
    " set libe break width
    set textwidth=0
    " set max tab number
    set tabpagemax=20
    " set current file's path as pwd
    set autochdir
    " set current line highlight
    if has("gui_running")
        set cursorline
    endif
    " set incremental search
    set incsearch
    "set cursorcolumn
    " set enable folding
    set foldenable
    " set fold method
    set foldmethod=indent
    "set foldcolumn=0
    set foldlevel=20
    "set foldclose=all
    " use mouse
    set mouse=a
    " do not backup
    set nobackup
    " set dictionary
    set dictionary+=~/.vim/dictionary/dictionary
    autocmd filetype verilog setlocal dictionary=~/.vim/dictionary/dictionary_verilog
    autocmd filetype python setlocal dictionary=~/.vim/dictionary/dictionary_python
    " complete words with dot while dictionary completion
    "set iskeyword +=.
    " set local filetype
    "autocmd filetype conf setlocal filetype=tcl
    " add scroll bar on left and bottom
    set guioptions+=Lb
    " hide menu and tool bar
    set guioptions-=T
    set guioptions-=m
    " remember last cursor position
    autocmd BufReadPost *
                \ if line("'\"") > 0 && line("'\"") <= line("$") |
                \ exe "normal g`\"" |
                \ endif
    " set filetype to text if filetype is empty
    autocmd FileWritePost,BufWritePost,BufNewFile,BufReadPost *
            \ if &filetype == "" |
            \ setlocal filetype=text |
            \ endif
    " insert time
    iab xtime <c-r>=strftime("%Y-%m-%d %H:%M:%S")
    " window size when using gvim
    if has("gui_running")
        set lines=800 columns=1600
    endif
    " format programs
    au Filetype python set formatprg=autopep8\ -
    au Filetype perl set formatprg=perltidy

    "====================
    "  plugin settings  "
    "====================
    " "YouCompleteMe"
    let g:ycm_collect_identifiers_from_comments_and_strings = 1
    let g:ycm_key_invoke_completion = '<s-Space>'
    let g:ycm_autoclose_preview_window_after_insertion = 1
    let g:ycm_complete_in_comments = 1

    " "ultisnips"
    let g:UltiSnipsExpandTrigger="<c-j>"
    let g:Perl_Ctrl_j = 'off'
    let g:UltisnipsSnippetsDir="~/.vim/my_snippets"
    let g:UltiSnipsSnippetDirectories=["UltiSnips","my_snippets"]

    " "showmarks"
    let g:showmarks_enable = 1
    let showmarks_include = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    let showmarks_ignore_type = "hqm"
    let showmarks_hlline_lower = 1
    let showmarks_hlline_upper = 0

    " "fuzzyfinder"
    let g:fuf_modesDisable = []
    let g:fuf_mrufile_maxItem = 400
    let g:fuf_mrucmd_maxItem = 400
    map <leader>F :FufFile<CR>
    map <leader>f :FufFileWithFullCwd<CR>
    map <leader>r :FufMruFile<CR>
    map <leader>R :FufRenewCache<CR>
    map <leader>b :FufBuffer<CR>
    nnoremap <silent> <leader>M :call fuf#givencmd#launch('', 0, 'Choose command>', GetAllCommands())<CR>
    nnoremap <silent> <leader>m :call fuf#givencmd#launch('', 0, 'Choose command>', g:fuf_com_list)<CR>
    function! GetAllCommands()
        redir => commands
        silent command
        redir END
        return map((split(commands, "\n")[3:]),
                    \      '":" . matchstr(v:val, ''^....\zs\S*'')')
    endfunction
    let g:fuf_com_list=[':exe "FufBuffer                       " |" 1 ',
                \':exe "FufFileWithCurrentBufferDir     " |" 2 ',
                \':exe "FufFileWithFullCwd              " |" 3 ',
                \':exe "FufFile                         " |" 4 ',
                \':exe "FufCoverageFileChange           " |" 5 ',
                \':exe "FufCoverageFileChange           " |" 6 ',
                \':exe "FufCoverageFileRegister         " |" 7 ',
                \':exe "FufDirWithCurrentBufferDir      " |" 8 ',
                \':exe "FufDirWithFullCwd               " |" 9 ',
                \':exe "FufDir                          " |" 10',
                \':exe "FufMruFile                      " |" 11',
                \':exe "FufMruFileInCwd                 " |" 12',
                \':exe "FufMruCmd                       " |" 13',
                \':exe "FufBookmarkFile                 " |" 14',
                \':exe "FufBookmarkFileAdd              " |" 15',
                \':exe "FufBookmarkFileAddAsSelectedText" |" 16',
                \':exe "FufBookmarkDir                  " |" 17',
                \':exe "FufBookmarkDirAdd               " |" 18',
                \':exe "FufTag                          " |" 19',
                \':exe "FufTag!                         " |" 20',
                \':exe "FufTagWithCursorWord!           " |" 21',
                \':exe "FufBufferTag                    " |" 22',
                \':exe "FufBufferTag!                   " |" 23',
                \':exe "FufBufferTagWithSelectedText!   " |" 24',
                \':exe "FufBufferTagWithSelectedText    " |" 25',
                \':exe "FufBufferTagWithCursorWord!     " |" 26',
                \':exe "FufBufferTagAll                 " |" 27',
                \':exe "FufBufferTagAll!                " |" 28',
                \':exe "FufBufferTagAllWithSelectedText!" |" 29',
                \':exe "FufBufferTagAllWithSelectedText " |" 30',
                \':exe "FufBufferTagAllWithCursorWord!  " |" 31',
                \':exe "FufTaggedFile                   " |" 32',
                \':exe "FufTaggedFile!                  " |" 33',
                \':exe "FufJumpList                     " |" 34',
                \':exe "FufChangeList                   " |" 35',
                \':exe "FufQuickfix                     " |" 36',
                \':exe "FufLine                         " |" 37',
                \':exe "FufHelp                         " |" 38',
                \':exe "FufEditDataFile                 " |" 39',
                \':exe "FufRenewCache                   " |" 40',
                \':exe "FufDir ~/"                        |" 41',
                \':exe "FufFile ~/"                       |" 42',
                \]
    " "airline"
    set laststatus=2
    set t_Co=256
    let g:airline#extensions#whitespace#enabled = 0
    if !exists('g:airline_symbols')
        let g:airline_symbols={}
    endif
    let g:airline_symbols.maxlinenr = ''
    let g:airline_powerline_fonts=1

    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#tab_nr_type = 1
    let g:airline#extensions#tabline#formatter = 'unique_tail'
    let g:airline#extensions#tabline#buffer_idx_mode = 1
    let g:airline#extensions#tabline#excludes = ["\\[fuf\\]"]
    "map <leader>n to select buffer
    nmap <leader>1 <Plug>AirlineSelectTab1
    nmap <leader>2 <Plug>AirlineSelectTab2
    nmap <leader>3 <Plug>AirlineSelectTab3
    nmap <leader>4 <Plug>AirlineSelectTab4
    nmap <leader>5 <Plug>AirlineSelectTab5
    nmap <leader>6 <Plug>AirlineSelectTab6
    nmap <leader>7 <Plug>AirlineSelectTab7
    nmap <leader>8 <Plug>AirlineSelectTab8
    nmap <leader>9 <Plug>AirlineSelectTab9

    " "SingleCompile"
    nmap <F10> :SCCompileRun<CR>
    nmap <S-F10> :SCViewResult<CR>

    " "syntastic"
    let g:syntastic_python_checkers = ['flake8']
    let g:syntastic_python_flake8_args="--ignore=E265,F401,E501"
    let g:syntastic_error_symbol = "✗"
    "let g:syntastic_warning_symbol = "⚠"
    let g:syntastic_warning_symbol = "!"
    let g:syntastic_stl_format = '[%E{Err: %fe #%e}%B{, }%W{Warn: %fw #%w}]'
    highlight SyntasticErrorSign guifg=white guibg=red
    highlight SyntasticWarningSign guifg=yellow

    " "ctrlp"
    let g:ctrlp_show_hidden=1
    let g:ctrlp_working_path_mode = 'c'
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*

    " "vim-viewdoc"
    let g:viewdoc_open='new'
    let g:viewdoc_only=1
    let g:viewdoc_man_cmd="man -a"
    function s:ViewDoc_tcl(topic, ...)
        return { 'cmd': printf('man -M /home/changsongtian/programs/tcl/man %s | col -b', shellescape(a:topic,1)),
            \ 'ft': 'tcl',
            \ }
    endfunction
    let g:ViewDoc_tcl = function('s:ViewDoc_tcl')

    " "indentLine"
    let g:indentLine_enabled=0
    nnoremap <leader>i :IndentLinesToggle<CR>

    " "neocomplete"
    " Disable AutoComplPop.
    let g:acp_enableAtStartup = 0
    " Use neocomplete.
    let g:neocomplete#enable_at_startup = 1
    " Use smartcase.
    let g:neocomplete#enable_smart_case = 1
    " Set minimum syntax keyword length.
    let g:neocomplete#sources#syntax#min_keyword_length = 3
    let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

    " Define dictionary.
    let g:neocomplete#sources#dictionary#dictionaries = {
                \ 'default' : '',
                \ 'vimshell' : $HOME.'/.vimshell_hist',
                \ 'scheme' : $HOME.'/.gosh_completions'
                \ }

    " Define keyword.
    if !exists('g:neocomplete#keyword_patterns')
        let g:neocomplete#keyword_patterns = {}
    endif
    let g:neocomplete#keyword_patterns['default'] = '\h\w*'

    " Plugin key-mappings.
    inoremap <expr><C-g>     neocomplete#undo_completion()
    inoremap <expr><C-l>     neocomplete#complete_common_string()

    " <CR>: close popup and save indent.
    inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
    function! s:my_cr_function()
        return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
        " For no inserting <CR> key.
        "return pumvisible() ? "\<C-y>" : "\<CR>"
    endfunction
    " <TAB>: completion.
    inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
    " <C-h>, <BS>: close popup and delete backword char.
    inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"

    " Enable omni completion.
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

    " Enable heavy omni completion.
    if !exists('g:neocomplete#sources#omni#input_patterns')
        let g:neocomplete#sources#omni#input_patterns = {}
    endif

    " For perlomni.vim setting.
    let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
    let g:neocomplete#data_directory=$USERPROFILE."/.cache/neocomplete"
endif
