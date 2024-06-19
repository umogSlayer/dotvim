if exists("current_compiler")
	finish
endif
runtime compiler/ninja.vim

let current_compiler = "qml"

let s:cpo_save = &cpo
set cpo&vim

let s:base_errorformat = &errorformat

exec "CompilerSet errorformat=" .
    \ escape("%trror compiling qml file: %f:%l:%c: %m,", ' ') .
    \ escape("%trror compiling js file: %f:%l:%c: %m,", ' ') .
    \ escape("%trror: %f:%l:%c: %m,", ' ') .
    \ escape("%tarning: %f:%l:%c: %m,", ' ') .
    \ escape("%tnfo: %f:%l:%c: %m,", ' ') .
    \ escape(s:base_errorformat, " '\"\\")

let &cpo = s:cpo_save
unlet s:cpo_save

