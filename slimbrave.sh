#!/bin/bash

# SlimBrave for macOS - Interactive Debloater
# Applies privacy and debloating settings to Brave Browser

PLIST_DOMAIN="com.brave.Browser"

# Color codes for terminal output using tput
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
BOLD=$(tput bold)
NC=$(tput sgr0)

# Temporary file to store user selections
SELECTION_FILE="/tmp/slimbrave_selections.tmp"

# Function to display header
show_header() {
    clear
    echo "${BLUE}╔════════════════════════════════════════════╗${NC}"
    echo "${BLUE}║         SlimBrave for macOS v3.0           ║${NC}"
    echo "${BLUE}║    Interactive Brave Browser Debloater     ║${NC}"
    echo "${BLUE}╚════════════════════════════════════════════╝${NC}"
    echo ""
}

# Check if Brave is installed
check_brave() {
    if [ ! -d "/Applications/Brave Browser.app" ]; then
        echo "${RED}Error: Brave Browser not found in /Applications/${NC}"
        echo "${YELLOW}Please install Brave Browser first.${NC}"
        exit 1
    fi
}

# Check if Brave is running
check_brave_running() {
    if pgrep -x "Brave Browser" > /dev/null; then
        echo "${YELLOW}⚠️  Brave Browser is currently running.${NC}"
        echo "${YELLOW}For best results, please close Brave before continuing.${NC}"
        echo ""
        read -p "Do you want to continue anyway? (y/n): " continue_choice
        if [[ ! "$continue_choice" =~ ^[Yy]$ ]]; then
            echo "${BLUE}Exiting. Please close Brave and run the script again.${NC}"
            exit 0
        fi
        echo ""
    fi
}

# Function to apply a setting
apply_setting() {
    local key=$1
    local value=$2
    local type=$3
    
    case $type in
        "integer")
            defaults write "$PLIST_DOMAIN" "$key" -integer "$value"
            ;;
        "bool")
            defaults write "$PLIST_DOMAIN" "$key" -bool "$value"
            ;;
        "string")
            defaults write "$PLIST_DOMAIN" "$key" -string "$value"
            ;;
    esac
}

# Function to check if setting is currently enabled
is_setting_enabled() {
    local key=$1
    local value=$(defaults read "$PLIST_DOMAIN" "$key" 2>/dev/null)
    
    if [ $? -eq 0 ]; then
        echo "$value"
    else
        echo "not_set"
    fi
}

# Quick preset - Original minimal debloat
apply_quick_preset() {
    echo "${CYAN}Applying Quick Debloat Preset...${NC}"
    echo ""
    echo "${BLUE}[Telemetry & Privacy]${NC}"
    
    apply_setting "MetricsReportingEnabled" 0 "integer"
    echo "${GREEN}✓${NC} Disabled Metrics Reporting"
    
    apply_setting "SafeBrowsingExtendedReportingEnabled" 0 "integer"
    echo "${GREEN}✓${NC} Disabled Safe Browsing Extended Reporting"
    
    apply_setting "UrlKeyedAnonymizedDataCollectionEnabled" 0 "integer"
    echo "${GREEN}✓${NC} Disabled URL Data Collection"
    
    apply_setting "FeedbackSurveysEnabled" 0 "integer"
    echo "${GREEN}✓${NC} Disabled Feedback Surveys"
    
    echo ""
    echo "${BLUE}[Brave Features]${NC}"
    
    apply_setting "BraveRewardsDisabled" 1 "integer"
    echo "${GREEN}✓${NC} Disabled Brave Rewards"
    
    apply_setting "BraveWalletDisabled" 1 "integer"
    echo "${GREEN}✓${NC} Disabled Brave Wallet"
    
    apply_setting "BraveVPNDisabled" 1 "integer"
    echo "${GREEN}✓${NC} Disabled Brave VPN"
    
    apply_setting "BraveAIChatEnabled" 0 "integer"
    echo "${GREEN}✓${NC} Disabled Brave AI Chat"
    
    apply_setting "TorDisabled" 1 "integer"
    echo "${GREEN}✓${NC} Disabled Tor"
    
    echo ""
    echo "${BLUE}[Bloat Removal]${NC}"
    
    apply_setting "ShoppingListEnabled" 0 "integer"
    echo "${GREEN}✓${NC} Disabled Shopping List"
    
    apply_setting "AlwaysOpenPdfExternally" 1 "integer"
    echo "${GREEN}✓${NC} Set PDFs to Open Externally"
    
    apply_setting "TranslateEnabled" 0 "integer"
    echo "${GREEN}✓${NC} Disabled Translate"
    
    apply_setting "SpellcheckEnabled" 0 "integer"
    echo "${GREEN}✓${NC} Disabled Spellcheck"
    
    apply_setting "PromotionsEnabled" 0 "integer"
    echo "${GREEN}✓${NC} Disabled Promotions"
    
    echo ""
    echo "${GREEN}═══════════════════════════════════════════${NC}"
    echo "${GREEN}✓ Quick Debloat applied successfully!${NC}"
    echo "${GREEN}═══════════════════════════════════════════${NC}"
    echo ""
    echo "${YELLOW}⚠️  Please restart Brave Browser for changes to take effect.${NC}"
}

