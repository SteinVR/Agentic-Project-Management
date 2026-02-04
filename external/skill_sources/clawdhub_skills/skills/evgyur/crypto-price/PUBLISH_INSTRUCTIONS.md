# 🚀 Publishing Instructions

## ✅ What's Ready

All files are prepared and committed locally:
- ✅ README.md with full documentation
- ✅ SKILL.md (Clawdbot skill definition)
- ✅ Python script with chart generation
- ✅ requirements.txt
- ✅ LICENSE (MIT)
- ✅ GitHub Actions workflow
- ✅ .gitignore
- ✅ Git repository initialized

## 📋 Next Steps

### 1. Create GitHub Repository

1. Go to: https://github.com/new
2. Repository name: `crypto-price`
3. Description: `📈 Clawdbot skill for cryptocurrency price lookup and candlestick chart generation`
4. Visibility: **Public** (required for ClawdHub)
5. **Important**: Do NOT initialize with README, .gitignore, or license
6. Click "Create repository"

### 2. Push to GitHub

```bash
cd /home/eyurc/clawd/skills/crypto-price

# Add remote
git remote add origin git@github.com:evgyur/crypto-price.git

# Rename branch to main
git branch -M main

# Push to GitHub
git push -u origin main
```

### 3. Create GitHub Release

```bash
# Create and push tag
git tag -a v1.0.0 -m "Initial release: Crypto Price & Chart skill"
git push origin v1.0.0
```

Or via GitHub UI:
- Go to repository → Releases → "Create a new release"
- Tag: `v1.0.0`
- Title: `v1.0.0 - Initial Release`
- Description: Copy from README.md Features section

### 4. Publish to ClawdHub

ClawdHub auto-discovers skills from GitHub. After pushing:

1. **Wait 24-48 hours** for auto-discovery, OR
2. **Manual submission**:
   - Visit https://clawdhub.com
   - Contact maintainers or use submission form
   - Provide: `https://github.com/evgyur/crypto-price`

### 5. Verify Publication

Once on ClawdHub:
- Skill page: `https://clawdhub.com/evgyur/crypto-price`
- Installation: `clawdhub install evgyur/crypto-price`

## 📁 Repository Structure

```
crypto-price/
├── .clawdhub/
│   └── origin.json          # ClawdHub metadata
├── .github/
│   └── workflows/
│       └── test.yml          # CI/CD tests
├── scripts/
│   └── get_price_chart.py   # Main script (701 lines)
├── .gitignore
├── LICENSE                  # MIT License
├── PUBLISH.md               # This file
├── QUICK_START.md           # Quick start guide
├── README.md                # Full documentation
├── requirements.txt         # Python dependencies
└── SKILL.md                 # Clawdbot skill definition
```

## ✨ Features to Highlight

- 🚀 Fast price lookup via CoinGecko and Hyperliquid APIs
- 📊 Beautiful candlestick charts (8x8 square, dark theme)
- ⚡ Smart caching (5-minute TTL)
- 🎯 Multiple data sources with automatic fallback
- 📱 Flexible timeframes (30m, 3h, 12h, 24h, 2d)
- 🔧 Works with slash commands: `/hype`, `/token`, `/btc`, `/eth`, etc.

## 📝 GitHub Repository Settings

After creating the repo, consider:
- ✅ Enable GitHub Actions
- ✅ Add topics: `clawdbot`, `clawdbot-skill`, `cryptocurrency`, `trading`, `charts`
- ✅ Add description: `📈 Clawdbot skill for cryptocurrency price lookup and candlestick chart generation`

## 🎯 ClawdHub Description

When submitting to ClawdHub, use this description:

> Get cryptocurrency token prices and generate beautiful candlestick charts. Supports CoinGecko and Hyperliquid APIs with smart caching. Works with popular slash commands like /hype, /token, /btc, /eth, and more. Generates 8x8 square charts with dark theme.

## ✅ Checklist

- [ ] GitHub repository created (public)
- [ ] Code pushed to GitHub
- [ ] GitHub release v1.0.0 created
- [ ] Repository topics added
- [ ] ClawdHub submission (auto or manual)
- [ ] Skill verified on ClawdHub
- [ ] Installation tested: `clawdhub install evgyur/crypto-price`
