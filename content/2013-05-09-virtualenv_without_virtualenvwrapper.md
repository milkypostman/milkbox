title: virtualenv without the wrapper
author: Donald Curtis
tags: python, virtualenv

**short Intro:** here is a method for using *virtualenv* without *virtualenvwrapper* using a simple shell function.

If you're like me you like to keep your system clean; not installing packages globally, using the builtin install mechanisms, using [homebrew](http://mxcl.github.io/homebrew/) to install things to `/usr/local` knowing you can always blow that directory away and start fresh if you want. With Python on OS X and Linux I don't want to pollute the system library directories when installing new packages. For me the minor reason is that I don't like things installed to `/Library/Python/2.7/site-packages` and the major reason is that inevitably some Python packages install scripts to `/usr/bin`. And while [pip](http://www.pip-installer.org/en/latest/) can do a good job of uninstalling pacakges it doesn't always work and the standard [easy_install](http://peak.telecommunity.com/DevCenter/EasyInstall) doesn't have a remove option! Yes, WTF?

So I rely on [virtualenv](http://www.virtualenv.org/) to keep my system Python directory clean *and* to allow me different package setups for different projects. I first started using [virtualenv](http://www.virtualenv.org/) I immediately started using [virtualenvwrapper](https://bitbucket.org/dhellmann/virtualenvwrapper). Eventually I started to wonder why my shell was taking so long to startup. So I realized that while *virtualenvwrapper* is great and full-featured, I had enough experience with the shell and Python that I didn't need all of its features.


## Installing *virtualenv*

Unfortunately no matter how clean you want to keep your system's Python package directory, you need to at least install *virtualenv*. I'll just leave this here:

```console
easy_install virtualenv
```

## Creating a default environment

Since I never want to pollute the system package directory I create a `default` environment that automatically loads when I start my shell. I play nice and install new virtualenvs to the `~/.virtualenvs` directory which is the same directory that *virtualenvwrapper* uses.

```console
virtualenv ~/.virtualenvs/default
```

The main reason *I* use a directory in `~` is that I sync my development files via Dropbox and thus cannot share libraries between machines; some packages actually compile code that is system dependent.


## Activating the default environment

To activate the default environment manually you can just run,

```console
. ~/.virtualenvs/default/bin/activate
```

but this gets tiresome and is not flexible enough. So in `.zshrc`---`.bashrc` for bashers---just put,

```bash
VIRTUALENV_BASE="${HOME}/.virtualenvs"
activate() {
    if [ $# -le 0 ]; then
        set -- default
    fi
    . ${VIRTUALENV_BASE}/$1/bin/activate
}
activate
```

The `activate` function has an optional argument that defaults to `default` and activates the specified virtualenv. Adjust `VIRTUALENV_BASE` if you despise the location and create virtualenvs in that directory.

## Creating additional environments

When I want to create a new environment, say `burger`, I just do,

```console
virtualenv ~/.virtualenvs/burger
```


# Asteroid Crash

I am well aware that at some point if I were to add more functionality to this approach I would reach *virtualenvwrapper* level and at that point I'd be incurring as much overhead. But I don't use all that functionality and I know how to traverse a tree. I want to live close to the metal because when something breaks I have not added another layer of functionality. To me this is simple.


## More Information

Please read [Better Package Management](http://nvie.com/posts/better-package-management/) on how to actually manage dependencies properly using the virtualenvs you create.


