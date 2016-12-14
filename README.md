# Unite-location

Make unite/denite replace quickfix list and lcoation list.

TODO: implementation of refresh

## Motivation

With [denite.nvim](https://github.com/Shougo/denite.nvim), I can do more actions (like filter, convertor),
and they're uniformed, no need to remember more key mapping for navigate or list toggle, for example, you
can add followinng mapping to make your life with list much easier:

``` VimL
nnoremap <silent> <space>p  :<C-u>Denite -resume<CR>
nnoremap <silent> <space>j  :call execute('Denite -resume -select=+'.v:count1.' -immediately')<CR>
nnoremap <silent> <space>k  :call execute('Denite -resume -select=-'.v:count1.' -immediately')<CR>
nnoremap <silent> <space>q  :<C-u>Denite -mode=normal -auto-resize quickfix<CR>
nnoremap <silent> <space>l  :<C-u>Denite -mode=normal -auto-resize location_list<CR>
```

## Install

Take [Vundle](https://github.com/gmarik/vundle) for example:

Add these lines to `.vimrc`

    " should have unite
    Plugin 'Shougo/unite.vim'
    Plugin 'chemzqm/unite-location'

Or use [denite.nvim](https://github.com/Shougo/denite.nvim)

    Plugin 'Shougo/denite.nvim'

Then:

    :so ~/.vimrc
    :BundleInstall

## Usage

``` VimL
" show quickfix list
:Unite quickfix
" or
:Denite quickfix

" show location list
:Unite location_list
" or
:Denite location_list
```

## license

  MIT
