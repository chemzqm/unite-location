scriptencoding utf-8

function! unite#sources#location_list#define()
  return s:source
endfunction

let s:source = {
\  "name" : "location_list",
\  "description" : "output location_list",
\  "syntax" : "uniteSource__LocationList",
\  "hooks" : {},
\}

function! s:source.hooks.on_init(args, context) abort
  let a:context.source__bufname = bufname('%')
endfunction

function! s:location_list_to_unite(val) abort
  let bufnr = a:val.bufnr
  let fname = bufnr == 0 ? "" : bufname(bufnr)
  let line  = bufnr == 0 ? 0 : a:val.lnum
  let col   = bufnr == 0 ? 0 : a:val.col
  let type = 'Warning'
  if a:val.type ==? 'e'
    let type = 'Error'
  endif
  if !len(fname) || !v:val.valid
    let word = a:val.text
    let is_dummy = 1
  else
    let word = fnamemodify(fname, ':t') . '|' . line . ' col ' . col . ' ' . type .  '| ' . a:val.text
    let is_dummy = 0
  endif

  return {
\    "word": word,
\    "source": "location_list",
\    "kind": ["file", "jump_list"],
\    "is_multiline": 1,
\    "is_dummy": is_dummy,
\    "action__line" : line,
\    "action__col"  : col,
\    "action__buffer_nr" : bufnr,
\    "action__path" : fname,
\    }
endfunction

function! s:source.gather_candidates(args, context) abort

  let unite = get(b:, "unite", {})
  let winnr = bufwinnr(a:context.source__bufname)

  let lolder = empty(a:args) ? 0 : a:args[0]
  if lolder == 0
    return map(getloclist(winnr), "s:location_list_to_unite(v:val)")
  else
    try
      execute "lolder" lolder
      return map(getloclist(winnr), "s:location_list_to_unite(v:val)")
    finally
      execute "lnewer" lolder
    endtry
  endif
endfunction

function! s:source.hooks.on_syntax(args, context) abort
  syntax case ignore
  syntax match uniteSource__LocationListHeader /\v^.*\|\d.*\|/
        \ containedin=uniteSource__LocationList
  syntax match uniteSource__LocationListName /\v^[^|]+/ contained
        \ containedin=uniteSource__LocationListHeader
  syntax match uniteSource__LocationListPosition /\v\|\zs.{-}\ze\|/ contained
        \ containedin=uniteSource__LocationListHeader
  syntax match uniteSource__LocationListError /\vError/ contained
        \ containedin=uniteSource__LocationListPosition
  syntax match uniteSource__LocationListWarning /vWarning/ contained
        \ containedin=uniteSource__LocationListPosition

  highlight default link uniteSource__LocationListWarning Statement
  highlight default link uniteSource__LocationListError Error
  highlight default link uniteSource__LocationListName Identifier
  highlight default link uniteSource__LocationListPosition LineNr

endfunction

function! s:source.hooks.on_close(args, context)
  let a:context.source__bufname = ''
endfunction

