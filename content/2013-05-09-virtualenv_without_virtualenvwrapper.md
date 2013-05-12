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


# Updates 2013-05-10

I had originally started using this approach a while back and couldn't remember the timing differences. Here is a rough timing test for shel startup time

- Using the approach here:

        zsh -i -c exit  0.16s user 0.27s system 76% cpu 0.570 total
        zsh -i -c exit  0.16s user 0.19s system 101% cpu 0.338 total
        zsh -i -c exit  0.16s user 0.19s system 101% cpu 0.343 total
        zsh -i -c exit  0.16s user 0.19s system 100% cpu 0.345 total
        zsh -i -c exit  0.15s user 0.18s system 101% cpu 0.329 total
        zsh -i -c exit  0.15s user 0.18s system 100% cpu 0.334 total


- With virtualenvwrapper but no environment activated

        zsh -i -c exit  0.37s user 0.31s system 98% cpu 0.690 total
        zsh -i -c exit  0.35s user 0.31s system 96% cpu 0.694 total
        zsh -i -c exit  0.36s user 0.31s system 99% cpu 0.676 total
        zsh -i -c exit  0.36s user 0.30s system 99% cpu 0.672 total
        zsh -i -c exit  0.38s user 0.31s system 99% cpu 0.693 total
        zsh -i -c exit  0.37s user 0.33s system 95% cpu 0.730 total

- With virtualenvwrapper and activating an environment

        zsh -i -c exit  0.81s user 0.64s system 96% cpu 1.507 total
        zsh -i -c exit  0.81s user 0.59s system 99% cpu 1.417 total
        zsh -i -c exit  0.81s user 0.62s system 98% cpu 1.459 total
        zsh -i -c exit  0.97s user 0.69s system 98% cpu 1.698 total
        zsh -i -c exit  0.81s user 0.63s system 95% cpu 1.498 total
        zsh -i -c exit  0.84s user 0.62s system 98% cpu 1.489 total

If you don't want an environment loaded at startup you can source `virtualenvwrapper_lazy.sh` as [mentioned here](https://bitbucket.org/dhellmann/virtualenvwrapper/issue/125/initialization-causes-slow-shell-startup) but this intended for people who will manually use `workon` to activate an environment once in the shell.
