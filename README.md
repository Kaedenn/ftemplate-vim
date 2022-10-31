# File Templates for Vim

## Simple usage

1) Create a template:
````
:set filetype=python
:FtCreate
" write whatever template code you want
:wq
```

2) Create a new file and load the template:
```
:set filetype=python
:Ft
```

## Installation

Clone this repository to your vim plugins directory
```
cd ~/.vim/plugin
git clone git@github.com:/Kaedenn/vim-ftemplate
```

This plugin relies heavily on the filetype plugin. You can enable that by adding
```
filetype plugin on
```
to your `~/.vimrc`.

## Creating templates

Templates are stored in the `g:ftemplate_path` directory, which defaults to `<plugin-dir>/ftemplate`, where `<plugin-dir>` is the directory containing `ftemplate.vim`.

Templates have the extension `.t`. For example, the default Python template would be named `python.t`.

Named templates are also supported.

To edit (or create) a template for the current filetype, invoke `:FtEdit`.

To edit (or create) a named template for the current filetype, invoke `:FtEdit <name>`.

To edit (or create) a specific template without using the filetype, invoke `:FtEditFor <template>`. Note that the `.t` extension is added automatically.

## Listing templates

Invoke `:FtList` to list the available templates.

## Using templates

To load the default template for the current filetype, invoke `:Ft`.

To load a named template for the current filetype, invoke `:Ft <name>`.

To load a specific template without using the filetype, invoke `:FtLoad <template>`. Note that the `.t` extension is added automatically.

## Template configuration scripts

You can place additional commands in a file with the extension `.v`. This file must have the same name as the `.t` file it references, but with the extension `.v`. If this file exists, then it is executed (in a `sandbox`) after its template is loaded.

## Variables

| Variable | Default | Purpose |
| -------- | ------- | ------- |
| `g:ftemplate_debug` | unset | Set to enable debugging messages |
| `g:ftemplate_silent` | unset | Set to disable informational messages |
| `g:ftemplate_dir` | `ftemplate` | Template directory name |
| `g:ftemplate_path` | `<script-dir>/<template-dir>` | Set to override path to the templates |
| `g:ftemplate_no_ft` | unset | Set to disable the :Ft commands |
| `g:ftemplate_no_clear` | unset | Set to disable clearing the buffer prior to loading a template |
| `g:ftemplate_loaded` | unset | This is set automatically once the `ftemplate.vim` plugin has finished loading |




