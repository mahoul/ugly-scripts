#!/bin/bash

if [ ! -d ~/.vim ]; then 
	mkdir -p ~/.vim
	if [ ! -d ~/.vim/colors ]; then
		mkdir -p ~/.vim/colors
		wget -P ~/.vim/colors/ https://raw.githubusercontent.com/morhetz/gruvbox/master/colors/gruvbox.vim
	fi
fi

if [ ! -s ~/.vimrc ]; then
	# Add Powerline tweaks if powerline is installed
	#
	if dpkg -L python3-powerline &>/dev/null; then
		cat <<-EOF > ~/.vimrc
		set laststatus=2 " Always display the statusline in all windows
		set showtabline=2 " Always display the tabline, even if there is only one tab
		set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)

		python3 from powerline.vim import setup as powerline_setup
		python3 powerline_setup()
		python3 del powerline_setup
		EOF
	fi

	# If gruvbox color scheme exist, use it
	#
	if [ -s ~/.vim/colors/gruvbox.vim ]; then
		cat <<-EOF >> ~/.vimrc
		colorscheme gruvbox
		EOF
	else
		cat <<-EOF >> ~/.vimrc
		colorscheme desert
		EOF
	fi

	# Add common tweaks
	#
	cat <<-EOF >> ~/.vimrc
	syntax on
	set cursorline
	set cursorcolumn
	set modeline
	set bg=dark
	EOF
fi

