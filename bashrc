source $HOME/.profile
source $HOME/.cargo/env
export PATH=$HOME/bin:$PATH




source "$HOME/.cargo/env"
eval "$(zoxide init bash)"

__main() {
	local major="${BASH_VERSINFO[0]}"
	local minor="${BASH_VERSINFO[1]}"

	if ((major > 4)) || { ((major == 4)) && ((minor >= 1)); }; then
		source <("/home/mfrw/.cargo/bin/starship" init bash --print-full-init)
	else
		source /dev/stdin <<<"$("/home/mfrw/.cargo/bin/starship" init bash --print-full-init)"
	fi
}
__main
unset -f __main
