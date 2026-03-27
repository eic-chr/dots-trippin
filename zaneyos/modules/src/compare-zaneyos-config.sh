#!/usr/bin/env bash

##########################################
# ZaneyOS Configuration Comparison Tool
# Author: Don Williams
# Date: $(date +"%B %d, %Y")
##########################################

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Define directories
ZANEYOS_DIR="$HOME/zaneyos"
TEMP_DIR="/tmp/zaneyos-comparison-$$"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
REPORT_FILE="$HOME/zaneyos-config-comparison-$TIMESTAMP.txt"

# Default comparison targets
DEFAULT_REPO="https://gitlab.com/zaney/zaneyos.git"
DEFAULT_BRANCH="main"

# Function to print a section header
print_header() {
	echo -e "${BLUE}╔═══════════════════════════════════════════════════════════════════════╗${NC}"
	echo -e "${BLUE}║ ${1} ${NC}"
	echo -e "${BLUE}╚═══════════════════════════════════════════════════════════════════════╝${NC}"
}

# Function to print an error message
print_error() {
	echo -e "${RED}❌ Error: ${1}${NC}"
}

# Function to print a warning message
print_warning() {
	echo -e "${YELLOW}⚠️  Warning: ${1}${NC}"
}

# Function to print a success message
print_success() {
	echo -e "${GREEN}✅ ${1}${NC}"
}

# Function to print an info message
print_info() {
	echo -e "${CYAN}ℹ️  ${1}${NC}"
}

# Function to show usage
show_usage() {
	echo -e "${CYAN}ZaneyOS Configuration Comparison Tool${NC}"
	echo ""
	echo "Usage: $0 [OPTIONS]"
	echo ""
	echo "Options:"
	echo "  -r, --repo URL          Remote repository URL to compare against"
	echo "                          (default: https://gitlab.com/zaney/zaneyos.git)"
	echo "  -b, --branch NAME       Branch to compare against (default: main)"
	echo "  -o, --output FILE       Output report file path"
	echo "  -h, --help              Show this help message"
	echo ""
	echo "Examples:"
	echo "  $0                                    # Compare against official main branch"
	echo "  $0 -r https://github.com/user/zaneyos.git -b dev"
	echo "  $0 --branch stable-2.4               # Compare against specific branch"
	echo "  $0 --output my-comparison.txt        # Custom output file"
	echo ""
}

# Parse command line arguments
REPO_URL="$DEFAULT_REPO"
BRANCH="$DEFAULT_BRANCH"

while [[ $# -gt 0 ]]; do
	case $1 in
	-r | --repo)
		REPO_URL="$2"
		shift 2
		;;
	-b | --branch)
		BRANCH="$2"
		shift 2
		;;
	-o | --output)
		REPORT_FILE="$2"
		shift 2
		;;
	-h | --help)
		show_usage
		exit 0
		;;
	*)
		print_error "Unknown option: $1"
		show_usage
		exit 1
		;;
	esac
done

# Function to cleanup on exit
cleanup() {
	if [ -d "$TEMP_DIR" ]; then
		rm -rf "$TEMP_DIR"
	fi
}
trap cleanup EXIT

