# SlimBrave for macOS

A lightweight, interactive script to debloat Brave Browser on macOS by disabling telemetry, unwanted features, and promotional content through policy preferences.

## What It Does

SlimBrave removes bloat from Brave Browser while keeping its core privacy features intact. It offers two modes:
- **Quick Debloat** - Apply a curated preset in seconds
- **Interactive Customize** - Choose exactly which features to disable with clear status indicators

## Personal Tool Disclaimer

This script was built for my personal use case - it disables features I don't need like telemetry, crypto/wallet integration, AI features, and promotional content. Your needs may differ.

The script is easily customizable. Review the [What Gets Disabled](#-what-gets-disabled) section and the script itself before running to ensure it matches your preferences.

I'm sharing this publicly in case it helps others, but use at your own discretion.

## Ok, ok; How does it work?

Brave Browser on macOS stores its policy configuration in a `.plist` file located at:

```
~/Library/Preferences/com.brave.Browser.plist
```

You can modify these policies in two ways:

1. **Direct file editing** - Using Xcode or other plist editors
2. **Terminal commands** - Using the `defaults` command

Example:
```bash
defaults write com.brave.Browser IncognitoModeAvailability -integer 1
```

This script automates the process using the `defaults` command to apply multiple privacy and performance optimizations at once.

## What Gets Disabled

### Quick Debloat Preset (Recommended)

The quick preset disables these features:

#### Telemetry & Privacy
- **MetricsReportingEnabled** - Stops Brave from collecting and sending usage statistics
- **SafeBrowsingExtendedReportingEnabled** - Disables extended Safe Browsing data collection
- **UrlKeyedAnonymizedDataCollectionEnabled** - Prevents URL-based data collection
- **FeedbackSurveysEnabled** - Removes annoying feedback prompts

#### Brave-Specific Features
- **BraveRewardsDisabled** - Removes the crypto rewards system
- **BraveWalletDisabled** - Disables the built-in crypto wallet
- **BraveVPNDisabled** - Removes Brave VPN promotions and features
- **BraveAIChatEnabled** - Disables Brave's AI assistant (Leo)
- **TorDisabled** - Disables Tor integration (re-enable if you use it)

#### Bloat & Annoyances
- **ShoppingListEnabled** - Removes shopping list features
- **AlwaysOpenPdfExternally** - Opens PDFs in your default viewer instead of browser
- **TranslateEnabled** - Disables the translation feature
- **SpellcheckEnabled** - Turns off built-in spellcheck
- **PromotionsEnabled** - Removes promotional banners and notifications

### Interactive Mode (34 Settings Available)

In interactive mode, you can customize all available settings across 5 categories:

1. **Telemetry & Privacy** (4 settings)
2. **Privacy & Security** (12 settings) - Autofill, passwords, cookies, WebRTC, etc.
3. **Brave Features** (6 settings) - Rewards, wallet, VPN, AI, Tor, Sync
4. **Performance & Bloat** (11 settings) - Background mode, recommendations, search suggestions, etc.
5. **DNS Settings** (3 modes) - automatic/off/custom

Each setting shows:
- **✓ ACTIVE** (green) - Policy is currently applied
- **○ DEFAULT** (yellow) - Using Brave's default setting
- **✗ INACTIVE** (red) - Policy not applied

## Installation & Usage

### Quick Install

```bash
# Download the script

# Make it executable
chmod +x slimbrave.sh

# Run it
./slimbrave.sh
```

<img width="789" height="619" alt="image" src="https://github.com/user-attachments/assets/96f97527-d109-41b4-ac31-45d25781df74" />

<img width="789" height="619" alt="image" src="https://github.com/user-attachments/assets/1b934934-4d77-4cbc-8cc5-39a93b6ccc28" />



You'll see 5 options:

1. **Quick Debloat (Recommended Preset)** - Apply the curated list of settings instantly
2. **Interactive Customize** - Step through each category and choose what to disable
3. **View Current Settings** - See what's currently configured
4. **Reset All Settings to Default** - Undo all changes
5. **Exit**

### Command-Line Modes (Non-Interactive)

**Quick Apply (no prompts):**
```bash
./slimbrave.sh --apply
# or
./slimbrave.sh -a
```

**View Current Settings:**
```bash
./slimbrave.sh --view
# or
./slimbrave.sh -v
```

**Reset Everything:**
```bash
./slimbrave.sh --reset
# or
./slimbrave.sh -r
```

## What If I Want Something Back?

### Option 1: Reset Everything

If you want to undo all changes:

1. Run the script and select "Reset All Settings to Default"
2. Type `yes` to confirm
3. Restart Brave Browser
4. All features will return to their original state

### Option 2: Toggle Individual Settings

Use the Interactive Customize mode to:

1. Run `./slimbrave.sh`
2. Select option 2 (Interactive Customize)
3. Toggle only the settings you want to change
4. Leave others as-is

### Option 3: Manual Command

Manually re-enable specific features:
```bash
# Re-enable Brave Wallet
defaults write com.brave.Browser BraveWalletDisabled -integer 0

# Re-enable Tor
defaults write com.brave.Browser TorDisabled -integer 0

# Re-enable Spellcheck
defaults write com.brave.Browser SpellcheckEnabled -integer 1
```
