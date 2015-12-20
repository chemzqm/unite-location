# Unite-location

Make unite replace quickfix list and lcoation list.

TODO: implementation of refresh

## Motivation

With [Unite](https://github.com/Shougo/unite.vim), I can do more actions (like filter, convertor), and they're uniformed, no need to remember more key mapping for navigate or list toggle, for example, you can add followinng mapping to make your life with list much easier:

``` VimL
" Toggle Unite by `<space>u`
function! s:ToggleUnite()
  for i in range(1, winnr('$'))
    let name = bufname(winbufnr(i))
    if match(name, '^\[unite\]') == 0
      UniteClose
      return
    endif
  endfor
  UniteResume
endfunction

nmap <silent> <space>u :call <SID>ToggleUnite()<cr>

" Easily jump between candidates by `[count]<space>j` and `[count]<space>k`
nmap <space>j :<C-u>call <SID>Jump(v:count1, 'Next')<cr>
nmap <space>k :<C-u>call <SID>Jump(v:count1, 'Previous')<cr>

function! s:Jump(count, dir)
  execute a:count . 'Unite' . a:dir
endfunction
```

## Install

Take [Vundle](https://github.com/gmarik/vundle) for example:

Add these lines to `.vimrc`

    " should have unite
    Plugin 'Shougo/unite.vim'
    Plugin 'chemzqm/unite-location'

Then:

    :so ~/.vimrc
    :BundleInstall

## Usage

``` VimL
" show quickfix list
:Unite quickfix

" show location list
:Unite location_list
```

## license

  MIT
