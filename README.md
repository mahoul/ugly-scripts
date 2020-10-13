# ugly-scripts
Quick and ugly scripts for quick setting up some services and doing some __UNSECURE__ and __DUMB__ stuff.
So no responsability taken here.

## setup-apache-dav.sh

Installs ```apache2``` package under _Debian/Ubuntu_ and setups the default site to allow WebDAV under ```/var/www/dav``` with **NO AUTH** (**K**eep **T**hat **I**n **M**ind)

Use:

```sh
bash setup-apache-dav.sh
```

## create-git-webdav-repo.sh

Creates a git repository under a __PUBLICLY (that's NO AUTH - NO SSL - KTIM)__ available WebDAV folder (```/var/www/dav```).

Use:

```sh
bash create-git-webdav-repo.sh foo
```

## setup-vim.sh

Setups a minimal vim config with:

- gruvbox colorscheme from https://github.com/morhetz/gruvbox
 - (if failed when downloading defaults to desert colorscheme)
- modeline enabled
- cursorline
- cursorcolumn
- syntax highlighting enabled
- dark background mode for colorscheme

Use:

```sh
bash setup-vim.sh
```
