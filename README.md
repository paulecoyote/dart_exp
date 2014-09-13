# Overview

**dart_exp** is a lightweight starter project for single page Dart + canvas experiments.

The idea is to have a repository that can be cloned, remotes changed and have the build boiler plate done for you.

For my next dart experiments (e.g. game jam) I want the tool chain all ready for me so deploying to a hosted site is just running a script or a few commands from the command line.  The hosting assumes Github pages, but as Jekyll just compiles to static html files you could host it anywhere.

Follow the instructions to bootstrap your next Dart canvas experiment.

# Instructions

Where a line starts with a $ in the instructions, assume this is a command line instruction to type.

These instructions were written for Mac, but should be adaptable to other platforms very easily.

## Setup Github

For open source projects using github is a no brainer.  If you need to be more private about your code you still need to clone from this Github project... but you can either pay for a private repository at Github or try [Bitbucket][https://bitbucket.org/] for free.  But then you will need to figure out hosting your static pages somewhere else.

* Sign up at https://github.com/
* Install git. Make sure it is available on your command line.
* Find a directory to put your experiments on your computer.  Each experiment will have two folders at this level - one for your code and the other for your deployed webpages.  To make it easier on yourself keep it short and without spaces.  Also keep it all lowercase.
* Open a command line at that location (via "git bash" in Windows).
* Visit https://github.com/paulecoyote/dart_exp
* `git clone git@github.com:paulecoyote/dart_exp.git`

## Setup Analytics

Want to know if anyone is actually looking at your page?  Setting up Google analytics is free and easy.

* Visit http://www.google.com/analytics/web
* Create an account and a property that matches the url you are hosting your pages (e.g. myusername.github.io).
* At the bottom of web/index.html replace UA-53984713-2 with your own website tracking token.

# Extra hints

## Extend / replace dart_exp.css

* If your styles become complex, use something fancy like LESS: http://lesscss.org/
* Use an interesting font from google fonts:  https://www.google.com/fonts
* Use something like http://paletton.com/ to create a decent colour scheme.  Refer to them in your experiment to make changing colour schemes easier.
