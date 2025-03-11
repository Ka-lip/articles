
I use vim as my git diff tool, but it pops out error messages when using git.  
The OS is windows and based on the investigation, the solution is.  
1. in the Windows, move `~/_vimrc` to `~/vimfiles/vimrc`.
1. in the git bash, `mv /bin/vim /bin/vim.disabled`.


[vim not loading _vimrc file when launched from git bash](https://superuser.com/questions/280331/vim-not-loading-vimrc-file-when-launched-from-git-bash)  
[Error when using vim-plug from git-bash](https://vi.stackexchange.com/questions/43099/error-when-using-vim-plug-from-git-bash)