" All system-wide defaults are set in $VIMRUNTIME/debian.vim and sourced by
" the call to :runtime you can find below.  If you wish to change any of those
" settings, you should do it in this file (/etc/vim/vimrc), since debian.vim
" will be overwritten everytime an upgrade of the vim packages is performed.
" It is recommended to make changes after sourcing debian.vim since it alters
" the value of the 'compatible' option.

runtime! debian.vim

" Vim will load $VIMRUNTIME/defaults.vim if the user does not have a vimrc.
" This happens after /etc/vim/vimrc(.local) are loaded, so it will override
" any settings in these files.
" If you don't want that to happen, uncomment the below line to prevent
" defaults.vim from being loaded.
" let g:skip_defaults_vim = 1

" Uncomment the next line to make Vim more Vi-compatible
" NOTE: debian.vim sets 'nocompatible'.  Setting 'compatible' changes numerous
" options, so any other options should be set AFTER setting 'compatible'.
"set compatible

" Vim5 and later versions support syntax highlighting. Uncommenting the next
" line enables syntax highlighting by default.
"if has("syntax")
  syntax on
"endif

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
set background=dark

" Uncomment the following to have Vim jump to the last position when
" reopening a file
"au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
filetype plugin indent on

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
"set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
set incsearch		" Incremental search
set autowrite		" Automatically save before commands like :next and :make
set hidden		" Hide buffers when they are abandoned
set mouse=a		" Enable mouse usage (all modes)

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif
setlocal noswapfile " 不要生成swap文件

set autoindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set bufhidden=hide " 当buffer被丢弃的时候隐藏它
"colorscheme evening " 设定配色方案
set number " 显示行号
set cursorline " 突出显示当前行
set ruler " 打开状态栏标尺
"set shiftwidth=2 " 设定 << 和 >> 命令移动时的宽度为 2
"set softtabstop=2 " 使得按退格键时可以一次删掉 2 个空格
"set tabstop=2 " 设定 tab 长度为 2
set nobackup " 覆盖文件时不备份
set autochdir " 自动切换当前目录为当前文件所在的目录
set backupcopy=yes " 设置备份时的行为为覆盖
set hlsearch " 搜索时高亮显示被找到的文本
set noerrorbells " 关闭错误信息响铃
set novisualbell " 关闭使用可视响铃代替呼叫
set t_vb= " 置空错误铃声的终端代码
set matchtime=2 " 短暂跳转到匹配括号的时间
set magic " 设置魔术
set smartindent " 开启新行时使用智能自动缩进
set backspace=indent,eol,start " 不设定在插入状态无法用退格键和 Delete 键删除回车符
set cmdheight=1 " 设定命令行的行数为 1
set laststatus=2 " 显示状态栏 (默认值为 1, 无法显示状态栏)
set statusline=\ %<%F[%1*%M%*%n%R%H]%=\ %y\ %0(%{&fileformat}\ %{&encoding}\ Ln\ %l,\ Col\ %c/%L%) " 设置在状态行显示的信息
set foldenable " 开始折叠
set foldmethod=syntax " 设置语法折叠
set foldcolumn=0 " 设置折叠区域的宽度
setlocal foldlevel=1 " 设置折叠层数为 1
nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR> "用空格键来开关折叠


"设置移动整行或整段代码

function! s:moveup_line()
	let cur_pos = getpos('.')	"获取当前光标位置
	"如果已经是最上一行，则直接返回
	if cur_pos[1] == 1
		return
	endif
	let tgt_line = cur_pos[1] - 1	"获得上一行的行号
	let tmp = getline(tgt_line)		"将上一行的内容临时存储
	call setline(tgt_line,getline(cur_pos[1]))	"将上一行的内容替换成当前行
	call setline(cur_pos[1],tmp)	"将当前行的内容替换成上一行
	let cur_pos[1] -= 1	"将当前光标的行号减1,得到目标位置"
	call setpos('.',cur_pos)	"修改当前光标位置
endfunction

function! s:movedown_line()
	let cur_pos = getpos('.')	"获取当前光标位置
	"如果已经是最底一行，则直接返回
	if cur_pos[1] == line('$')
		return
	endif
	let tgt_line = cur_pos[1] + 1	"获得下一行的行号
	let tmp = getline(tgt_line)		"将下一行的内容临时存储
	call setline(tgt_line,getline(cur_pos[1]))	"将下一行的内容替换成当前行
	call setline(cur_pos[1],tmp)	"将当前行的内容替换成下一行
	let cur_pos[1] += 1	"将当前光标的行号+1,得到目标位置"
	call setpos('.',cur_pos)	"修改当前光标位置
endfunction

function! s:moveup_multlines() range
	"获取选择范围的端点的位置信息
	let start_mark = getpos("'<")
	let end_mark = getpos("'>")
	"对代码块的位置进行判断，当已经为最顶层时，直接退出函数
	if start_mark[1] == 1
		return
	endif
	"利用getling()和setline()内置函数实现代码块整体移动
	let save_curpos = getpos('.')
	let buffer_lines = getline(start_mark[1],end_mark[1])
	call add(buffer_lines, getline(start_mark[1] - 1))
	call setline(start_mark[1]-1,buffer_lines)
	"调整选区范围和当前光标的位置
	let start_mark[1] -= 1
	let end_mark[1] -= 1
	let save_curpos[1] -= 1
	call setpos("'<",start_mark)
	call setpos("'>",end_mark)
	call setpos('.',save_curpos)
endfunction

function! s:movedown_multlines() range
	"获取选择范围的端点的位置信息
	let start_mark = getpos("'<")
	let end_mark = getpos("'>")
	"对代码块的位置进行判断，当已经为最底层时，直接退出函数
	if end_mark[1] == line('$')
		return
	endif
	"利用getling()和setline()内置函数实现代码块整体移动
	let save_curpos = getpos('.')
	let buffer_lines = [getline(end_mark[1] + 1)]
	call extend(buffer_lines, getline(start_mark[1],end_mark[1]) )
	call setline(start_mark[1],buffer_lines)
	"调整选区范围和当前光标的位置
	let start_mark[1] += 1
	let end_mark[1] += 1
	let save_curpos[1] += 1
		call setpos("'<",start_mark)
	call setpos("'>",end_mark)
	call setpos('.',save_curpos)
endfunction

noremap <silent> <M-k> :call <SID>moveup_line()<CR>
noremap <silent> <M-j> :call <SID>movedown_line()<CR>
inoremap <silent> <M-k> <ESC>:call <SID>moveup_line()<CR>a
inoremap <silent> <M-j> <ESC>:call <SID>movedown_line()<CR>a
vnoremap <silent> <M-k> :call <SID>moveup_multlines()<CR>gv"后面必须添加‘gv’才可重新进入可视模式
vnoremap <silent> <M-j> :call <SID>movedown_multlines()<CR>gv



"打开vim时,自动打开NREDTree
autocmd Vimenter * NERDTree

"设置NerdTree打开的快捷键
map <F2> : NERDTreeMirror<CR>
map <F2> : NERDTreeToggle<CR>

"映射补全到Shift
"inoremap <s> <C-N>

"映射ESC按键
inoremap jk <ESC>

noremap <Tab> V>
noremap <s-Tab> V<
