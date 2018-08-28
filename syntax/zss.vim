if exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

syn match zssAttribute contained "[a-zA-Z_][0-9a-zA-Z]*"
syn match zssValueString contained "[a-zA-Z_][0-9a-zA-Z]*"
syn match zssValueNumber contained "\(-\|+\)\?\(\([0-9]\+\.[0-9]*\)\|\([0-9]*\.[0-9]\+\)\|\([0-9]\+\)\)"
syn match zssValueHexNumber contained "#[0-9a-zA-Z]\{6,8\}"
syn region zssBlock start="{" end="}" transparent fold
syn region zssAngleBlock start="<" end=">" transparent fold
syn region zssComment start="/\*" end="\*/" contains=@Spell fold
syn region zssCommentL start="//" skip="\\$" end="$" contains=@Spell fold
syn match zssSelectorCmp "[!]\?=\|[<>]=\?" contained
syn region zssString start=+\(L\|u\|u8\|U\|R\|LR\|u8R\|uR\|UR\)\="+ skip=+\\\\\|\\"+ end=+"+ contains=@Spell extend
syn region zssAttributeSelector start="\[" end="]" contains=zssString,zssAttribute,zssValueNumber,zssValueHexNumber,zssSelectorCmp
syn region zssAttributeValueRegion start=":" end=";" contains=zssValueNumber,zssValueString,zssValueHexNumber,zssString contained containedin=zssBlock
syn region zssAngleAttributeValueRegion start=":" end=";" contains=zssValueNumber,zssValueString,zssValueHexNumber,zssString contained containedin=zssAngleBlock


" Highlighting
hi def link zssCommentL zssComment
hi def link zssValueHexNumber zssValueNumber

hi def link zssComment Comment
hi def link zssAttribute Function
hi def link zssString String
hi def link zssSelectorCmp Special
hi def link zssValueString Constant
hi def link zssValueNumber Constant

let b:current_syntax = "zss"

let &cpo = s:cpo_save
unlet s:cpo_save