# Interactive customization menu
interactive_customize() {
    show_header
    echo "${CYAN}Interactive Customization Mode${NC}"
    echo ""
    echo "Select features to toggle. Current status shown for each setting."
    echo "${YELLOW}Note: Changes will be applied after you finish selecting.${NC}"
    echo ""
    
    # Initialize selections file
    > "$SELECTION_FILE"
    
    local categories=(
        "Telemetry & Privacy"
        "Privacy & Security"
        "Brave Features"
        "Performance & Bloat"
        "DNS Settings"
    )
    
    for category in "${categories[@]}"; do
        customize_category "$category"
    done
    
    # Apply selected changes
    apply_custom_selections
}

# Customize specific category
customize_category() {
    local category=$1
    
    case "$category" in
        "Telemetry & Privacy")
            show_category_header "$category"
            toggle_setting "MetricsReportingEnabled" "Disable Metrics Reporting" 0 "integer"
            toggle_setting "SafeBrowsingExtendedReportingEnabled" "Disable Safe Browsing Extended Reporting" 0 "integer"
            toggle_setting "UrlKeyedAnonymizedDataCollectionEnabled" "Disable URL Data Collection" 0 "integer"
            toggle_setting "FeedbackSurveysEnabled" "Disable Feedback Surveys" 0 "integer"
            ;;
            
        "Privacy & Security")
            show_category_header "$category"
            toggle_setting "SafeBrowsingProtectionLevel" "Disable Safe Browsing" 0 "integer"
            toggle_setting "AutofillAddressEnabled" "Disable Autofill (Addresses)" 0 "integer"
            toggle_setting "AutofillCreditCardEnabled" "Disable Autofill (Credit Cards)" 0 "integer"
            toggle_setting "PasswordManagerEnabled" "Disable Password Manager" 0 "integer"
            toggle_setting "BrowserSignin" "Disable Browser Sign-in" 0 "integer"
            toggle_setting "WebRtcIPHandling" "Disable WebRTC IP Leak" "disable_non_proxied_udp" "string"
            toggle_setting "QuicAllowed" "Disable QUIC Protocol" 0 "integer"
            toggle_setting "BlockThirdPartyCookies" "Block Third Party Cookies" 1 "integer"
            toggle_setting "EnableDoNotTrack" "Enable Do Not Track" 1 "integer"
            toggle_setting "ForceGoogleSafeSearch" "Force Google SafeSearch" 1 "integer"
            toggle_setting "IPFSEnabled" "Disable IPFS" 0 "integer"
            toggle_setting "IncognitoModeAvailability" "Disable Incognito Mode" 1 "integer"
            ;;
            
        "Brave Features")
            show_category_header "$category"
            toggle_setting "BraveRewardsDisabled" "Disable Brave Rewards" 1 "integer"
            toggle_setting "BraveWalletDisabled" "Disable Brave Wallet" 1 "integer"
            toggle_setting "BraveVPNDisabled" "Disable Brave VPN" 1 "integer"
            toggle_setting "BraveAIChatEnabled" "Disable Brave AI Chat" 0 "integer"
            toggle_setting "TorDisabled" "Disable Tor" 1 "integer"
            toggle_setting "SyncDisabled" "Disable Sync" 1 "integer"
            ;;
            
        "Performance & Bloat")
            show_category_header "$category"
            toggle_setting "BackgroundModeEnabled" "Disable Background Mode" 0 "integer"
            toggle_setting "MediaRecommendationsEnabled" "Disable Media Recommendations" 0 "integer"
            toggle_setting "ShoppingListEnabled" "Disable Shopping List" 0 "integer"
            toggle_setting "AlwaysOpenPdfExternally" "Always Open PDF Externally" 1 "integer"
            toggle_setting "TranslateEnabled" "Disable Translate" 0 "integer"
            toggle_setting "SpellcheckEnabled" "Disable Spellcheck" 0 "integer"
            toggle_setting "PromotionsEnabled" "Disable Promotions" 0 "integer"
            toggle_setting "SearchSuggestEnabled" "Disable Search Suggestions" 0 "integer"
            toggle_setting "PrintingEnabled" "Disable Printing" 0 "integer"
            toggle_setting "DefaultBrowserSettingEnabled" "Disable Default Browser Prompt" 0 "integer"
            toggle_setting "DeveloperToolsDisabled" "Disable Developer Tools" 1 "integer"
            ;;
            
        "DNS Settings")
            show_category_header "$category"
            select_dns_mode
            ;;
    esac
    
    echo ""
    read -p "Press Enter to continue to next category..."
}

