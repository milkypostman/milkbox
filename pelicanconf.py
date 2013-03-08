#!/usr/bin/env python
# -*- coding: utf-8 -*- #

AUTHOR = u'Donald Curtis'
SITENAME = u'milkbox'
SITEURL = ''

FEED_DOMAIN = 'http://milkbox.net'

TIMEZONE = 'America/Chicago'

THEME = 'mb'

DEFAULT_LANG = u'en'

IGNORE_FILES = ['.#*', '*~', 'TODO']

# Blogroll
LINKS =  (('Pelican', 'http://docs.notmyidea.org/alexis/pelican/'),
          ('Python.org', 'http://python.org'),
          ('Jinja2', 'http://jinja.pocoo.org'),
          ('You can modify those links in your config file', '#'),)


# Social widget
SOCIAL = (('You can add links in your config file', '#'),
          ('Another social link', '#'),)

STATIC_PATHS = (['stuff', 'imgs'])

OUTPUT_SOURCES = True


FILES_TO_COPY = (
    ('extra/robots.txt', 'robots.txt'),
    ('extra/humans.txt', 'humans.txt'),
    ('extra/crossdomain.xml', 'crossdomain.xml'),
    ('extra/favicon.ico', 'favicon.ico'),
    )


ARTICLE_URL = 'note/{slug}/'
ARTICLE_SAVE_AS = 'note/{slug}/index.html'


DEFAULT_PAGINATION = False
