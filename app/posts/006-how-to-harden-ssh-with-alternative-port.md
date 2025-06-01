# How to harden your SSH configuration and use an alternative port

> We'll use an SSH key instead of a password for login, we'll use a custom SSH port and tweak some other settings.

1. **Open a terminal session on the target machine**
2. **Before you change anything, add your key or you might get locked out**

- Generate a key if you don't have one (use your own options):

```bash
ssh-keygen -t ed25519 -C "My favorite server" -f ~/.ssh/pokemon
```

- Add the public key to a new line in `/home/pikachu/.ssh/authorized_keys` on the target machine

3. **Pick an alternative port for SSH**

Use something above the privileged range of 1023. Don't use common alternatives like 2222. I also check the port list on wikipedia to see if there's another common service which might conflict later. Now forward that port, e.g.

```bash
sudo ufw allow 12345
```

You might have a different firewall tool 4. Configure SSHD:

```bash
sudo vim /etc/ssh/sshd_config
```

Set these options:

- `Port 12345` Set it to your new port
- `PermitRootLogin prohibit-password` Self explanatory
- `PasswordAuthentication no` Forbids password login for other users too
- `X11Forwarding no` X11 has vulnerabilities and you probably aren't using X11 forwarding anyway. Even if you use X11 or VNC this won't interfere.
- `AllowUsers pikachu` Specify your user(s) here. If you have multiple, separate them with spaces. This might not even be necessary, I forgot, but I think with the particular setup above this is required.

5. **Restart the ssh daemon**

```bash
sudo systemctl restart sshd
```

> Don't disconnect yet, keep the session in case you broke something.

Log in from a new terminal session. Specify your new port and key:

```bash
ssh -p 12345 -i ~/.ssh/pokemon pikachu@some-address
```

Use the target's IP or hostname of course.

6. **Make logging in easier for yourself**

On your local machine, configure your connection in `~/.ssh/config`:

```txt
Host pokemon
    HostName some-address
    User pikachu
    IdentityFile ~/.ssh/pokemon
    Port 12345
```

Then you can connect like this:

```bash
alias s='ssh pikachu@pokemon'
```

## Rate limiting

I also like to ban IPs which fail login repeatedly.

1. Install `fail2ban`
2. Enable auth logging for sshd in `/etc/ssh/sshd_config`

```txt
SyslogFacility AUTH
LogLevel INFO
```

3. Configure fail2ban in `/etc/fail2ban/jail.local`

The config you need depends on how your system logs auth data. If you're not sure just try both.

For journalctl (if `journalctl -u ssh.service` shows fresh logs):

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

For sshd:

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

_**Sidenote:** on some systems this config wont't work because fail2ban can't find the auth logs. Research the `logpath` and `backend` options for the jail config._

4. Restart fail2ban

```bash
sudo systemctl restart fail2ban
```

5. Verify status

```bash
sudo fail2ban-client status sshd
```

For debugging check `/var/log/fail2ban.log`.

Come back later and check `sudo lastb` to see whether attempts are actually getting banned or not.

Done.