show_category_header() {
    clear
    show_header
    echo "${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo "${MAGENTA}  $1${NC}"
    echo "${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

toggle_setting() {
    local key=$1
    local description=$2
    local target_value=$3
    local type=$4
    
    local current=$(is_setting_enabled "$key")
    local status
    local help_text
    
    # Determine if this is a "disable" or "enable" type setting
    if [[ "$description" == Disable* ]]; then
        # For "Disable X" settings
        if [ "$current" = "$target_value" ]; then
            status="${GREEN}✓ ACTIVE${NC}"
            help_text="${GREEN}(feature is disabled)${NC}"
        elif [ "$current" = "not_set" ]; then
            status="${YELLOW}○ DEFAULT${NC}"
            help_text="${YELLOW}(feature is enabled by default)${NC}"
        else
            status="${RED}✗ INACTIVE${NC}"
            help_text="${RED}(feature is enabled)${NC}"
        fi
    elif [[ "$description" == Enable* ]] || [[ "$description" == Block* ]] || [[ "$description" == Force* ]]; then
        # For "Enable X" or "Block X" settings
        if [ "$current" = "$target_value" ]; then
            status="${GREEN}✓ ACTIVE${NC}"
            help_text="${GREEN}(feature is enabled)${NC}"
        elif [ "$current" = "not_set" ]; then
            status="${YELLOW}○ DEFAULT${NC}"
            help_text="${YELLOW}(feature is disabled by default)${NC}"
        else
            status="${RED}✗ INACTIVE${NC}"
            help_text="${RED}(feature is disabled)${NC}"
        fi
    else
        # For other settings (like "Always Open PDF")
        if [ "$current" = "$target_value" ]; then
            status="${GREEN}✓ ACTIVE${NC}"
            help_text=""
        elif [ "$current" = "not_set" ]; then
            status="${YELLOW}○ DEFAULT${NC}"
            help_text="${YELLOW}(using default behavior)${NC}"
        else
            status="${RED}✗ INACTIVE${NC}"
            help_text=""
        fi
    fi
    
    echo "$status $description $help_text"
    read -p "    Toggle this setting? (y/[n]): " choice
    
    # Default to 'n' if empty
    choice=${choice:-n}
    
    if [[ "$choice" =~ ^[Yy]$ ]]; then
        echo "$key|$target_value|$type" >> "$SELECTION_FILE"
        echo "    ${CYAN}→ Will be toggled${NC}"
    fi
    echo ""
}

select_dns_mode() {
    local current=$(is_setting_enabled "DnsOverHttpsMode")
    
    echo "Current DNS Mode: ${CYAN}$current${NC}"
    echo ""
    echo "Select DNS Over HTTPS Mode:"
    echo "  1. automatic (recommended)"
    echo "  2. off"
    echo "  3. custom"
    echo "  4. Skip (no change)"
    echo ""
    read -p "Select option (1-4): " dns_choice
    
    case $dns_choice in
        1)
            echo "DnsOverHttpsMode|automatic|string" >> "$SELECTION_FILE"
            echo "${CYAN}→ Will set to 'automatic'${NC}"
            ;;
        2)
            echo "DnsOverHttpsMode|off|string" >> "$SELECTION_FILE"
            echo "${CYAN}→ Will set to 'off'${NC}"
            ;;
        3)
            echo "DnsOverHttpsMode|custom|string" >> "$SELECTION_FILE"
            echo "${CYAN}→ Will set to 'custom'${NC}"
            ;;
        4)
            echo "${YELLOW}Skipping DNS setting${NC}"
            ;;
    esac
}

