#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
CHKDM="${SCRIPT_DIR}/chkdm"

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m'

test_single_valid_domain() {
    local domain="$1"
    local start_time end_time duration
    start_time=$(date +%s%N)
    local result=0

    if ! $CHKDM "$domain" > /dev/null 2>&1; then
        echo -e "    ${RED}✗ Error: domain '$domain' was marked as invalid${NC}"
        result=1
    else
        echo -e "    ${GREEN}✓ OK${NC}"
    fi

    end_time=$(date +%s%N)
    duration=$(( (end_time - start_time) / 1000000 ))
    echo -e "    ${BLUE}Time: ${YELLOW}${duration}ms${NC}\n"

    return $result
}

test_valid_domains() {
    local valid_domains=(
        "dnslow.me"
        "google.com"
        "www.apple.com"
        "radar.cloudflare.com"
        "support.office.microsoft.com"
        "push.notifications.prod.facebook.com"
    )

    local start_time end_time duration
    start_time=$(date +%s%N)
    local passed=0
    local total=${#valid_domains[@]}

    echo -e "${BLUE}Testing valid domains...${NC}"
    echo -e "${YELLOW}Total valid test cases: $total${NC}\n"

    local tmp_dir
    tmp_dir=$(mktemp -d)
    trap 'rm -rf "$tmp_dir"' EXIT

    for domain in "${valid_domains[@]}"; do
        echo -e "  Testing domain: ${BLUE}$domain${NC}"
        (
            if test_single_valid_domain "$domain"; then
                echo "1" > "$tmp_dir/$domain"
            else
                echo "0" > "$tmp_dir/$domain"
            fi
        ) &
    done

    wait

    for domain in "${valid_domains[@]}"; do
        if [ -f "$tmp_dir/$domain" ] && [ "$(cat "$tmp_dir/$domain")" = "1" ]; then
            ((passed++))
        fi
    done

    end_time=$(date +%s%N)
    duration=$(( (end_time - start_time) / 1000000 ))
    echo -e "${BLUE}Total time elapsed: ${YELLOW}${duration}ms${NC}"
    echo -e "${GREEN}✓ Valid domains test completed ($passed/$total)${NC}\n"

    [ "$passed" -eq "$total" ] && return 0 || return 1
}

test_invalid_domains() {
    local invalid_domains=(
        "example.123"
        "example.c-m"
        "example.a"
        "this-is-a-very-long-label-that-exceeds-the-63-character-limit123.com"
        "sub.this-is-another-very-long-label-that-exceeds-the-63-character-limit.net"
        "example--domain.com"
        "sub--domain.net"
        ""
        "test..domain"
        "invalid#domain.com"
    )

    local start_time end_time duration
    start_time=$(date +%s%N)
    local passed=0
    local total=${#invalid_domains[@]}

    echo -e "${BLUE}Testing invalid domains...${NC}"
    echo -e "${YELLOW}Total invalid test cases: $total${NC}\n"

    for domain in "${invalid_domains[@]}"; do
        echo -e "  Testing domain: ${BLUE}$domain${NC}"
        local test_start_time test_end_time test_duration
        test_start_time=$(date +%s%N)

        if $CHKDM "$domain" > /dev/null 2>&1; then
            echo -e "    ${RED}✗ Error: domain '$domain' was marked as valid${NC}"
        else
            echo -e "    ${GREEN}✓ OK${NC}"
            ((passed++))
        fi

        test_end_time=$(date +%s%N)
        test_duration=$(( (test_end_time - test_start_time) / 1000000 ))
        echo -e "    ${BLUE}Time: ${YELLOW}${test_duration}ms${NC}\n"
    done

    end_time=$(date +%s%N)
    duration=$(( (end_time - start_time) / 1000000 ))
    echo -e "${BLUE}Total time elapsed: ${YELLOW}${duration}ms${NC}"
    echo -e "${GREEN}✓ Invalid domains test completed ($passed/$total)${NC}\n"

    [ "$passed" -eq "$total" ] && return 0 || return 1
}

check_chkdm_executable() {
    echo -e "  ${BLUE}Checking program: ${NC}"
    if [ ! -f "$CHKDM" ]; then
        echo -e "    ${RED}✗ Error: program not found${NC}"
        return 1
    fi
    echo -e "    ${GREEN}✓ Found${NC}"

    echo -e "  ${BLUE}Checking permissions${NC}"
    if [ ! -x "$CHKDM" ]; then
        echo -e "    ${RED}✗ Error: program is not executable${NC}"
        return 1
    fi
    echo -e "    ${GREEN}✓ Executable${NC}\n"
    return 0
}

main() {
    echo -e "${BLUE}Starting domain validation tests...${NC}\n"
    local total_start_time total_end_time total_duration
    total_start_time=$(date +%s%N)

    check_chkdm_executable || exit 1

    test_invalid_domains
    invalid_result=$?

    test_valid_domains
    valid_result=$?

    total_end_time=$(date +%s%N)
    total_duration=$(( (total_end_time - total_start_time) / 1000000 ))

    echo -e "${BLUE}Test Summary:${NC}"
    if [ $valid_result -eq 0 ]; then
        echo -e "  ${GREEN}✓ Valid domains: All tests passed${NC}"
    else
        echo -e "  ${RED}✗ Valid domains: Tests failed${NC}"
    fi

    if [ $invalid_result -eq 0 ]; then
        echo -e "  ${GREEN}✓ Invalid domains: All tests passed${NC}"
    else
        echo -e "  ${RED}✗ Invalid domains: Tests failed${NC}"
    fi

    local total_passed=$(( (valid_result == 0 ? 1 : 0) + (invalid_result == 0 ? 1 : 0) ))
    echo -e "\n${BLUE}Final Score: ${YELLOW}($total_passed/2)${NC}"
    echo -e "${BLUE}Total time elapsed: ${YELLOW}${total_duration}ms${NC}"

    if [ $valid_result -eq 0 ] && [ $invalid_result -eq 0 ]; then
        echo -e "\n${GREEN}✓ All tests passed!${NC}"
        exit 0
    else
        echo -e "\n${RED}✗ Tests failed${NC}"
        exit 1
    fi
}

main
