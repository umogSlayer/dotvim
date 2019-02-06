runtime bundle/vim-pathogen/autoload/pathogen.vim

set background=dark
set nocp
set smartindent
filetype plugin on

imap <C-K><C-K> <ESC><leader>c i
vmap <C-K><C-K> <leader>c 
nmap <C-K><C-K> <leader>c 
vmap <C-K><C-L> <leader>cc

autocmd FileType cmake set omnifunc=cmakecomplete#Complete

let &cinoptions .= "(0,W2s"

"set foldenable
"set foldmethod=syntax
"set foldcolumn=2
"set foldlevel=1

set expandtab
set shiftwidth=4
set tabstop=4
set incsearch
set hlsearch

" let g:ycm_min_num_of_chars_for_completion = 99
" let g:ycm_collect_identifiers_from_tags_files = 1

command SetGLSLFileType call SetGLSLFileType()
function SetGLSLFileType()
  for item in getline(1,10)
    if item =~ "#version 400"
      execute ':set filetype=glsl400'
      break
    elseif item =~ "#version 330"
      execute ':set filetype=glsl330'
      break
    else
      execute ':set filetype=glsl330'
      break
    endif
  endfor
endfunction
au BufNewFile,BufRead *.frag,*.vert,*.fp,*.vp,*.glsl SetGLSLFileType
if has('gui_running')
  set guifont=DejaVu\ Sans\ Mono\ 10
endif

set makeprg=env\ LANG=en_US.UTF8\ make

filetype off

call pathogen#infect()
call pathogen#helptags()

set fileencodings=ucs-bom,utf-8,default,cp1251,latin1

au BufNewFile,BufRead *.hqt setf cpp

filetype plugin indent on
syntax on

" highlight
autocmd ColorScheme * highlight MyExtraWhitespace ctermbg=red guibg=lightred
highlight MyExtraWhitespace ctermbg=red guibg=lightred
match MyExtraWhitespace /\s\+$/
autocmd BufWinEnter * match MyExtraWhitespace /\s\+$/
autocmd InsertEnter * match MyExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match MyExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" visualize whitespace
set listchars=tab:>-,trail:~,extends:>,precedes:<
set list
autocmd BufWinEnter * set list

nmap <F8> :TagbarToggle<CR>
"map <C-P> \t
let g:CommandTWildIgnore=&wildignore . ",**/boost/**,**/thirdparty/**,**/out_*/**,**/android/**"

set grepprg=ag\ --vimgrep\ $*
set grepformat=%f:%l:%c:%m

let g:load_doxygen_syntax=1

" rtags bindings
let g:rtagsUseDefaultMappings = 1
let g:rtagsUseLocationList = 0

let g:pymode_rope = 0
let g:pymode_rope_completion = 0
let g:pymode_lint = 1

let g:ycm_rust_src_path = "/home/umogslayer/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src"

let g:clang_tidy_path_to_build_dir = "/home/umogslayer/zenith/out_clang_stdc++/out/Debug"
let g:clang_tidy_executable = "clang-tidy-4.0.1"

"function! ClangTidyImpl(cmd)
	"if &autowrite | wall | endif
	"echo "Running " . a:cmd . " ..."
	"let l:output = system(a:cmd)
	"cexpr l:output
	"cwindow
	"let w:quickfix_title = a:cmd
	"if v:shell_error != 0
		"cc
	"endif
	"let g:clang_tidy_last_cmd = a:cmd
"endfunction

function! ClangTidyUpdateQuickFix(channel)
	"echo "Results of " . g:clang_tidy_last_cmd
	echo g:clang_tidy_current_task
	let w:quickfix_title = g:clang_tidy_current_task["quickfix_title"]
	let l:quickfix_buffer = g:clang_tidy_current_task["quickfix_buffer"]
	exec "cbuffer " . l:quickfix_buffer
	cwindow

	unlet g:clang_tidy_current_task
endfunction

function! ClangTidyImpl(cmd)
	if &autowrite | wall | endif
	echo "Running " . a:cmd . " ..."

	if exists("g:clang_tidy_current_task")
		call job_stop(g:clang_tidy_current_task["job"])
	endif
	let l:job = job_start(a:cmd, {"in_io": "null", "out_io": "buffer", "err_io": "out", "close_cb": "ClangTidyUpdateQuickFix"})
	let g:clang_tidy_current_task = {
		\ "job": l:job,
		\ "quickfix_title": a:cmd,
		\ "quickfix_buffer": ch_getbufnr(job_getchannel(l:job), "out"),
		\ }

	let g:clang_tidy_last_cmd = a:cmd
endfunction


function! ClangTidy()
	let l:filename = expand('%')
	if l:filename =~ '\.\(cpp\|cxx\|cc\|c\)$'
		call ClangTidyImpl(g:clang_tidy_executable . " -p " . g:clang_tidy_path_to_build_dir . " " . l:filename)
	elseif exists("g:clang_tidy_last_cmd")
		call ClangTidyImpl(g:clang_tidy_last_cmd)
	else
		echo "Can't detect file's compilation arguments and no previous clang-tidy invocation!"
	endif
endfunction

command ClangTidy call ClangTidy()

"map <S-C> :VBGcontinue<CR>
"map <C-B> :VBGtoggleBreakpointThisLine<CR>
"map <C-N> :VBGstepOver<CR>
"map <S-A> :VBGrawWrite info args<CR>
"map <S-L> :VBGrawWrite info local<CR>
"map <S-S> :VBGstepIn<CR>

let g:vebugger_leader='<Leader>d'

let g:neomake_place_signs = 0

let g:airline_solarized_bg = 'dark'

set shell+=\ -O\ globstar

let g:workspace_autosave = 0
let g:workspace_autosave_untrailspaces = 0
let g:workspace_session_disable_on_args = 1

nnoremap <leader>w :ToggleWorkspace<CR>