apply_custom_selections() {
    clear
    show_header
    echo "${CYAN}Applying your custom selections...${NC}"
    echo ""
    
    if [ ! -s "$SELECTION_FILE" ]; then
        echo "${YELLOW}No changes selected.${NC}"
        rm -f "$SELECTION_FILE"
        return
    fi
    
    while IFS='|' read -r key value type; do
        apply_setting "$key" "$value" "$type"
        echo "${GREEN}✓${NC} Applied: $key"
    done < "$SELECTION_FILE"
    
    rm -f "$SELECTION_FILE"
    
    echo ""
    echo "${GREEN}═══════════════════════════════════════════${NC}"
    echo "${GREEN}✓ Custom settings applied successfully!${NC}"
    echo "${GREEN}═══════════════════════════════════════════${NC}"
    echo ""
    echo "${YELLOW}⚠️  Please restart Brave Browser for changes to take effect.${NC}"
}

# Function to reset all settings
reset_settings() {
    echo ""
    echo "${RED}═══════════════════════════════════════════${NC}"
    echo "${RED}    WARNING: RESET ALL SETTINGS${NC}"
    echo "${RED}═══════════════════════════════════════════${NC}"
    echo ""
    echo "This will remove ALL Brave policy settings and restore"
    echo "Brave to its default configuration."
    echo ""
    read -p "Are you absolutely sure? Type 'yes' to confirm: " confirm
    
    if [ "$confirm" = "yes" ]; then
        defaults delete "$PLIST_DOMAIN" 2>/dev/null
        if [ $? -eq 0 ]; then
            echo ""
            echo "${GREEN}✓ All Brave policy settings have been reset.${NC}"
            echo "${YELLOW}⚠️  Please restart Brave Browser.${NC}"
        else
            echo ""
            echo "${YELLOW}No settings found to reset (Brave may already be at defaults).${NC}"
        fi
    else
        echo ""
        echo "${BLUE}Reset cancelled.${NC}"
    fi
}

