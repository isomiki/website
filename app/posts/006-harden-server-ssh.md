# How to harden your server's SSH config

> I'll show you how to set a custom SSH port, set up SSH keys and tweak some other settings.

1. **Set up the SSH key**

- Generate a key (use your own options):

```bash
ssh-keygen -t ed25519 -C "Key for my target machine" -f ~/.ssh/example-key
```

- Copy the public key from `~/.ssh/example-key.pub` on your local machine to a new line in `/home/boss/.ssh/authorized_keys` on the target machine

2. **Set an alternative port for SSH**

Pick a port above the privileged port range (0-1023). Don't use common alternatives like 2222. I also check the [list of port numbers on wikipedia](https://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers) to see if there's another common service which might conflict later.

Forward that port on the target machine, e.g.

```bash
sudo ufw allow 12345
```

`ufw` is a firewall tool but you might have a different one.

4. **Configure SSHD**

On the target

```bash
sudo vim /etc/ssh/sshd_config
```

Set these options:

- `Port 12345` Set it to your new port
- `PermitRootLogin prohibit-password` Self explanatory
- `PasswordAuthentication no` Forbids password login for other users too
- `X11Forwarding no` X11 has vulnerabilities and you probably aren't using X11 forwarding anyway. Even if you use X11 or VNC this won't interfere.
- `AllowUsers boss` Specify your user(s) here. If you have multiple, separate them with spaces. This might not even be necessary, I forgot, but I think with the particular setup above this is required.

5. **Restart the ssh daemon**

On the target

```bash
sudo systemctl restart sshd
```

> Don't disconnect yet, keep the session in case you broke something.

Start a new SSH connection from a new terminal session. Specify your new port and key:

```bash
ssh -p 12345 -i ~/.ssh/example-key boss@some-address
```

Use the target's IP or hostname of course.

6. **Make connecting easier for yourself**

On your local machine, configure your connection in `~/.ssh/config`:

```txt
Host example-target
    HostName some-address
    User boss
    IdentityFile ~/.ssh/example-key
    Port 12345
```

Then you can connect like this:

```bash
alias s='ssh boss@example-target'
```

## Rate limiting

I also like to ban IPs which fail login repeatedly.

On the target:

1. Install `fail2ban`

```bash
sudo apt install fail2ban
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
```

2. Configure fail2ban in `/etc/fail2ban/jail.local`

Config settings depend on how your system logs auth data. If you're not sure just try both and restart afterwards.

For journalctl (if `journalctl -u ssh.service` has logs):

```txt
[sshd]
enabled = true
flter = sshd
port = ssh
backend = systemd
journalmatch = _SYSTEMD_UNIT=sshd.service
maxretry = 10
findtime = 600
bantime = 3600
```

For sshd (if `/var/log/auth.log` has logs):

```txt
[sshd]
enabled = true
filter = sshd
port = ssh
logpath = /var/log/auth.log
maxretry = 10          # number of allowed failed attempts before banning
findtime = 600        # time window in seconds to count failures
bantime = 3600        # ban duration in seconds
```

If the file `/var/log/auth.log` doesn't exist you might need to create it or your system probably doesn't even use it to begin with.

In reality I use more extreme rate limiting. If you ban yourself you can probably bypass it with some console or physical access to the machine.

_**Sidenote:** on some systems this config wont't work because fail2ban can't find the auth logs. Research the `logpath` and `backend` options for the jail config and check auth logging settings in `/etc/ssh/sshd_config`._

3. Restart fail2ban

```bash
sudo systemctl restart fail2ban
```

4. Verify status

```bash
sudo fail2ban-client status sshd
```

For debugging check `/var/log/fail2ban.log`.

Come back later and check `sudo lastb` to see whether attempts are actually getting banned or not.

Done.
