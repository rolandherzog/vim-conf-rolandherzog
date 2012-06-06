" We set some latex specific settings here
" ----------------------------------------

" Debug mode
" let g:Tex_Debug = 1
" let g:Tex_DebugLog = "/tmp/vim-latex-suite.log"

" Customization of environment labels
let g:Tex_EnvLabelprefix_assumption = "assumption:"
let g:Tex_EnvLabelprefix_definition = "definition:"
let g:Tex_EnvLabelprefix_lemma = "lemma:"
let g:Tex_EnvLabelprefix_remark = "remark:"
let g:Tex_EnvLabelprefix_theorem = "theorem:"
let g:Tex_EnvLabelprefix_corollary = "corollary:"

let g:Tex_EnvLabelprefix_align = "eq:"
let g:Tex_EnvLabelprefix_equation = "eq:"
let g:Tex_EnvLabelprefix_subequations = "eq:"

" Use custom placeholders (which do not collide with LaTeX beamer <1-> etc.)
let g:Imap_PlaceHolderStart = '<<+'
let g:Imap_PlaceHolderEnd = '+>>'

" Place labels before content
let g:Tex_LabelAfterContent = 0

" Environments should end in <CR><++>
let g:Tex_EnvEndWithCR = 1

" WORK HERE
"call s:Tex_EnvMacros('FRA', '&Structure.', 'myframebox')

" things associated with for forward search
let g:Tex_DefaultTargetFormat = 'pdf'
let g:Tex_ViewRule_pdf = 'synctex_wrapper'
" let g:Tex_ViewRule_pdf = 'okular'

" make grep always generate a file name 
set grepprg=grep\ -nH\ $*
" do not spell-check in tex comments
let g:tex_comment_nospell=1

" Change the shiftwidth
set tabstop=2
set shiftwidth=2

" Set $BIBINPUTS
let g:Tex_BIBINPUTS = $HOME."/Work/Resources/Bibliography/,".$HOME."/Work/Projects/200910_SPP1253_Plasticity/Resources/"

" no Tex-Menus
let g:Tex_Menus = 0

" Do not fold any Environments.
let g:Tex_FoldedEnvironments = ''

" Do not fold \item
let g:Tex_FoldedMisc = 'preamble,<<<'


" Some key mappings
" -----------------------------------------------
:cnoremap <space> <C-R>=Replace_space()<CR>
"" Replace spaces in search to map also line breaks
function! Replace_space()
	let cmdtype = getcmdtype()
	if cmdtype == '/' || cmdtype == '?'
		return "\\_s*"
	else
		return " "
	endif
endfunction

:cnoremap <backspace> <C-R>=Replace_backspace()<CR>
"" Replace backspaces in search to delete "\_s*"
function! Replace_backspace()
	let cmdtype = getcmdtype()
	if (cmdtype == '/' || cmdtype == '?')
		let cmdline = getcmdline()
		let cmdpos = getcmdpos()
		if ( cmdline[cmdpos-5 : cmdpos-2] == "\\_s*" )
			return ""
		else
			return ""
		endif
	else
		return ""
	endif
endfunction

noremap <silent> <c-n> :call ToggleCurrent()<CR>
"" Toogle [label=current] in beamer.
function! ToggleCurrent()
	let line = getline('.')
	if ( line =~ "^\\s*\\\\begin{frame}.*\\[label=\\w*\\]$" )
		normal ^f[D
	elseif ( line =~ "^\\s*\\\\begin{frame}")
		normal A[label=current]
	else
		" call search("^\\s*\\\\begin{frame}")
	endif
endfunction

"" Move to next / previous frame
" noremap <silent> <c-j> :call search("^\\s*\\\\begin{frame}")<cr>
" noremap <silent> <c-k> k:call search("^\\s*\\\\begin{frame}",'cb')<cr>


" Set path for exercises
if ( getcwd() =~ "work/Teaching/" )
	set path+=~/work/Teaching/Exercises
endif

" Set path for plasticity
if ( getcwd() =~ "Projects/Plasticity" )
	set path+=~/work/Projects/Plasticity/Resources
endif

" Configure environments for F5:
let g:Tex_Env_block = "\\begin{block}{<++>}\<CR><++>\<CR>\\end{block}"
let g:Tex_Env_frame = "\\begin{frame}\<CR>\\frametitle{<++>}\<CR><++>\<CR>\\end{frame}"

" Begin inline math objects by Gerd Wachsmuth
" ---------------------------------------------
"" Inline-math text objects (similar to "aw" [a word] and "iw" [inner word])
" a$ selects / use including limiting $
" i$ selects / use excluding limiting $
" BUG / FEATURE:
" If you have "$1+1$ here is the cursor $2+2$", then "da$" results in "$1+12+2$"
onoremap <silent> i$ :<c-u>normal! T$vt$<cr>
onoremap <silent> a$ :<c-u>normal! F$vf$<cr>
vnoremap <silent> i$ :<c-u>normal! T$vt$<cr>
vnoremap <silent> a$ :<c-u>normal! F$vf$<cr>

" Text objects corresponding to latex environments
onoremap <silent>ae :<C-u>call LatexEnvironmentTextObject(0)<CR>
onoremap <silent>ie :<C-u>call LatexEnvironmentTextObject(1)<CR>
vnoremap <silent>ae :<C-u>call LatexEnvironmentTextObject(0)<CR>
vnoremap <silent>ie :<C-u>call LatexEnvironmentTextObject(1)<CR>

function! LatexEnvironmentTextObject(inner)
let b:my_count = v:count
let b:my_inner = a:inner

let startstring = '\\begin{\w*\*\?}'
let endstring = '\\end{\w*\*\?}\zs'
let skipexpr = ''

" Determine start of environment
call searchpair(startstring, '', endstring, 'bcW', skipexpr)
for i in range( v:count1 - 1)
call searchpair(startstring, '', endstring, 'bW', skipexpr)
endfor

" Start selecting
normal! V

" Determine end of environment
" normal! ^
call searchpair(startstring, '', endstring, 'W', skipexpr)
normal! ^

if a:inner == 1
normal! ojok
end

endfunction