# Function to view current settings
view_settings() {
    echo ""
    echo "${CYAN}Current Brave Policy Settings:${NC}"
    echo "${CYAN}══════════════════════════════${NC}"
    echo ""
    
    if defaults read "$PLIST_DOMAIN" &>/dev/null; then
        settings=(
            "MetricsReportingEnabled"
            "SafeBrowsingExtendedReportingEnabled"
            "UrlKeyedAnonymizedDataCollectionEnabled"
            "FeedbackSurveysEnabled"
            "SafeBrowsingProtectionLevel"
            "AutofillAddressEnabled"
            "AutofillCreditCardEnabled"
            "PasswordManagerEnabled"
            "BrowserSignin"
            "WebRtcIPHandling"
            "QuicAllowed"
            "BlockThirdPartyCookies"
            "EnableDoNotTrack"
            "ForceGoogleSafeSearch"
            "IPFSEnabled"
            "IncognitoModeAvailability"
            "BraveRewardsDisabled"
            "BraveWalletDisabled"
            "BraveVPNDisabled"
            "BraveAIChatEnabled"
            "TorDisabled"
            "SyncDisabled"
            "BackgroundModeEnabled"
            "MediaRecommendationsEnabled"
            "ShoppingListEnabled"
            "AlwaysOpenPdfExternally"
            "TranslateEnabled"
            "SpellcheckEnabled"
            "PromotionsEnabled"
            "SearchSuggestEnabled"
            "PrintingEnabled"
            "DefaultBrowserSettingEnabled"
            "DeveloperToolsDisabled"
            "DnsOverHttpsMode"
        )
        
        for setting in "${settings[@]}"; do
            value=$(defaults read "$PLIST_DOMAIN" "$setting" 2>/dev/null)
            if [ $? -eq 0 ]; then
                echo "${GREEN}✓${NC} $setting = $value"
            else
                echo "${YELLOW}○${NC} $setting = (not set)"
            fi
        done
    else
        echo "${YELLOW}No policies currently set (using Brave defaults)${NC}"
    fi
    
    echo ""
}

# Main menu
show_menu() {
    show_header
    echo "${CYAN}What would you like to do?${NC}"
    echo ""
    echo "  ${GREEN}1.${NC} Quick Debloat (Recommended Preset)"
    echo "  ${BLUE}2.${NC} Interactive Customize (Choose Each Setting)"
    echo "  ${YELLOW}3.${NC} View Current Settings"
    echo "  ${RED}4.${NC} Reset All Settings to Default"
    echo "  ${CYAN}5.${NC} Exit"
    echo ""
    read -p "Select an option (1-5): " choice
    
    case $choice in
        1)
            echo ""
            apply_quick_preset
            echo ""
            read -p "Press Enter to continue..."
            show_menu
            ;;
        2)
            interactive_customize
            echo ""
            read -p "Press Enter to continue..."
            show_menu
            ;;
        3)
            view_settings
            read -p "Press Enter to continue..."
            show_menu
            ;;
        4)
            reset_settings
            echo ""
            read -p "Press Enter to continue..."
            show_menu
            ;;
        5)
            echo ""
            echo "${GREEN}Thanks for using SlimBrave! Goodbye!${NC}"
            echo ""
            exit 0
            ;;
        *)
            echo "${RED}Invalid option. Please select 1-5.${NC}"
            sleep 1
            show_menu
            ;;
    esac
}

# Quick apply mode (with --apply flag)
if [ "$1" = "--apply" ] || [ "$1" = "-a" ]; then
    show_header
    check_brave
    check_brave_running
    apply_quick_preset
    echo ""
    exit 0
fi

# Quick reset mode (with --reset flag)
if [ "$1" = "--reset" ] || [ "$1" = "-r" ]; then
    show_header
    check_brave
    reset_settings
    echo ""
    exit 0
fi

# Quick view mode (with --view flag)
if [ "$1" = "--view" ] || [ "$1" = "-v" ]; then
    show_header
    check_brave
    view_settings
    exit 0
fi

# Interactive mode (default)
check_brave
check_brave_running
show_menu
