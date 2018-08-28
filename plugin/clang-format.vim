
" This is basic vim plugin boilerplate
let s:save_cpo = &cpo
set cpo&vim

if exists("g:loaded_clang_format")
	call s:restore_cpo()
	finish
endif

let g:loaded_clang_format = 1

function! s:restore_cpo()
  let &cpo = s:save_cpo
  unlet s:save_cpo
endfunction

let s:path = expand('<sfile>:p:h') . "/../clang-format/clang-format.py"

function! s:RunClangFormat() range abort
	let exec_string = a:firstline . ',' . a:lastline . 'pyfile ' . s:path
	exec exec_string
endfunction

command! -range=% ClangFormat <line1>,<line2>call s:RunClangFormat()

" This is basic vim plugin boilerplate
call s:restore_cpo()