# Main comparison function
perform_comparison() {
	print_header "ZaneyOS Configuration Comparison Tool"

	echo -e "${CYAN}🔍 Comparing your configuration against:${NC}"
	echo -e "   Repository: ${YELLOW}$REPO_URL${NC}"
	echo -e "   Branch: ${YELLOW}$BRANCH${NC}"
	echo -e "   Report: ${YELLOW}$REPORT_FILE${NC}"
	echo ""

	# Check if we're in a zaneyos directory
	if [ ! -d "$ZANEYOS_DIR" ]; then
		print_error "ZaneyOS directory not found at $ZANEYOS_DIR"
		exit 1
	fi

	cd "$ZANEYOS_DIR" || exit 1

	# Check if current directory is a git repository
	if [ ! -d ".git" ]; then
		print_warning "Current ZaneyOS directory is not a git repository"
		print_info "This tool works best when your ZaneyOS is version controlled"
	fi

	# Clone the comparison repository
	print_info "Cloning comparison repository..."
	mkdir -p "$TEMP_DIR"
	if ! git clone --depth=1 -b "$BRANCH" "$REPO_URL" "$TEMP_DIR/reference" 2>/dev/null; then
		print_error "Failed to clone repository: $REPO_URL (branch: $BRANCH)"
		print_info "Please check the repository URL and branch name"
		exit 1
	fi

	print_success "Successfully cloned reference repository"

	# Generate comparison report
	{
		echo "============================================"
		echo "  ZaneyOS Configuration Comparison Report"
		echo "  Generated: $(date)"
		echo "  Local: $ZANEYOS_DIR"
		echo "  Remote: $REPO_URL (branch: $BRANCH)"
		echo "============================================"
		echo ""

		# Compare flake.nix
		echo "🔧 FLAKE.NIX COMPARISON:"
		echo "========================"
		if [ -f "./flake.nix" ] && [ -f "$TEMP_DIR/reference/flake.nix" ]; then
			if cmp -s "./flake.nix" "$TEMP_DIR/reference/flake.nix"; then
				echo "✅ flake.nix is identical to reference"
			else
				echo "📝 flake.nix differences detected:"
				echo ""
				echo "--- Reference (official)"
				echo "+++ Your configuration"
				diff -u "$TEMP_DIR/reference/flake.nix" "./flake.nix" || true
			fi
		else
			echo "⚠️  Could not compare flake.nix (file missing)"
		fi
		echo ""

		# Compare global packages
		echo "📦 GLOBAL PACKAGES COMPARISON:"
		echo "=============================="
		if [ -f "./modules/core/packages.nix" ] && [ -f "$TEMP_DIR/reference/modules/core/packages.nix" ]; then
			if cmp -s "./modules/core/packages.nix" "$TEMP_DIR/reference/modules/core/packages.nix"; then
				echo "✅ modules/core/packages.nix is identical to reference"
			else
				echo "📝 Global packages differences detected:"
				echo ""
				echo "--- Reference (official)"
				echo "+++ Your configuration"
				diff -u "$TEMP_DIR/reference/modules/core/packages.nix" "./modules/core/packages.nix" || true
			fi
		else
			echo "⚠️  Could not compare global packages (file missing)"
		fi
		echo ""

		# Compare host configurations
		echo "🏠 HOST CONFIGURATIONS COMPARISON:"
		echo "=================================="

		# List your hosts vs reference hosts
		echo "📂 Your hosts:"
		for dir in hosts/*/; do
			hostname=$(basename "$dir")
			if [ "$hostname" != "default" ]; then
				echo "  • $hostname"
			fi
		done
		echo ""

		echo "📂 Reference hosts:"
		for dir in "$TEMP_DIR/reference/hosts/"*/; do
			hostname=$(basename "$dir")
			if [ "$hostname" != "default" ]; then
				echo "  • $hostname"
			fi
		done
		echo ""

		# Compare default host template
		echo "📋 Default host template comparison:"
		if [ -d "./hosts/default" ] && [ -d "$TEMP_DIR/reference/hosts/default" ]; then
			for file in variables.nix hardware.nix host-packages.nix default.nix; do
				if [ -f "./hosts/default/$file" ] && [ -f "$TEMP_DIR/reference/hosts/default/$file" ]; then
					if cmp -s "./hosts/default/$file" "$TEMP_DIR/reference/hosts/default/$file"; then
						echo "  ✅ default/$file is identical"
					else
						echo "  📝 default/$file has differences:"
						echo "     (This is normal if you've customized the default template)"
					fi
				fi
			done
		fi
		echo ""

		# Compare your custom hosts against default template
		echo "🔍 YOUR CUSTOM HOST ANALYSIS:"
		echo "=========================="
		for dir in hosts/*/; do
			hostname=$(basename "$dir")
			if [ "$hostname" != "default" ]; then
				echo "📋 Host: $hostname"

				# Compare each file against the reference default
				for file in variables.nix hardware.nix host-packages.nix default.nix; do
					local_file="./hosts/$hostname/$file"
					ref_default="$TEMP_DIR/reference/hosts/default/$file"

					if [ -f "$local_file" ] && [ -f "$ref_default" ]; then
						if cmp -s "$local_file" "$ref_default"; then
							echo "  ✅ $file: Using default template"
						else
							echo "  📝 $file: Customized (differs from default template)"

							# Show key customizations for variables.nix
							if [ "$file" = "variables.nix" ]; then
								echo "     🔍 Key customizations detected:"

								# Extract important variables
								git_user=$(grep 'gitUsername' "$local_file" 2>/dev/null | sed 's/.*= *"\([^"]*\)".*/\1/' || echo "not set")
								git_email=$(grep 'gitEmail' "$local_file" 2>/dev/null | sed 's/.*= *"\([^"]*\)".*/\1/' || echo "not set")
								browser=$(grep 'browser' "$local_file" 2>/dev/null | sed 's/.*= *"\([^"]*\)".*/\1/' || echo "default")
								terminal=$(grep 'terminal' "$local_file" 2>/dev/null | sed 's/.*= *"\([^"]*\)".*/\1/' || echo "default")

								echo "       • Git User: $git_user"
								echo "       • Git Email: $git_email"
								echo "       • Browser: $browser"
								echo "       • Terminal: $terminal"
							fi
						fi
					elif [ -f "$local_file" ]; then
						echo "  ℹ️  $file: Custom file (not in reference)"
					else
						echo "  ⚠️  $file: Missing"
					fi
				done
				echo ""
			fi
		done

		# Compare shell configurations
		echo "🐚 SHELL CONFIGURATIONS COMPARISON:"
		echo "================================="

		# Check common shell customization files
		shell_files=(
			"modules/home/zsh/default.nix"
			"modules/home/zsh/zshrc-personal.nix"
			"modules/home/bash.nix"
			"modules/home/bashrc-personal.nix"
			"modules/home/eza.nix"
		)

		for file in "${shell_files[@]}"; do
			if [ -f "./$file" ]; then
				if [ -f "$TEMP_DIR/reference/$file" ]; then
					if cmp -s "./$file" "$TEMP_DIR/reference/$file"; then
						echo "✅ $file: Identical to reference"
					else
						echo "📝 $file: Customized"
					fi
				else
					echo "ℹ️  $file: Personal file (not in reference)"
				fi
			elif [ -f "$TEMP_DIR/reference/$file" ]; then
				echo "⚠️  $file: Missing (exists in reference)"
			fi
		done
		echo ""

		# File count comparison
		echo "📊 REPOSITORY STATISTICS:"
		echo "======================="
		local_files=$(find . -name "*.nix" -type f | wc -l)
		ref_files=$(find "$TEMP_DIR/reference" -name "*.nix" -type f | wc -l)

		echo "📁 .nix files in your config: $local_files"
		echo "📁 .nix files in reference: $ref_files"

		if [ "$local_files" -gt "$ref_files" ]; then
			echo "📈 You have $((local_files - ref_files)) more .nix files than reference"
			echo "   This might indicate custom modules or configurations"
		elif [ "$local_files" -lt "$ref_files" ]; then
			echo "📉 You have $((ref_files - local_files)) fewer .nix files than reference"
			echo "   This might indicate missing features or modules"
		else
			echo "📊 Same number of .nix files as reference"
		fi
		echo ""

		# Git status if available
		if [ -d ".git" ]; then
			echo "🔄 GIT REPOSITORY STATUS:"
			echo "======================="

			# Current branch
			current_branch=$(git branch --show-current 2>/dev/null || echo "unknown")
			echo "📍 Current branch: $current_branch"

			# Commit information
			if git rev-parse HEAD >/dev/null 2>&1; then
				last_commit=$(git log -1 --format="%h - %s (%cr)" 2>/dev/null || echo "unknown")
				echo "📝 Last commit: $last_commit"

				# Check for uncommitted changes
				if ! git diff-index --quiet HEAD -- 2>/dev/null; then
					echo "⚠️  Uncommitted changes detected:"
					git status --porcelain | head -10 | sed 's/^/     /'
					uncommitted_count=$(git status --porcelain | wc -l)
					if [ "$uncommitted_count" -gt 10 ]; then
						echo "     ... and $((uncommitted_count - 10)) more files"
					fi
				else
					echo "✅ No uncommitted changes"
				fi

				# Remote information
				remote_url=$(git remote get-url origin 2>/dev/null || echo "no remote")
				echo "🌐 Remote origin: $remote_url"
			fi
		else
			echo "🔄 GIT REPOSITORY STATUS:"
			echo "======================="
			echo "⚠️  Not a git repository"
			echo "💡 Consider initializing git for better version control:"
			echo "   git init"
			echo "   git add ."
			echo "   git commit -m 'Initial ZaneyOS configuration'"
		fi
		echo ""

		# Summary and recommendations
		echo "============================================"
		echo "📋 SUMMARY & RECOMMENDATIONS:"
		echo "============================================"
		echo ""
		echo "🎯 CONFIGURATION ASSESSMENT:"

		# Count differences
		different_files=0
		if [ -f "./flake.nix" ] && [ -f "$TEMP_DIR/reference/flake.nix" ] && ! cmp -s "./flake.nix" "$TEMP_DIR/reference/flake.nix"; then
			((different_files++))
		fi
		if [ -f "./modules/core/packages.nix" ] && [ -f "$TEMP_DIR/reference/modules/core/packages.nix" ] && ! cmp -s "./modules/core/packages.nix" "$TEMP_DIR/reference/modules/core/packages.nix"; then
			((different_files++))
		fi

		if [ "$different_files" -eq 0 ]; then
			echo "✅ Your configuration appears to be standard/minimal customization"
			echo "   • Upgrade should be straightforward"
			echo "   • Most settings will migrate automatically"
		elif [ "$different_files" -le 2 ]; then
			echo "📝 Your configuration has moderate customizations"
			echo "   • Upgrade should work well with some manual review"
			echo "   • Check the differences above for manual merge items"
		else
			echo "🔧 Your configuration is heavily customized"
			echo "   • Upgrade will require careful manual review"
			echo "   • Consider the git commands below for detailed analysis"
		fi
		echo ""

		echo "💡 RECOMMENDED ACTIONS:"
		if [ -d ".git" ]; then
			echo "1. Review differences in this report"
			echo "2. Use git commands for detailed file-by-file comparison:"
			echo "   git remote add upstream $REPO_URL"
			echo "   git fetch upstream"
			echo "   git diff upstream/$BRANCH...HEAD"
			echo "3. For specific files:"
			echo "   git diff upstream/$BRANCH:flake.nix flake.nix"
			echo "   git diff upstream/$BRANCH:modules/core/packages.nix modules/core/packages.nix"
		else
			echo "1. Consider initializing git for better version control"
			echo "2. Review differences in this report"
			echo "3. Back up your configuration before any upgrades"
		fi
		echo ""

		echo "🔄 FOR UPGRADING TO ZANEYOS 2.4:"
		echo "1. Run the upgrade analysis: ./upgrade-2.3-to-2.4.sh"
		echo "2. Review the pre-upgrade analysis report"
		echo "3. Use this comparison report to understand your customizations"
		echo "4. Proceed with the automated upgrade if ready"
		echo ""

		echo "============================================"
		echo "End of Comparison Report"
		echo "============================================"

	} | tee "$REPORT_FILE"

	print_success "Comparison complete! Report saved to: $REPORT_FILE"

	# Offer to show git commands for further analysis
	if [ -d ".git" ]; then
		echo ""
		read -p "Would you like to see detailed git comparison commands? (Y/N): " -n 1 -r
		echo ""
		if [[ $REPLY =~ ^[Yy]$ ]]; then
			echo -e "${CYAN}🔍 Git Commands for Detailed Analysis:${NC}"
			echo ""
			echo -e "${YELLOW}1. Add upstream remote (if not already added):${NC}"
			echo "   git remote add upstream $REPO_URL"
			echo ""
			echo -e "${YELLOW}2. Fetch latest changes:${NC}"
			echo "   git fetch upstream"
			echo ""
			echo -e "${YELLOW}3. Compare your entire config vs upstream:${NC}"
			echo "   git diff upstream/$BRANCH...HEAD"
			echo ""
			echo -e "${YELLOW}4. Compare specific files:${NC}"
			echo "   git diff upstream/$BRANCH:flake.nix flake.nix"
			echo "   git diff upstream/$BRANCH:modules/core/packages.nix modules/core/packages.nix"
			echo ""
			echo -e "${YELLOW}5. See what files you've modified:${NC}"
			echo "   git diff --name-only upstream/$BRANCH...HEAD"
			echo ""
			echo -e "${YELLOW}6. View your commit history vs upstream:${NC}"
			echo "   git log --oneline upstream/$BRANCH..HEAD"
			echo ""
		fi
	fi
}

# Main execution
perform_comparison
