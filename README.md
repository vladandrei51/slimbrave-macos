# SlimBrave for macOS

A lightweight script to debloat Brave Browser on macOS by disabling telemetry, unwanted features, and promotional content through policy preferences.

## What It Does

SlimBrave removes bloat from Brave Browser while keeping its core privacy features intact. It disables telemetry, crypto features, promotional content, and other unnecessary components that slow down your browser.

## Ok, ok; but how?

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

### Telemetry & Privacy
- **MetricsReportingEnabled** - Stops Brave from collecting and sending usage statistics
- **SafeBrowsingExtendedReportingEnabled** - Disables extended Safe Browsing data collection
- **UrlKeyedAnonymizedDataCollectionEnabled** - Prevents URL-based data collection
- **FeedbackSurveysEnabled** - Removes annoying feedback prompts

### Brave-Specific Features
- **BraveRewardsDisabled** - Removes the crypto rewards system
- **BraveWalletDisabled** - Disables the built-in crypto wallet
- **BraveVPNDisabled** - Removes Brave VPN promotions and features
- **BraveAIChatEnabled** - Disables Brave's AI assistant (Leo)
- **TorDisabled** - Disables Tor integration (re-enable if you use it)

### Bloat & Annoyances
- **ShoppingListEnabled** - Removes shopping list features
- **AlwaysOpenPdfExternally** - Opens PDFs in your default viewer instead of browser
- **TranslateEnabled** - Disables the translation feature
- **SpellcheckEnabled** - Turns off built-in spellcheck
- **PromotionsEnabled** - Removes promotional banners and notifications

## I'm sold, how to use it?

```bash
# Download the script

# Make it executable
chmod +x slimbrave.sh

# Run it
./slimbrave.sh
```

### Run in Interactive Mode (Default)

Simply run the script to access the menu:
```bash
./slimbrave.sh
```

You'll see options to:
1. Apply debloating settings
2. View current settings
3. Reset all settings to default
4. Exit

### Command-Line Modes

**Quick Apply (no prompts):**
```bash
./slimbrave.sh --apply
```

**View Current Settings:**
```bash
./slimbrave.sh --view
```

**Reset Everything:**
```bash
./slimbrave.sh --reset
```

## Important Notes

- **Restart Required**: After applying settings, you must restart Brave Browser for changes to take effect
- **Close Brave First**: For best results, close Brave before running the script
- **Reversible**: All changes can be undone using the reset option
- **Safe**: Only modifies policy preferences, doesn't touch Brave's installation files

## What If I Want Something Back?

If you disable something and want it back:

1. Run the script and select "Reset All Settings to Default"
2. Restart Brave Browser
3. All features will return to their original state

Alternatively, manually re-enable specific features:
```bash
defaults write com.brave.Browser BraveWalletDisabled -integer 0
```
