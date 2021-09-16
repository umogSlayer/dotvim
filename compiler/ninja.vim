if exists("current_compiler")
	finish
endif
runtime compiler/gcc.vim

let current_compiler = "ninja"

let s:cpo_save = &cpo
set cpo&vim

CompilerSet makeprg=ninja

let &cpo = s:cpo_save
unlet s:cpo_save
