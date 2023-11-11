" File: ftemplate.vim
" Author: Kaedenn (kaedenn AT gmail DOT com)
" Version: 1.1.0
"
" The "ftemplate" plugin provides certain file templates to simplify
" repetitive boilerplate. Templates are small ".t" files present in the
" "g:ftemplate_path" directory.
"
" To add a new template for a given language, place the template in the
" "g:ftemplate_path" directory with the filename "<filetype>.t".
"
" You can place arbitrary Vim commands in the file "<filetype>.v" to have
" them execute after the template is loaded. This file is sourced inside of
" a sandbox for safety.
"
" Unless the "g:ftemplate_no_ft" variable exists, this script defines the
" :Ft command that takes an optional argument:
"   :Ft                   invoke FT_Load()
"   :Ft label             invoke FT_Load("label")
"
" Configuration Variables:
"   g:ftemplate_debug     set to display debugging messages
"   g:ftemplate_silent    set to disable info messages
"   g:ftemplate_dir       template directory name (default "ftemplate")
"   g:ftemplate_path      template path (default <script-dir>/<template-dir>)
"   g:ftemplate_no_ft     set to prevent defining the the Ft command
"   g:ftemplate_no_clear  set to prevent clearing the buffer prior to load
"
" Other Variables:
"   g:ftemplate_loaded    set automatically after plugin is loaded
"
" Functions:
"   FT_Load()             load template "<filetype>"
"   FT_Load(label)        load template "<filetype>-<label>"
"   FT_LoadTemplate(name) load named template
"
" Usage:
"   1) Ensure the filetype plugin is enabled:
"     filetype plugin on
"   2) Either open a .py file or :set filetype=python
"   3) Create a template by invoking
"     :FtCreate
"   3) Invoke one of the following:
"     :Ft                 if g:ftemplate_no_ft is not defined
"     :call FT_Load()     otherwise
"
" Planned Features:
"   Create ftemplate directory if it doesn't exist
"   Direct modeline interpretation (to remove the need for .v files)
"   Autocompletion for :Ft commands
 
let g:ftemplate_self = expand("<sfile>:p:h")

unlet! g:ftemplate_loaded

if !exists("g:ftemplate_dir")
  let g:ftemplate_dir = "ftemplate"
endif
if !exists("g:ftemplate_path")
  let g:ftemplate_path = g:ftemplate_self . "/" . g:ftemplate_dir
endif

" Display a debugging message, if debugging is enabled
function! <SID>Debug(msg)
  if exists("g:ftemplate_debug")
    echo "ftemplate: debug: " . a:msg
  endif
endfunction

" Display an informational message, unless disabled
function! <SID>Info(msg)
  if !exists("g:ftemplate_silent")
    echo a:msg
  endif
endfunction

" Clear the current buffer
function! <SID>ClearBuffer()
  if !exists("g:ftemplate_no_clear")
    normal ggdG
  endif
endfunction

" Append a file into the buffer
function! <SID>FillBuffer(filepath)
  let l:failed = append(0, readfile(a:filepath))
  " Remove trailing empty lines
  while line("$") > 1 && getline(line("$")) == ""
    normal Gdd
  endwhile
endfunction

" Execute a template configuration script, if it exists
function! <SID>ExecConfScript(tname)
  if FT_TemplateConfExists(a:tname)
    let l:fpath = FT_GetTemplateConfPath(a:tname)
    for line in readfile(l:fpath)
      sandbox execute line
    endfor
    return v:true
  endif
  return v:false
endfunction

" Get the available templates; returns template names instead of files
function! FT_ListTemplates()
  let l:templates = []
  for l:file in readdir(g:ftemplate_path, {n -> n =~ '.t$'})
    call add(l:templates, strpart(l:file, 0, strlen(l:file)-2))
  endfor
  return l:templates
endfunction

" Get the path to the named template
function! FT_GetTemplatePath(tname)
  return g:ftemplate_path . "/" . a:tname . ".t"
endfunction

" Get the content of the named template variable script
function! FT_GetTemplateConfPath(tname)
  return g:ftemplate_path . "/" . a:tname . ".v"
endfunction

" True if the template file exists, false otherwise
function! FT_TemplateExists(tname)
  return filereadable(FT_GetTemplatePath(a:tname))
endfunction

" True if the template config script exists, false otherwise
function! FT_TemplateConfExists(tname)
  return filereadable(FT_GetTemplateConfPath(a:tname))
endfunction

" Get a template based on the filetype and an optional label
function! FT_GetTemplate(label)
  if &filetype != ""
    let l:tname = &filetype
    if a:label != ""
      return l:tname . "-" . a:label
    endif
    return l:tname
  else
    throw "ftemplate: filetype unset"
  endif
endfunction

" Load the named template into the current buffer
function! FT_LoadTemplate(tname)
  let l:ftfile = FT_GetTemplatePath(a:tname)
  if !FT_TemplateExists(a:tname)
    throw "File " . l:ftfile . " for template " . a:tname . " not found"
  endif
  call <SID>Debug("Loading template " . a:tname . " " . l:ftfile)
  call <SID>ClearBuffer()
  if <SID>FillBuffer(l:ftfile) == 0
    if <SID>ExecConfScript(a:tname)
      call <SID>Info("Template " . a:tname . " loaded with conf script")
    else
      call <SID>Info("Template " . a:tname . " loaded")
    endif
  else
    echoerr "Filling buffer with '" . l:ftfile . "' failed"
  endif
endfunction

" Determine the template based on filetype and call FT_LoadTemplate
function! FT_Load(label="")
  call <SID>Debug("FT_Load('" . a:label . "')")
  try
    let l:tname = FT_GetTemplate(a:label)
    call <SID>Debug("Loading template " . l:tname)
    call FT_LoadTemplate(l:tname)
  catch /filetype unset/
    echoerr "filetype unset; please set or use FtLoad/FT_LoadTemplate"
  endtry
endfunction

" Edit a template based on the current filetype
function! FT_EditTemplate(label="")
  let l:tname = FT_GetTemplate(a:label)
  call FT_EditNamedTemplate(l:tname)
endfunction

" Edit a named template
function! FT_EditNamedTemplate(tname)
  let l:ftfile = FT_GetTemplatePath(a:tname)
  exec "edit " . fnameescape(l:ftfile)
endfunction

if !exists("g:ftemplate_no_ft")
  command! -nargs=? Ft call FT_Load(<q-args>)
  command! -nargs=1 FtLoad call FT_LoadTemplate(<q-args>)
  command! FtList echo "templates:" join(FT_ListTemplates(), " ")

  command! -nargs=? FtEdit call FT_EditTemplate(<q-args>)
  command! -nargs=1 FtEditFor call FT_EditNamedTemplate(<q-args>)
endif

let g:ftemplate_loaded = 1

