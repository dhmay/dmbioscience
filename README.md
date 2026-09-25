# dmbioscience.com

The static site for DM Bioscience LLC. It uses plain HTML and CSS, with no build step.

```
index.html              All the page text. Edit this to change content.
assets/css/style.css    Colors, fonts, and layout. The colors are defined at the top.
assets/img/logo.svg     Header logo (generated; don't edit by hand)
assets/img/og-image.png Link-preview image for LinkedIn, Slack, etc. (generated)
favicon.svg / .ico      Browser tab icon (generated). Kept at the root, where browsers look.
apple-touch-icon.png    iPhone/iPad home-screen icon (generated)
CNAME                   Tells GitHub Pages which domain to serve. Don't delete it.
_config.yml             Keeps design/ and this README off the live site.
design/                 Logo working files. Not published.
  dmbioscience_logo.svg     Inkscape source for the logo. Edit this one.
  favicon-source.svg        Source for the tab and home-screen icons ("DM" in the box)
  og-image.svg              Layout for the link-preview image
  logo-email-signature.png  400px logo for your email signature (display at 200px wide)
  build-assets.sh           Regenerates all the generated files above
  embed.py                  Helper used by build-assets.sh
```

## Updating the logo

After editing `design/dmbioscience_logo.svg` in Inkscape, run:
```bash
./design/build-assets.sh
```
That regenerates the header logo, icons, link-preview image, and email-signature PNG.
If you change the "DM" lettering, update `design/favicon-source.svg` too.

## Editing

1. Open `index.html` in any text editor. Each section starts with a comment such as `<!-- ===== SERVICES ===== -->`.
2. To preview, double-click `index.html` to open it in a browser.
3. Commit and push. GitHub Pages redeploys within about a minute.

## Deploying to GitHub Pages (one-time setup)

1. On GitHub, create a new **public** repo, for example `dmbioscience`. On a free account, Pages requires a public repo.
2. Push this folder:
   ```bash
   git add -A
   git commit -m "Initial site"
   git remote add origin git@github.com:dhmay/dmbioscience.git
   git push -u origin main
   ```
3. In the repo, go to **Settings → Pages**:
   - **Source:** Deploy from a branch. **Branch:** `main`, folder `/ (root)`. Save.
   - **Custom domain:** `dmbioscience.com` (the `CNAME` file should fill this in automatically).
4. Recommended: verify the domain so no one else can claim it on Pages. Go to your GitHub account **Settings → Pages → Add a domain** and follow the instructions. They have you add a TXT record at Porkbun.

## DNS at Porkbun

In Porkbun, go to **Domain Management → dmbioscience.com → DNS**.

1. **Delete** Porkbun's default parking records. These are usually an `ALIAS` on the root and a `CNAME` for `*` or `www` pointing to `pixie.porkbun.com`.
2. **Add** these records. Leave the Host field blank for the root domain:

| Type  | Host  | Answer                       |
|-------|-------|------------------------------|
| A     |       | 185.199.108.153              |
| A     |       | 185.199.109.153              |
| A     |       | 185.199.110.153              |
| A     |       | 185.199.111.153              |
| AAAA  |       | 2606:50c0:8000::153          |
| AAAA  |       | 2606:50c0:8001::153          |
| AAAA  |       | 2606:50c0:8002::153          |
| AAAA  |       | 2606:50c0:8003::153          |
| CNAME | www   | dhmay.github.io              |

3. Leave your **email records** alone (`MX`, `TXT`/SPF, DKIM) for damon@dmbioscience.com. Changing the website records doesn't affect email.
4. Wait for DNS to update. This usually takes minutes but can take a few hours. Then go back to **Settings → Pages**, wait for the DNS check to pass, and tick **Enforce HTTPS**. The certificate can take up to about an hour to be issued.

To check DNS from a terminal:
```bash
dig +short dmbioscience.com
dig +short www.dmbioscience.com
```
