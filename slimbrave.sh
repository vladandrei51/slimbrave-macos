#!/bin/bash

# SlimBrave for macOS - Direct Debloater
# Applies essential privacy and debloating settings to Brave Browser

PLIST_DOMAIN="com.brave.Browser"

# Color codes for terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to display header
show_header() {
    clear
    echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║         SlimBrave for macOS v2.0           ║${NC}"
    echo -e "${BLUE}║      Quick Brave Browser Debloater         ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════╝${NC}"
    echo ""
}

# Check if Brave is installed
check_brave() {
    if [ ! -d "/Applications/Brave Browser.app" ]; then
        echo -e "${RED}Error: Brave Browser not found in /Applications/${NC}"
        echo -e "${YELLOW}Please install Brave Browser first.${NC}"
        exit 1
    fi
}

# Check if Brave is running
check_brave_running() {
    if pgrep -x "Brave Browser" > /dev/null; then
        echo -e "${YELLOW}⚠️  Brave Browser is currently running.${NC}"
        echo -e "${YELLOW}For best results, please close Brave before continuing.${NC}"
        echo ""
        read -p "Do you want to continue anyway? (y/n): " continue_choice
        if [[ ! "$continue_choice" =~ ^[Yy]$ ]]; then
            echo -e "${BLUE}Exiting. Please close Brave and run the script again.${NC}"
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

# Main debloating function
apply_debloat_settings() {
    echo -e "${CYAN}Applying debloating settings...${NC}"
    echo ""
    
    # Telemetry & Reporting
    echo -e "${BLUE}[Telemetry & Privacy]${NC}"
    
    apply_setting "MetricsReportingEnabled" 0 "integer"
    echo -e "${GREEN}✓${NC} Disabled Metrics Reporting"
    
    apply_setting "SafeBrowsingExtendedReportingEnabled" 0 "integer"
    echo -e "${GREEN}✓${NC} Disabled Safe Browsing Extended Reporting"
    
    apply_setting "UrlKeyedAnonymizedDataCollectionEnabled" 0 "integer"
    echo -e "${GREEN}✓${NC} Disabled URL Data Collection"
    
    apply_setting "FeedbackSurveysEnabled" 0 "integer"
    echo -e "${GREEN}✓${NC} Disabled Feedback Surveys"
    
    echo ""
    
    # Brave Features
    echo -e "${BLUE}[Brave Features]${NC}"
    
    apply_setting "BraveRewardsDisabled" 1 "integer"
    echo -e "${GREEN}✓${NC} Disabled Brave Rewards"
    
    apply_setting "BraveWalletDisabled" 1 "integer"
    echo -e "${GREEN}✓${NC} Disabled Brave Wallet"
    
    apply_setting "BraveVPNDisabled" 1 "integer"
    echo -e "${GREEN}✓${NC} Disabled Brave VPN"
    
    apply_setting "BraveAIChatEnabled" 0 "integer"
    echo -e "${GREEN}✓${NC} Disabled Brave AI Chat"
    
    apply_setting "TorDisabled" 1 "integer"
    echo -e "${GREEN}✓${NC} Disabled Tor"
    
    echo ""
    
    # Bloat Features
    echo -e "${BLUE}[Bloat Removal]${NC}"
    
    apply_setting "ShoppingListEnabled" 0 "integer"
    echo -e "${GREEN}✓${NC} Disabled Shopping List"
    
    apply_setting "AlwaysOpenPdfExternally" 1 "integer"
    echo -e "${GREEN}✓${NC} Set PDFs to Open Externally"
    
    apply_setting "TranslateEnabled" 0 "integer"
    echo -e "${GREEN}✓${NC} Disabled Translate"
    
    apply_setting "SpellcheckEnabled" 0 "integer"
    echo -e "${GREEN}✓${NC} Disabled Spellcheck"
    
    apply_setting "PromotionsEnabled" 0 "integer"
    echo -e "${GREEN}✓${NC} Disabled Promotions"
    
    echo ""
    echo -e "${GREEN}═══════════════════════════════════════════${NC}"
    echo -e "${GREEN}✓ All debloating settings applied successfully!${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════${NC}"
    echo ""
    echo -e "${YELLOW}⚠️  Please restart Brave Browser for changes to take effect.${NC}"
}

# Function to reset all settings
reset_settings() {
    echo ""
    echo -e "${RED}═══════════════════════════════════════════${NC}"
    echo -e "${RED}    WARNING: RESET ALL SETTINGS${NC}"
    echo -e "${RED}═══════════════════════════════════════════${NC}"
    echo ""
    echo "This will remove ALL Brave policy settings and restore"
    echo "Brave to its default configuration."
    echo ""
    read -p "Are you absolutely sure? Type 'yes' to confirm: " confirm
    
    if [ "$confirm" = "yes" ]; then
        defaults delete "$PLIST_DOMAIN" 2>/dev/null
        if [ $? -eq 0 ]; then
            echo ""
            echo -e "${GREEN}✓ All Brave policy settings have been reset.${NC}"
            echo -e "${YELLOW}⚠️  Please restart Brave Browser.${NC}"
        else
            echo ""
            echo -e "${YELLOW}No settings found to reset (Brave may already be at defaults).${NC}"
        fi
    else
        echo ""
        echo -e "${BLUE}Reset cancelled.${NC}"
    fi
}

# Function to view current settings
view_settings() {
    echo ""
    echo -e "${CYAN}Current Brave Policy Settings:${NC}"
    echo -e "${CYAN}══════════════════════════════${NC}"
    echo ""
    
    if defaults read "$PLIST_DOMAIN" &>/dev/null; then
        # List only the settings we care about
        settings=(
            "MetricsReportingEnabled"
            "SafeBrowsingExtendedReportingEnabled"
            "UrlKeyedAnonymizedDataCollectionEnabled"
            "FeedbackSurveysEnabled"
            "BraveRewardsDisabled"
            "BraveWalletDisabled"
            "BraveVPNDisabled"
            "BraveAIChatEnabled"
            "TorDisabled"
            "ShoppingListEnabled"
            "AlwaysOpenPdfExternally"
            "TranslateEnabled"
            "SpellcheckEnabled"
            "PromotionsEnabled"
        )
        
        for setting in "${settings[@]}"; do
            value=$(defaults read "$PLIST_DOMAIN" "$setting" 2>/dev/null)
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}✓${NC} $setting = $value"
            else
                echo -e "${YELLOW}○${NC} $setting = (not set)"
            fi
        done
    else
        echo -e "${YELLOW}No policies currently set (using Brave defaults)${NC}"
    fi
    
    echo ""
}

# Main menu
show_menu() {
    show_header
    echo -e "${CYAN}What would you like to do?${NC}"
    echo ""
    echo "  1. Apply Debloating Settings"
    echo "  2. View Current Settings"
    echo "  3. Reset All Settings to Default"
    echo "  4. Exit"
    echo ""
    read -p "Select an option (1-4): " choice
    
    case $choice in
        1)
            echo ""
            apply_debloat_settings
            echo ""
            read -p "Press Enter to continue..."
            show_menu
            ;;
        2)
            view_settings
            read -p "Press Enter to continue..."
            show_menu
            ;;
        3)
            reset_settings
            echo ""
            read -p "Press Enter to continue..."
            show_menu
            ;;
        4)
            echo ""
            echo -e "${GREEN}Thanks for using SlimBrave! Goodbye!${NC}"
            echo ""
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option. Please select 1-4.${NC}"
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
    apply_debloat_settings
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