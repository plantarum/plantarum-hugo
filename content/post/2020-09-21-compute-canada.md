---
title: Notes on Compute Canada Accounts
updated: 2020-09-23
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

# Installing R Libraries

TODO Installing libraries so the whole team can share them.
