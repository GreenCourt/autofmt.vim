aug format_on_bufwritepre
  au!
  if executable("clang-format")
    au BufWritePre *.c,*.h call s:format("clang-format")
  endif
  if executable("rustfmt")
    au BufWritePre *.rs call s:format("rustfmt")
  endif
  if executable("ruff")
    au BufWritePre *.py call s:format("ruff format -")
  endif
aug END

function s:format(cmd)
  let l:cur = getline(0, "$")
  let l:new = systemlist(a:cmd, join(l:cur, "\n"))
  if v:shell_error | return | endif
  if l:cur == l:new | return | endif
  let l:view = winsaveview()
  if line('$') > len(l:new) | execute len(l:new) .',$delete' | endif
  call setline(1, l:new)
  call winrestview(l:view)
endfunction
