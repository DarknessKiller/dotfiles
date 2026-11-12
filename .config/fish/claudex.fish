function claudex
    set -l selected $argv[1]
    set -l claude_args $argv[2..-1]
    set -l settings

    switch $selected
        case cpa
            set settings '{
                "env": {
                    "ANTHROPIC_AUTH_TOKEN": "'$CLIPROXYAPI_API_KEY'",
                    "ANTHROPIC_BASE_URL": "'$CLIPROXYAPI_BASE_URL'",
                    "CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY": "1",
                    "API_TIMEOUT_MS": "600000",
                    "BASH_DEFAULT_TIMEOUT_MS": "600000",
                    "BASH_MAX_TIMEOUT_MS": "600000",
                    "CLAUDE_API_TIMEOUT": "600000",
                    "CLAUDE_CODE_MAX_CONTEXT_TOKENS": "272000",
                    "CLAUDE_AUTOCOMPACT_PCT_OVERRIDE": "95",
                    "DISABLE_TELEMETRY": "1",
                    "MCP_TIMEOUT": "30000",
                    "MCP_TOOL_TIMEOUT": "600000"
                }
            }'

        case omni
            set settings '{
                "env": {
                    "ANTHROPIC_AUTH_TOKEN": "'$OMNIROUTE_API_KEY'",
                    "ANTHROPIC_BASE_URL": "'$OMNIROUTE_BASE_URL'",
                    "CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY": "1",
                    "ANTHROPIC_CUSTOM_HEADERS": "x-omniroute-compression: allow-lossy",
                    "API_TIMEOUT_MS": "600000",
                    "BASH_DEFAULT_TIMEOUT_MS": "600000",
                    "BASH_MAX_TIMEOUT_MS": "600000",
                    "CLAUDE_API_TIMEOUT": "600000",
                    "CLAUDE_CODE_MAX_CONTEXT_TOKENS": "272000",
                    "CLAUDE_AUTOCOMPACT_PCT_OVERRIDE": "95",
                    "DISABLE_TELEMETRY": "1",
                    "MCP_TIMEOUT": "30000",
                    "MCP_TOOL_TIMEOUT": "600000"
                }
            }'

        case '*'
            echo "Usage: claudex <cpa|omni> [claude arguments]"
            return 1
    end

    # Preserve Orca's active profile environment.
    set -lx CLAUDE_CONFIG_DIR $CLAUDE_CONFIG_DIR
    set -lx ORCA_CLAUDE_INJECTED_CONFIG_DIR $ORCA_CLAUDE_INJECTED_CONFIG_DIR

    claude --settings "$settings" $claude_args
end

complete -c claudex -f -a cpa -d 'CLIProxyAPI'
complete -c claudex -f -a omni -d 'OmniRoute'
