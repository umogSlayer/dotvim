if !has('nvim')
    unlet! skip_defaults_vim
    source $VIMRUNTIME/defaults.vim
endif

set guicursor=
set background=dark
set nocp
set smartindent
filetype plugin on
colorscheme sonokai

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

"nmap <F8> :TagbarToggle<CR>
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

let g:ycm_language_server =
    \  [
    \    {
    \      'name': 'haskell',
    \      'cmdline': ['hie-wrapper'],
    \      'filetypes': ['haskell', 'hsl', 'hs'],
    \      'project_root_files': ['stack.yaml'],
    \    }
    \  ]
let g:ycm_semantic_triggers = {
    \   'haskell': ['.'],
    \ }

let g:clang_tidy_path_to_build_dir = "/home/umogslayer/OnyxCorp/build-desktop-clang"
let g:clang_tidy_executable = "clang-tidy"

let g:vimspector_enable_mappings = 'HUMAN'

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
	if l:filename =~ '\.\(cpp\|cxx\|cc\|c\|h\|hpp\|hxx\)$'
		call ClangTidyImpl(g:clang_tidy_executable . " -p " . g:clang_tidy_path_to_build_dir . " " . l:filename)
	elseif exists("g:clang_tidy_last_cmd")
		call ClangTidyImpl(g:clang_tidy_last_cmd)
	else
		echo "Can't detect file's compilation arguments and no previous clang-tidy invocation!"
	endif
endfunction
command ClangTidy call ClangTidy()

function! ClangTidyFix()
	let l:filename = expand('%')
	if l:filename =~ '\.\(cpp\|cxx\|cc\|c\|h\|hpp\|hxx\)$'
		call ClangTidyImpl(g:clang_tidy_executable . " -p " . g:clang_tidy_path_to_build_dir . " --fix " . l:filename)
	elseif exists("g:clang_tidy_last_cmd")
		call ClangTidyImpl(g:clang_tidy_last_cmd)
	else
		echo "Can't detect file's compilation arguments and no previous clang-tidy invocation!"
	endif
endfunction
command ClangTidyFix call ClangTidyFix()

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

let g:fzf_command_prefix = 'FzF'

nnoremap <leader>t :FzFFiles 

" YouCompleteMe wants it for some reason
set encoding=utf-8

" Custom language-based initialization

" C/C++
let g:cpp_initialized = 0
function! s:InitializeCpp() abort
    compiler ninja

    if g:cpp_initialized == 1
        return
    endif

    let g:cpp_initialized = 1
    " set makeprg=env\ LANG=en_US.UTF8\ make
    packadd YouCompleteMe
    packadd vimspector
    nnoremap <leader>yj :YcmCompleter GoTo<CR>
    nnoremap <leader>yf :YcmCompleter GoToReferences<CR>
    " nnoremap <leader>ys :YcmCompleter GoToSymbol 
    nnoremap <leader>ys <Plug>(YCMFindSymbolInWorkspace)
endfunction

" Rust
let g:rust_initialized = 0
function! s:InitializeRust() abort
    compiler cargo

    if g:rust_initialized == 1
        return
    endif

    let g:rust_initialized = 1
    " set makeprg=env\ LANG=en_US.UTF8\ make
    packadd YouCompleteMe
    packadd vimspector
    nnoremap <leader>yj :YcmCompleter GoTo<CR>
    nnoremap <leader>yf :YcmCompleter GoToReferences<CR>
    nnoremap <leader>ys :YcmCompleter GoToSymbol 
endfunction

" Python
let g:python_initialized = 0
function! s:InitializePython() abort
    if g:python_initialized == 1
        return
    endif

    let g:python_initialized = 1
    " set makeprg=env\ LANG=en_US.UTF8\ make
    packadd YouCompleteMe
    nnoremap <leader>yj :YcmCompleter GoTo<CR>
    nnoremap <leader>yf :YcmCompleter GoToReferences<CR>
    nnoremap <leader>ys :YcmCompleter GoToSymbol 
endfunction

let g:rustfmt_autosave = 1

