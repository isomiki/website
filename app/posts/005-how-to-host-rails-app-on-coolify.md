# How to host a Rails + Hotwire app on Coolify

Hotwire uses Rails so this guide applies to any Rails app.
I assume you already have your Rails app working.
If not, see [this guide](/posts/004-how-to-create-rails-hotwire-app).
It also assumes you have Coolify set up and running.

1. Make a git repo

Make a repo for your project on some hosted git platform.

- If you make a public repo: just copy the URL for HTTPS.
- If you make a private repo: copy the URL for SSH. You will also need to set up an SSH key for it and add it to Coolify's "Keys & Tokens" page.

2. Create a new application in Coolify

- Go to "Projects" in the Coolify admin panel.
- Create a project if you didn't already.
- Create a new resource inside it.

On the next screen ("New Resource"):

- If it's public, select "Public Repository".
- If it's private, select "Private Repository (with Deploy Key)" and on the next screen select your private key.

On the next screen ("Select a repository"):

- Enter the repo URL you copied earlier.
- Enter the branch name you're using (`main`, `master`, ...).
- For Build Pack leave Nixpacks.
- For the Port, use `3000`.
- Leave "Is it a static site?" disabled.

3. Configure the application

- Change the silly name Coolify generates into something relevant.
- If you have a domain pointing to your server, enter it in "Domains". Use a FQDN, so include `https://`. Or just leave the ugly one Coolify generated.
- Scroll down to "Network" -> "Ports Exposes" and enter `3000`.
- Click "Save" on top, otherwise it will reset.

4. Set up environment variables

- On your local machine where you have Rails, run `rails secret` and copy the output.
- In Coolify, go to "Environment Variables". You can use the "Developer view" on top if you like but rememer to save changes.
- Set the following, using the rails secret you just generated:

```bash
RAILS_ENV=production
SECRET_KEY_BASE=your-rails-secret
```

5. Deploy

Now click "Deploy" in the top right corner. It will take some time. You can close the side panel that opens up.

Once you see a green "Running" on top of the Configuration screen, you can visit the domain you set before.

You're done.

## Notes

To set up an SSH key, run this in your terminal:

```bash
ssh-keygen -t ed25519 -C "your description" -f ~/.ssh/example
```

Copy your private key form `~/.ssh/example` to Coolify's Keys & Tokens settings and copy your public key from `~/.ssh/example.pub` to the key settings page of the git platform you're using.
