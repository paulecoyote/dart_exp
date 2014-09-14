# Overview

**dart_exp** is a lightweight starter project for single page Dart + canvas experiments.

The idea is to have a repository that can be cloned, remotes changed and have the build boiler plate done for you.

For my next dart experiments (e.g. game jam) I want the tool chain all ready for me so deploying to a hosted site is just running a script or a few commands from the command line.  The hosting assumes Github pages, but as Jekyll just compiles to static html files you could host it anywhere.

Follow the instructions to bootstrap your next Dart canvas experiment.

# Disclaimer 

Everything in this repository is as-is.  Everything you do is at your own risk.

# Instructions

Where a line starts with a $ in the instructions, assume this is a command line instruction to type.

These instructions were written for Mac, but should be adaptable to other platforms very easily.

## Install software

* Dart - either the SDK + your favourite editor + plugin or the Dart Editor
  * [Dart SDK][https://www.dartlang.org/tools/sdk/]
  * [Dart Editor][https://www.dartlang.org/tools/editor/]
* Install git client (with the bash command line if that is an option) https://help.github.com/articles/set-up-git
* Install git-flow ... this will help you keep track of releases and help pub out.  https://github.com/nvie/gitflow/wiki/Installation
  * [git flow further reading][http://nvie.com/posts/a-successful-git-branching-model/]
* Follow these instructions to [Install Jekyll][https://help.github.com/articles/using-jekyll-with-pages]

## Grab this repository from Github

For open source projects using github is a no brainer.  If you need to be more private about your code you still need to clone from this Github project... but you can either pay for a private repository at Github or try [Bitbucket][https://bitbucket.org/] for free.  But then you will need to figure out hosting your static pages somewhere else.

* Sign up at https://github.com/
* Install git. Make sure it is available on your command line.
* Find a directory to put your experiments on your computer.  Each experiment will have two folders at this level - one for your code and the other for your deployed webpages.  To make it easier on yourself keep it short and without spaces.  Also keep it all lowercase.
* Open a command line at that location (via "git bash" in Windows).
* Visit https://github.com/paulecoyote/dart_exp
  * If you think you may contribute back to improve the shim itself, fork it :)
* `git clone git@github.com:paulecoyote/dart_exp.git` ... or your branch

## Create repository for your project

You could have a remote repository on Github / Bitbucket / Dropbox and host your website on Github / EC2 / Dropbox.

You could also have a Github repository where you have just a README.md in your master branch and just use compiled / minified dart in your gh-pages branch and store that source code elsewhere.  Though please do store your code on a server somewhere - it is valuable! :)

The following assumes that your project and page is on Github.

* Create your project on Github, then clone it twice locally, the second time append -pages to the folder name.
* `git clone git@github.com:YOUR_USERNAME/YOUR_PROJECT_NAME.git`
* `git clone git@github.com:YOUR_USERNAME/YOUR_PROJECT_NAME.git YOUR_PROJECT_NAME-pages`
* If you are going to try using git-flow, go in to the PROJECT_NAME directory and 
  * `git git-flow init`
  * Accept the defaults apart from "Version tag prefix? []". Type v for that.
  * `git checkout master`
* Now go in to the second working copy 
  * `../YOUR_PROJECT_NAME-pages`
  * `git checkout --orphan gh-pages`
  * `git rm -rf .`
    * If you get the error fatal: pathspec '' did not match any files ... it just means it was already empty

## Bootstrap your repositories

Now we're going to bootstrap those empty repositories with this one.
* Open up a bash command line at the location where you cloned the dart_exp repository
* Below assumes you have cloned the dart_exp repository next to your own new repository.
* Replace `dart_exp_test` with the path to YOUR_PROJECT_NAME. The trailing slash is **very important**
  * `git checkout-index -a -f --prefix=../dart_exp_test/`
  * `git checkout gh-pages`
  * `git checkout-index -a -f --prefix=../dart_exp_test-pages/`
  * `git checkout master`
* Now go to YOUR_PROJECT_NAME directory and commit this as the initial version
  * git add .
  * git commit -m 'Initial commit. Needs configuration.'
  * git tag -a v0.1.0 -m 'Initial version 0.1.0'
  * git push --follow-tags origin master
* Now repeat with YOUR_PROJECT_NAME-pages directory and commit that initial version
  * git commit -m 'Initial commit. Needs configuration.'
  * git tag -a v0.1.0 -m 'Initial version 0.1.0'
  * git push --follow-tags origin master
* After up to 10 minutes later your project will appear on http://YOUR_GITHUB_USERNAME.github.io/YOUR_PROJECT_NAME/
* Changes in source on both branches can be viewed almost instantaneously in both branches via the web interface at https://github.com/YOUR_GITHUB_USERNAME/YOUR_PROJECT_NAME 

## Configure your dart project

The `pubspec.yaml` file needs to be fixed up.
* Name: need to match your project name
* Version: should be updated in sync with when you tag a commit in your git repository as a release. 
* Dependencies: may need to be updated whenever the dart-sdk gets updated.  Ideally they stipulate a range rather than *any*
  * Dart packages starting with 0. will likely have code breaking features when the second digit is incremented.  Third number increments usually do not break things
  * Otherwise see [Semantic Versioning][http://semver.org/] 
* You may rename dart_exp.dart and dart_exp.css and the things they reference - but index.html and styles.css should remain with those names for ease of deployment.

## Configure your project website

This is the second clone we bootstrapped with the -pages suffix.

If you follow this process the deployments go to ./v/0.1.0 ./v/x.y.z etc.

Then the "Play" button the right takes you to those deployed versions

The _config.yml file should be the only thing that **requires** configuration.  

Please open up that file and follow the instructions inside it.

## Setup analytics

Want to know if anyone is actually looking at your page?  Setting up Google analytics is free and easy.

* Visit http://www.google.com/analytics/web
* Create an account and a property that matches the url you are hosting your pages (e.g. myusername.github.io).
* At the bottom of web/index.html replace UA-53984713-2 with your own website tracking token.

# Deployment

For Mac there's a script - tool/release_exp.sh - that automates these steps.  Please feel free to contribute your own scripts.  Perhaps a dart solution could even be cross platform!

## Manual deployment steps

Replace YOUR_PROJECT_NAME and version numbers as appropriate.

* Open command line at your main copy of your repository. 
* If using `git flow release` or `git tag -a v0.1.0 -m 'version 0.1.0'` versions manually, remember to:
** Match the tag version number with the version in the `pubspec.yaml` file. Add another commit and move the tag to that if you forgot.
** `git push origin v0.1.0`
* pub build
* cp -r build/web ../YOUR_PROJECT_NAME-pages/v/0.1.0
* cd ../YOUR_PROJECT_NAME-pages/v/0.1.0
* git add .
* git commit -a -m 'web release of 0.1.0'
* git push origin gh-pages

# Extra hints

## Use Semantic Versioning

* [Semantic Versioning][http://semver.org/] for your git feature branches and pubspec.yaml file. 
* This will make it a lot easier to navigate your git history and manage releases
* If this turns out to be a library then pub can track the versions via the tags
* Github itself tracks releases when you name something withe Semantic Versioning via the web interface automatically for you.  No extra work.
* If in a pre-release state start a version 0, have major changes in the second digit and non-breaking minor changes as the third.

## Extend / replace dart_exp.css

* If your styles become complex, use something fancy like LESS: http://lesscss.org/
* Use an interesting font from google fonts:  https://www.google.com/fonts
* Use something like http://paletton.com/ to create a decent colour scheme.  Refer to them in your experiment to make changing colour schemes easier.
