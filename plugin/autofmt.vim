let g:rustfmt_autosave = get(g:, "rustfmt_autosave", 1)

aug format_on_bufwritepre
  au!
  if executable("clang-format") && (filereadable(".clang-format") || filereadable("_clang-format"))
    au BufWritePre *.c,*.h,*.cc,*.cpp,*.hpp call s:format("clang-format")
  endif
  if executable("ruff")
    au BufWritePre *.py call s:format("ruff format --no-cache -")
  endif
aug END

function s:format(cmd) abort
  redraw | echo "formatting..."
  let l:cur = getline(0, "$")
  let l:new = systemlist(a:cmd, join(l:cur, "\n"))
  if v:shell_error | return | endif
  if l:cur == l:new | return | endif
  let l:view = winsaveview()
  if line('$') > len(l:new) | execute len(l:new) .',$delete' | endif
  call setline(1, l:new)
  call winrestview(l:view)
  redraw
endfunction
