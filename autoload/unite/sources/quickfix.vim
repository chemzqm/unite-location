scriptencoding utf-8

function! unite#sources#quickfix#define()
  return s:source
endfunction

let s:source = {
\  "name" : "quickfix",
\  "description" : "output quickfix",
\  "syntax" : "uniteSource__Quickfix",
\  "hooks" : {},
\}

" "converters" : "converter_quickfix_default"

function! s:qflist_to_unite(val)
  let bufnr = a:val.bufnr
  let fname = bufnr == 0 ? "" : bufname(bufnr)
  let line  = bufnr == 0 ? 0 : a:val.lnum
  let col   = bufnr == 0 ? 0 : a:val.col
  let word = fname . '|' . line . ' col ' . col . '| ' . a:val.text
  let is_dummy = 0
  if !len(fname) || !v:val.valid
    let word = a:val.text
    let is_dummy = 1
  endif

  return {
\    "word": word,
\    "kind": ["file", "jump_list"],
\    "is_dummy": is_dummy,
\    "is_multiline": 1,
\    "action__line" : line,
\    "action__col"  : col,
\    "action__path" : fname,
\    }
endfunction

function! s:source.gather_candidates(args, context)

  let qfolder = empty(a:args) ? 0 : a:args[0]
  if qfolder == 0
    return map(getqflist(), "s:qflist_to_unite(v:val)")
  else
    try
      execute "colder" qfolder
      return map(getqflist(), "s:qflist_to_unite(v:val)")
    finally
      execute "cnewer" qfolder
    endtry
  endif
endfunction

function! s:source.hooks.on_syntax(args, context)
  syntax case ignore
  syntax match uniteSource__QuickfixHeader /\v^.*\|\d.*\d\|/
        \ containedin=uniteSource__Quickfix
  syntax match uniteSource__QuickfixName /\v^[^|]+/ contained
        \ containedin=uniteSource__QuickfixHeader
  syntax match uniteSource__QuickfixPosition /\v\|\zs.{-}\ze\|/ contained
        \ containedin=uniteSource__QuickfixHeader

  highlight default link uniteSource__QuickfixName Identifier
  highlight default link uniteSource__QuickfixPosition LineNr

endfunction

function! s:source.hooks.on_close(args, context)
endfunction
