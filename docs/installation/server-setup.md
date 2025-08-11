---
description: Quick steps to secure your node.
---

# Security Best Practices for your Validator node

Completing this guide will provide a solid baseline to protect and secure your node.

## :robot: Pre-requisites

**Operating System**: Ubuntu 20.04 LTS 64 bits

**Hardware**:

| Hardware       | minimum | desired |
| :------------- | :------ | :------ |
| **CPU's**:     | 2       | 4       |
| **Memory**:    | 4 Gb    | 8 Gb    |
| **Hard Disk**: | 100 Gb  | 1000 Gb |

* a SSH client or terminal window access on a local computer.

In case you need a SSH client for your operating system, refer to:

{% embed url="https://www.howtogeek.com/311287/how-to-connect-to-an-ssh-server-from-windows-macos-or-linux/" %}

## :man\_mage: Mandatory: Create a non-root user with sudo privileges

Begin by connecting to your Ubuntu Server with your SSH client.

```bash
ssh root@node.ip.address
```

Create a new user called kaly

```
sudo useradd -m -s /bin/bash kaly
```
{% hint style="info" %}
the user name _kaly_ is only an example you can make any user name you wish
{% endhint %}

Set the password for kaly user

```
sudo passwd kaly
```

Add kaly to the sudo group

```
sudo usermod -aG sudo kaly
```

## :closed\_lock\_with\_key: Mandatory: **Disable SSH password Authentication and Use SSH Keys only**


{% hint style="info" %}
The basic rules of hardening SSH are:

* No password for SSH access (use private key)
* Don't allow root to SSH (the appropriate users should SSH in, then `su` or `sudo`)
* Use `sudo` for users so commands are logged
* Log unauthorized login attempts (and consider software to block/ban users who try to access your server too many times, like fail2ban)
* Lock down SSH to only the ip range your require (if you feel like it)
{% endhint %}

Create a new SSH key pair on your local machine. Run this on your local machine. You will be asked to type a file name in which to save the key. This will be your **keyname**.

```
ssh-keygen -t ed25519
```

Your SSH key pair is stored in your home directory. For example, if your keyname was **mySSHkey**, then your private SSH key is `mySSHkey` and your public SSH key is `mySSHkey.pub`

{% hint style="warning" %}
**IMPORTANT:** Make multiple backup copies of your **private SSH key file** to external storage, such as a USB backup key, for recovery purposes.



Verify the contents of your private SSH key file before moving on.&#x20;

```
cat <keyname>
```



It should look similar to this example.

```
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
QyNTUxOQAAACBAblzWLb7/0o62FZf9YjLPCV4qFhbqiSH3TBvZXBiYNgAAAJCWunkulrp5
LgAAAAtzc2gtZWQyNTUxOQAAACBAblzWLb7/0o62FZf9YjLPCV4qFhbqiSH3TBvZXBiYNg
AAAEAxT+yCmifGWgbFnkauf0HyOAJANhYY5EElEX8fI+M4B0BuXNYtvv/SjrYVl/1iMs8J
XioWFuqJIfdMG9lcGJg2AAAACWV0aDJAZXRoMgECAwQ=
-----END OPENSSH PRIVATE KEY-----
```
{% endhint %}

Transfer the public key to your remote node. Replace <**keyname.pub>** appropriately.

```bash
ssh-copy-id -i $HOME/<keyname.pub> kaly@node.ip.address
```

Login with your new kaly user

```
ssh kaly@node.ip.address
```

Disable root login and password based login. Edit the `/etc/ssh/sshd_config file`

```
sudo nano /etc/ssh/sshd_config
```

Locate **PubkeyAuthentication** and update to yes. Delete the #, if needed.

```
PubkeyAuthentication yes
```

Locate **PasswordAuthentication** and update to no

```
PasswordAuthentication no
```

Locate **PermitRootLogin** and update to prohibit-password

```
PermitRootLogin prohibit-password
```

Locate **PermitEmptyPasswords** and update to no

```
PermitEmptyPasswords no
```

**Optional**: Locate **Port** and customize it your **random** port.

```bash
Port <your random port number>
```

{% hint style="info" %}
A valid **random** port # ranges from 1024 thru 49141.

Check that the port is not already used by other services. Replace \<port> with your random port #.

```
sudo ss -ntlp | grep :<port>
```

Empty response means the port is good.

A response with red numbers means the port is already used. Choose another port.
{% endhint %}