" Auto initialize stuff
if !has('nvim')
    autocmd FileType cmake call s:InitializeCpp()
    autocmd FileType c call s:InitializeCpp()
    autocmd FileType cpp call s:InitializeCpp()
    autocmd FileType rust call s:InitializeRust()
    autocmd FileType python call s:InitializePython()
    autocmd FileType cs call s:InitializeCsharp()
    command! Format YcmCompleter Format
else
    set completeopt+=menuone,noinsert,popup
    nnoremap <leader>yj :lua vim.lsp.buf.definition()<CR>
    nnoremap <leader>yf :lua vim.lsp.buf.references()<CR>
    nnoremap <leader>yd :lua vim.diagnostic.open_float()<CR>
    nnoremap <leader>yt :ClangdSwitchSourceHeader<CR>
    command! Format lua vim.lsp.buf.format()
    autocmd FileType c,cpp,cmake compiler ninja
    autocmd FileType rust compiler cargo
    lua <<EOF
    vim.lsp.config['cppls'] = {
        cmd = { "clangd", "--background-index", "--clang-tidy", "--malloc-trim" },
        filetypes = { 'c', 'cpp' },
        root_markers = { 'compile_commands.json', '.clangd' },
    }
    vim.lsp.config['rustls'] = {
        cmd = { "rust-analyzer" },
        filetypes = { 'rust' },
        root_markers = { 'Cargo.toml' },
    }
    vim.lsp.config['pythonls'] = {
        cmd = { "pylsp" },
        filetypes = { 'python' },
    }
    vim.lsp.config['qmlls'] = {
        cmd = { "qmlls6" },
        filetypes = { 'qml' },
        root_markers = { '.qmlls.ini' },
    }
    vim.lsp.enable({ 'cppls', 'rustls', 'pythonls' })

    group = vim.api.nvim_create_augroup('umogslayer.lsp', { clear = true }),
    vim.api.nvim_create_autocmd('LspAttach', {
        callback = function (args)
            local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
            client.server_capabilities.semanticTokensProvider = nil
            vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
        end,
        group = 'umogslayer.lsp',
    })
    vim.api.nvim_create_autocmd('CursorHold', {
        pattern = '*',
        callback = function ()
            for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
                if vim.api.nvim_win_get_config(winid).zindex then
                    return
                end
            end
            vim.diagnostic.open_float(0, {
                scope = 'cursor',
                focusable = false,
                close_events = {
                    "CursorMoved",
                    "CursorMovedI",
                    "BufHidden",
                    "InsertCharPre",
                    "WinLeave",
                },
            })
        end,
        group = 'umogslayer.lsp',
    })
EOF
endif

" C#
" Use the stdio OmniSharp-roslyn server
let g:OmniSharp_server_stdio = 0

" Set the type lookup function to use the preview window instead of echoing it
"let g:OmniSharp_typeLookupInPreview = 1

" Timeout in seconds to wait for a response from the server
let g:OmniSharp_timeout = 5

" Fetch full documentation during omnicomplete requests.
" By default, only Type/Method signatures are fetched. Full documentation can
" still be fetched when you need it with the :OmniSharpDocumentation command.
let g:omnicomplete_fetch_full_documentation = 1

" Tell ALE to use OmniSharp for linting C# files, and no other linters.
let g:ale_linters = { 'cs': ['OmniSharp'] }

" Update semantic highlighting on BufEnter, InsertLeave and TextChanged
let g:OmniSharp_highlight_types = 2

