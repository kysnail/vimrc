""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Encoding
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,chinese


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Font and scheme
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 用于语法高亮的配色方案
colorscheme evening
" colorscheme torte

" 设置 gvim 显示字体
" 1. YaHei Consolas Hybrid ，这个字体需要单另安装。对于中文字体，我有种无语的感觉。
" set guifont=YaHei_Consolas_Hybrid:h12
" 2. 编程字体
" set guifont=Dejavu\ Sans\ Mono\ 12
" set guifont=Lucida\ Sans\ Typewriter\ 12
" 3. 日文环境下默认可以使用的中文字体
" set guifont=NSimSun:h12
 
" 开启语法高亮
syntax enable

" 允许用指定语法高亮配色方案替换默认方案
syntax on

" 设置 tab 宽度
set tabstop=4

" 设置行号
set nu

" Number of spaces to use for each step of (auto)indnt. Used for 'cindent',
" >>, << etc.
set shiftwidth=4

" When on, lines longer than the width of the window will wrap and displaying
" continues on the next line.
set nowrap

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM map
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set mapleader
" This variable will affect all fllowing mapping.
let mapleader = ","



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Develop Environment
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Execute project related configuration in current directory
if filereadable("workspace.vim")
	source workspace.vim
endif



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Custom Function
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Determine platform
function! MySys()
	if has("win32")
		return "windows"
	else
		return "linux"
	endif
endfunction

" Create a new buffer to edit file
function! SwitchToBuf(filename)
	" let fullfn = substitute(a:filename, "^\\~/", $HOME . "/", "")
	" find in current tab
	let bufwinnr = bufwinnr(a:filename)
	if bufwinnr != -1
		" 'Ctrl-w w' => 'wincmd w'
		exec bufwinnr . "wincmd w"
		return
	else
		" find in each tab
		tabfirst
		let tab = 1
		while tab <= tabpagenr("$")
			let bufwinnr = bufwinnr(a:filename)
			if bufwinnr != -1
				exec "normal " . tab . "gt"
				exec bufwinnr . "wincmd w"
				return
			endif
			tabnext
			let tab = tab + 1
		endwhile

		" Doesn't exist, new tab
		exec "tabnew " . a:filename
	endif
endfunction

" Fast edit vimrc
if MySys() == 'linux'
	" Fast reloading of the .vimrc
	map <silent> <leader>ss :source ~/.vimrc

	" Fast editing of .vimrc
	map <silent> <leader>ee :call SwitchToBuf("~/.vimrc")<cr>

	" When .vimrc is edited, reload it
	autocmd! bufwritepost .vimrc source ~/.vimrc
elseif MySys() == 'windows'
	" Fast reloading of the .vimrc
	map <silent> <leader>ss :source $VIM\_vimrc<cr>

	" When .vimrc/_vimrc is edited, reload it
	" let filename = $VIM . "\\_vimrc"
	" 上面的变量定义用来进行测试
	" 这里进行字符串拼接的方式有两种
	" map <silent> <leader>ee :call SwitchToBuf($VIM . '\_vimrc')<cr>
	" 这里除了可以使用上面的 $VIM . '\_vimrc' 方式外，还可以使用 $MYVIMRC
	" 变量完成，效果也很好，另注意这里不需要单独定义 $VIM
	" 环境变量，这个特殊的变量已经由 VIM 为我们定义好了。
	map <silent> <leader>ee :call SwitchToBuf($MYVIMRC)<cr>

	" When .vimrc/_vimrc is edited, reload it
	autocmd! bufwritepost _vimrc source $VIM\_vimrc
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => For Windows Version
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 下面的内容是 Windows 版的 vim 安装完成后就自动生成的代码，为了在扩平台的目标下
" 保证完整性，最好作如下的处理
if MySys() == 'windows'
	set nocompatible
	source $VIMRUNTIME/vimrc_example.vim
	source $VIMRUNTIME/mswin.vim
	behave mswin

	set diffexpr=MyDiff()
	" 这里添加 ! 避免提示 E122 错误
	function! MyDiff()
	  let opt = '-a --binary '
	  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
	  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
	  let arg1 = v:fname_in
	  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
	  let arg2 = v:fname_new
	  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
	  let arg3 = v:fname_out
	  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
	  let eq = ''
	  if $VIMRUNTIME =~ ' '
		if &sh =~ '\<cmd'
		  let cmd = '""' . $VIMRUNTIME . '\diff"'
		  let eq = '"'
		else
		  let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
		endif
	  else
		let cmd = $VIMRUNTIME . '\diff'
	  endif
	  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
	endfunction
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => For Chinese/Japanese envionment
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 判断 vim 是否包含多字节语言支持，并且版本号大于 6.1
if has('multi_byte') && v:version > 601
	" 如果 vim 的语言（受环境变量 LANG 影响）是中文（zh）、日文（ja）或韩文（ko）的情况下
	" 使用 libcallnr("Kernel32.dll", "GetUserDefaultLCID", "") 可以查看当前 Windows 系统
	" 默认的语言设置，不过由于我在日文系统下仍然使用的是英文界面，所以总是获得 en 的结果。
	" if v:lang =~? '^\(zh\)\|\(ja\)\|\(ko\)' 
	if libcallnr("Kernel32.dll", "GetACP", "") =~? '^\(932\)' 
		" 1. 将模糊宽度的 Unicode 字符宽度设为双宽度（double）
		set ambiwidth=double
		" 2. 设置字符编码类型为 UTF-8
		set encoding=utf-8
		set fileencoding=utf-8
		set fileencodings=ucs-bom,utf-8,chinese
		" 3. 字体设置
		" ★ YaHei Consolas Hybrid ，这个字体需要单另安装。对于中文字体，我有种无语的感觉。
		set guifont=YaHei_Consolas_Hybrid:h12
		" ★ 日文环境下默认可以使用的中文字体。(CHINESE_GB2312)
		" set guifont=NSimSun:h12
		" ★ 日文环境下默认可以使用的中文繁体字体，当简体使用也没有错误。(CHINESE_BIG5)
		" set guifont=MingLiu:h12
	elseif libcallnr("Kernel32.dll", "GetACP", "") =~? '^\(936\)'
		" 解决 console 输出乱码
		" 由于家里的电脑使用了中文菜单，而在日文环境下配置的是英文菜单。这就造成了在公司使用
		" 正常的配置到了家里就不起作用了。这里需要使用如下的命令配置 console 的字符集。既可以
		" 解决乱码问题。
		language messages zh_CN.utf-8
	endif
endif