Validate the syntax of your new SSH configuration.

```
sudo sshd -t
```

If no errors with the syntax validation, restart the SSH process

```
sudo systemctl restart sshd
```

Verify the login still works

{% tabs %}
{% tab title="Standard SSH Port 22" %}
```
ssh kaly@node.ip.address
```
{% endtab %}

{% tab title="Custom SSH Port" %}
```bash
ssh kaly@node.ip.address -p <custom random port number>
```
{% endtab %}
{% endtabs %}

**Optional**: Make logging in easier by updating your local ssh config.

To simplify the ssh command needed to log in to your server, consider updating your local `$HOME/.ssh/config` file:

```bash
Host kaly-node
  User kaly
  HostName <node.ip.address>
  Port <custom random port number>
```

This will allow you to log in with `ssh kaly-node` rather than needing to pass through all ssh parameters explicitly.

## :robot: Mandatory: **Update your system**

{% hint style="warning" %}
It's critically important to keep your system up-to-date with the latest patches to prevent intruders from accessing your system.
{% endhint %}

```bash
sudo apt-get update -y && sudo apt dist-upgrade -y
sudo apt-get autoremove
sudo apt-get autoclean
```

Enable automatic updates so you don't have to manually install them.

```
sudo apt-get install unattended-upgrades
sudo dpkg-reconfigure -plow unattended-upgrades
```

Reboot your system to enable the upgrades.

```
sudo reboot
```

## :bricks: Mandatory: **Configure your Firewall**

The standard UFW firewall can be used to control network access to your node.

With any new installation, ufw is disabled by default. Enable it with the following settings.

* If you used a custom random SSH port, replace "22" with your actual port #.


```bash
# By default, deny all incoming and outgoing traffic
sudo ufw default deny incoming
sudo ufw default allow outgoing
# Allow ssh access
sudo ufw allow 22/tcp
# Allow execution client port
sudo ufw allow 30303
# Allow rpc port
sudo ufw allow 8545
# Allow ws port
sudo ufw allow 8546
# Enable firewall
sudo ufw enable
```

{% hint style="warning" %} If you dont want to make RPC or WS calls to your node remotely Omit allowing ports 8545 and 8546.  {% endhint %}

Confirm the settings are in effect.&#x20;

```bash
sudo ufw status numbered
```

Example of properly configured ufw status for Lighthouse.

> ```csharp
>      To                         Action      From
>      --                         ------      ----
> [ 1] 22/tcp                     ALLOW IN    Anywhere
> [ 2] 30303                      ALLOW IN    Anywhere
> [ 3] 8545                       ALLOW IN    Anywhere
> [ 4] 8546                       ALLOW IN    Anywhere
> [ 5] 22/tcp (v6)                ALLOW IN    Anywhere (v6)
> [ 6] 30303 (v6)                 ALLOW IN    Anywhere (v6)
> [ 7] 8545 (v6)                  ALLOW IN    Anywhere (v6)
> [ 7] 8546 (v6)                  ALLOW IN    Anywhere (v6)
> ```


{% hint style="warning" %}
**Note for Grafana Users**: Do not expose Grafana (port 3000) to the public internet as this invites a new attack surface! A secure solution would be to access Grafana through a ssh tunnel.

Example of how to create a ssh tunnel:

```
ssh -N -v kaly@node.ip.address -L 3000:localhost:3000
```
{% endhint %}

**\[ Optional ]** Whitelisting, which means permitting connections from a specific IP, can be setup via the following command.

```bash
sudo ufw allow from <your local daily laptop/pc>
# Example
# sudo ufw allow from 192.168.50.22
```

## :chains: Mandatory: **Install Fail2ban**

{% hint style="info" %}
Fail2ban is an intrusion-prevention system that monitors log files and searches for particular patterns that correspond to a failed login attempt. If a certain number of failed logins are detected from a specific IP address (within a specified amount of time), fail2ban blocks access from that IP address.
{% endhint %}

```
sudo apt-get install fail2ban -y
```

Edit a config file that monitors SSH logins.

```
sudo nano /etc/fail2ban/jail.local
```

Add the following lines to the bottom of the file.

{% hint style="info" %}
:fire: **Whitelisting IP address tip**: The `ignoreip` parameter accepts IP addresses, IP ranges or DNS hosts that you can specify to be allowed to connect. This is where you want to specify your local machine, local IP range or local domain, separated by spaces.