let g:csharp_initialized = 0
function! s:SetCsharpMappings() abort
    " The following commands are contextual, based on the cursor position.
    nnoremap <buffer> <Leader>gd :OmniSharpGotoDefinition<CR>
    nnoremap <buffer> <Leader>fi :OmniSharpFindImplementations<CR>
    nnoremap <buffer> <Leader>fs :OmniSharpFindSymbol<CR>
    nnoremap <buffer> <Leader>fu :OmniSharpFindUsages<CR>

    " Finds members in the current buffer
    nnoremap <buffer> <Leader>fm :OmniSharpFindMembers<CR>

    nnoremap <buffer> <Leader>fx :OmniSharpFixUsings<CR>
    nnoremap <buffer> <Leader>tt :OmniSharpTypeLookup<CR>
    nnoremap <buffer> <Leader>dc :OmniSharpDocumentation<CR>
    nnoremap <buffer> <C-\> :OmniSharpSignatureHelp<CR>
    inoremap <buffer> <C-\> <C-o>:OmniSharpSignatureHelp<CR>

    " Navigate up and down by method/property/field
    nnoremap <buffer> <C-k> :OmniSharpNavigateUp<CR>
    nnoremap <buffer> <C-j> :OmniSharpNavigateDown<CR>

    " Find all code errors/warnings for the current solution and populate the quickfix window
    nnoremap <buffer> <Leader>cc :OmniSharpGlobalCodeCheck<CR>
endfunction
function! s:InitializeCsharp() abort
    if g:csharp_initialized == 1
        return
    endif
    let g:csharp_initialized = 1

    " Don't autoselect first omnicomplete option, show options even if there is only
    " one (so the preview documentation is accessible). Remove 'preview', 'popup'
    " and 'popuphidden' if you don't want to see any documentation whatsoever.
    " Note that neovim does not support `popuphidden` or `popup` yet: 
    " https://github.com/neovim/neovim/issues/10996
    set completeopt=longest,menuone,preview,popuphidden

    " Highlight the completion documentation popup background/foreground the same as
    " the completion menu itself, for better readability with highlighted
    " documentation.
    set completepopup=highlight:Pmenu,border:off

    " Set desired preview window height for viewing documentation.
    " You might also want to look at the echodoc plugin.
    set previewheight=5

    augroup omnisharp_commands
        autocmd!

        " Show type information automatically when the cursor stops moving.
        " Note that the type is echoed to the Vim command line, and will overwrite
        " any other messages in this space including e.g. ALE linting messages.
        autocmd CursorHold *.cs OmniSharpTypeLookup

        autocmd FileType cs call s:SetCsharpMappings()
    augroup END

    call s:SetCsharpMappings()

    " Contextual code actions (uses fzf, CtrlP or unite.vim when available)
    nnoremap <Leader><Space> :OmniSharpGetCodeActions<CR>
    " Run code actions with text selected in visual mode to extract method
    xnoremap <Leader><Space> :call OmniSharp#GetCodeActions('visual')<CR>

    " Rename with dialog
    nnoremap <Leader>nm :OmniSharpRename<CR>
    nnoremap <F2> :OmniSharpRename<CR>
    " Rename without dialog - with cursor on the symbol to rename: `:Rename newname`
    command! -nargs=1 Rename :call OmniSharp#RenameTo("<args>")

    nnoremap <Leader>cf :OmniSharpCodeFormat<CR>

    " Start the omnisharp server for the current solution
    nnoremap <Leader>ss :OmniSharpStartServer<CR>
    nnoremap <Leader>sp :OmniSharpStopServer<CR>
endfunction

packadd matchit

" Copy-paste configuration
if 0
    " Change default delete (i.e. cut) to 'x' button
    nnoremap x d
    xnoremap x d

    nnoremap xx dd
    nnoremap X D

    " Integrate yoink with cutlass
    let g:yoinkIncludeDeleteOperations = 1

    " yoink configuration
    nmap <leader>yn <plug>(YoinkPostPasteSwapBack)
    nmap <leader>yp <plug>(YoinkPostPasteSwapForward)

    nmap p <plug>(YoinkPaste_p)
    nmap P <plug>(YoinkPaste_P)

    " subverse configuration
    nmap s <plug>(SubversiveSubstitute)
    nmap ss <plug>(SubversiveSubstituteLine)
    nmap S <plug>(SubversiveSubstituteToEndOfLine)

    nmap <leader>s <plug>(SubversiveSubstituteRange)
    xmap <leader>s <plug>(SubversiveSubstituteRange)

    nmap <leader>ss <plug>(SubversiveSubstituteWordRange)
endif

let g:is_bash = 1
