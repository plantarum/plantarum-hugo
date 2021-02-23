---
title: Notes on Compute Canada Accounts
updated: 2021-02-01
categories: HPC
excerpt: Notes on setting up my Compute Canada Account
tags: [hpc, compute canada]
date: 2020-09-21
---

I renewed my account with [ComputeCanada](https://www.computecanada.ca), which is available for all Canadian University researchers (professors and adjuncts), and students and postdocs they work with. Here are a few notes that might be handy later.

# Accounts
Sign up for an [account](https://www.computecanada.ca/research-portal/account-management/apply-for-an-account/). 

This will get you access to the [clusters](https://docs.computecanada.ca/wiki/Getting_started#What_resources_are_available.3F)

# Login
Login with `ssh`:

``` bash
ssh username@beluga.computecanada.ca
```

Use the same password as the one for your Compute Canada account here.

You can use [SSH keys](https://docs.computecanada.ca/wiki/Using_SSH_keys_in_Linux) to login without a password. After you've followed the instructions at that link, you won't have to use your password anymore.

For a little extra convenience, especially if you use multiple servers with different keys and usernames, add your details to `.ssh/config`:

```
Host beluga
     HostName beluga.computecanada.ca
     User username
     IdentityFile ~/.ssh/my_rsa_key
```

This will allow me to login to the `beluga.computecanada.ca` cluster as user `username`, using the private key `~/.ssh/my_rsa_key`, with just the following command (and no password):

```bash
ssh beluga
```

This also allows me to open files on the cluster directly from my local Emacs instance:

```
M-x find-file
/ssh:beluga:~/path/to/file/on/beluga
```

# Working with R

## Modules

After a long day spent diving through dependencies, I found the following
minimal set of modules necessary to install the packages used our GBS
analysis:

    module load nixpkgs/16.09 gcc/7.3.0 gdal/3.0.1 udunits/2.2.26 proj4-fortran/1.0 proj/6.3.0 r/4.0.2

You run this command (on a single line) at the terminal after logging into
the cluster. After you've loaded the modules, you can save the collection
for future sessions with:

    module save r_modules

On our next, and all subsequent sessions, we can load R into an interactive
session via:

    module restore r_modules

Note that you may need to add additional modules to support new packages
you install. Sometimes `install.packages` will give you an informative
error message. Sometimes you're not so lucky. Check to see which actual
package causes the error (i.e., the one you're installing, or one of its
dependencies), and check the source repository for the problematic package
for additional clues.

## Shared R library

I set up a shared drive for everyone in the lab to use. This will save a
lot of time, as installing packages from source on Linux can take a while.

```bash
mkdir $HOME/projects/def-tsmith/lab
setfacl -d -m g::rwx $HOME/projects/def-tsmith/lab
```

`def-tsmith` is my group name, if you don't work with me you'll need to use
your supervisor's project name instead. 

To access this library, **after** you have loaded the `R` modules, execute
the following command:

    export R_LIBS=~/projects/def-tsmith/lab/R/x86_64-pc-linux-gnu-library/${EBVERSIONR%.*}/

`EBVERSIONR` is the version of R installed, including the bugfix release
number (e.g., 4.0.2). We only use the major.minor numbers for the library
directories (4.0), so I've trimmed off the last number via [parameter substitution](https://tldp.org/LDP/abs/html/parameter-substitution.html). 

After you've done this, you can start R in an interactive session via `R`.
You'll have access to all the packages I've already installed, and any new
packages will be installed into the same shared library.

## Jobs

To load the modules and access the shared library from your scripts, use
the following:

    #!/bin/bash
    ##
    ##SBATCH settings for the job
    ##...
    
    module restore r_modules
    export R_LIBS=~/projects/def-tsmith/lab/R/x86_64-pc-linux-gnu-library/${EBVERSIONR%.*}/
    
    ## 'computation.R' contains the code you want to run:
    Rscript computation.R