```bash
# Example
ignoreip = 192.168.1.0/24 127.0.0.1/8
```
{% endhint %}

```bash
[sshd]
enabled = true
port = <22 or your random port number>
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
# whitelisted IP addresses
ignoreip = <list of whitelisted IP address, your local daily laptop/pc>
```

Save/close file.

Restart fail2ban for settings to take effect.

```
sudo systemctl restart fail2ban
```

## :bear: Optional: Disable root account

System admins should not frequently log in as root in order to maintain server security. Instead, you can use sudo execute that require low-level privileges.

```bash
# To disable the root account, simply use the -l option.
sudo passwd -l root
```

```bash
# If for some valid reason you need to re-enable the account, simply use the -u option.
sudo passwd -u root
```

## :tools: Optional: Setup Two Factor Authentication for SSH

{% hint style="info" %}
SSH, the secure shell, is often used to access remote Linux systems. Because we often use it to connect with computers containing important data, it’s recommended to add another security layer. Here comes the two factor authentication (_2FA_).
{% endhint %}

```
sudo apt install libpam-google-authenticator -y
```

To make SSH use the Google Authenticator PAM module, edit the `/etc/pam.d/sshd` file:

```
sudo nano /etc/pam.d/sshd
```

Add the following line:

```
auth required pam_google_authenticator.so
```

Now you need to restart the `sshd` daemon using:

```
sudo systemctl restart sshd.service
```

Modify `/etc/ssh/sshd_config`

```
sudo nano /etc/ssh/sshd_config
```

Locate **ChallengeResponseAuthentication** and update to yes

```
ChallengeResponseAuthentication yes
```

Locate **UsePAM** and update to yes

```
UsePAM yes
```

Save the file and exit.

Run the **google-authenticator** command.

```
google-authenticator
```

It will ask you a series of questions, here is a recommended configuration:

* Make tokens “time-base”": yes
* Update the `.google_authenticator` file: yes
* Disallow multiple uses: yes
* Increase the original generation time limit: no
* Enable rate-limiting: yes

You may have noticed the giant QR code that appeared during the process, underneath are your emergency scratch codes to be used if you don’t have access to your phone: write them down on paper and keep them in a safe place.

Now, open Google Authenticator on your phone and add your secret key to make two factor authentication work.

{% hint style="danger" %}
**Note**: If you are enabling 2FA on a remote machine that you access over SSH you need to follow **steps 2 and 3** of [this tutorial](https://www.digitalocean.com/community/tutorials/how-to-set-up-multi-factor-authentication-for-ssh-on-ubuntu-18-04) to make 2FA work.
{% endhint %}

## :jigsaw: Optional: Secure Shared Memory

{% hint style="info" %}
One of the first things you should do is secure the shared [memory](https://www.lifewire.com/what-is-random-access-memory-ram-2618159) used on the system. If you're unaware, shared memory can be used in an attack against a running service. Because of this, secure that portion of system memory.

To learn more about secure shared memory, read this [techrepublic.com article](https://www.techrepublic.com/article/how-to-enable-secure-shared-memory-on-ubuntu-server/).
{% endhint %}


## :rocket: References

% embed url="https://www.coincashew.com/coins/overview-eth/guide-or-how-to-setup-a-validator-on-eth2-mainnet/part-i-installation/guide-or-security-best-practices-for-a-eth2-validator-beaconchain-node" %}

{% embed url="https://medium.com/@BaneBiddix/how-to-harden-your-ubuntu-18-04-server-ffc4b6658fe7" %}

{% embed url="https://linux-audit.com/ubuntu-server-hardening-guide-quick-and-secure/" %}

{% embed url="https://www.digitalocean.com/community/tutorials/how-to-harden-openssh-on-ubuntu-18-04" %}

{% embed url="https://ubuntu.com/tutorials/configure-ssh-2fa#1-overview" %}

{% embed url="https://linuxize.com/post/install-configure-fail2ban-on-ubuntu-20-04/" %}

[https://gist.github.com/lokhman/cc716d2e2d373dd696b2d9264c0287a3#file-ubuntu-hardening-md](https://gist.github.com/lokhman/cc716d2e2d373dd696b2d9264c0287a3#file-ubuntu-hardening-md)

{% embed url="https://www.lifewire.com/harden-ubuntu-server-security-4178243" %}

{% embed url="https://www.ubuntupit.com/best-linux-hardening-security-tips-a-comprehensive-checklist/" %}
