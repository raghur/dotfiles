unset ALLOW_IMPERSONATION
unset ALLOW_MOCK_ENTITLEMENTS
unset APPLICATION
unset ASPNETCORE_ENVIRONMENT
unset ASYNC_COMMAND_AZURE_COSMOS_COLLECTION
unset AUTH0_AUDIENCE
unset AUTH0_BASE_URL
unset AUTH0_COMMON_SERVICES_API_AUDIENCE
unset AUTH0_COMMON_SERVICES_API_CLIENT_ID
unset AUTH0_COMMON_SERVICES_API_CLIENT_SECRET
unset AUTH0_COMMON_SERVICES_API_SCOPE
unset AUTH0_COMMON_SERVICES_PORTAL_CLIENT_ID
unset AUTH0_M2M_AUDIENCE
unset AUTH0_SWAGGER_CLIENT_ID
unset AZURE_COSMOS_CONNECTION
unset AZURE_COSMOS_DATABASE
unset AZURE_FRONT_DOOR_HOST_FOR_ASSETS
unset AZURE_SERVICE_BUS_CONNECTION
unset AZURE_SERVICE_BUS_CONTRACT_EVENT_TOPIC
unset AZURE_SERVICE_BUS_DOMAIN_EVENT_TOPIC
unset AZURE_STORAGE_ACCOUNT_CONNECTION
unset Application__FeedbackEmailLimit
unset Application__FeedbackEmailLimitIntervalInSeconds
unset Application__FeedbackMailbox
unset CARGO_HOME
unset COMMON_SERVICES_API_BASE_URL
unset CONCURRENT_BATCH_WORKERS_PCT
unset CONCURRENT_SESSION_WORKERS
unset COSMOS_JSON
unset CSAdminPortal__BaseUrl
unset CSPortal__BaseUrl
unset CUSTOM_SERVICE_PROVISIONING_CONFIG
unset DEFAULT_TRIAL_ENTITLEMENT_CODES
unset DOTNET_MULTILEVEL_LOOKUP
unset DOTNET_ROOT
unset ENTITLEMENT_CLIENT_ID
unset ENTITLEMENT_CLIENT_SECRET
unset ENTITLEMENT_SERVER
unset EPHEMERAL_USER_NOTIFICATION_TTL_IN_SECONDS
unset EQUINOX_COSMOS_CONNECTION
unset EQUINOX_COSMOS_CONTAINER
unset EQUINOX_COSMOS_DATABASE
unset EQUINOX_COSMOS_VIEWS
unset EQUINOX_FORK_PAT
unset EQUINOX_POSTGRES_CONNECTION
unset EQUINOX_POSTGRES_SCHEMA
unset EQUINOX_POSTGRES_VIEWS_CONNECTION
unset EQUINOX_POSTGRES_VIEWS_SCHEMA
unset EQUINOX_STORE
unset FORCE_BP_ID
unset HARNESS_API_KEY
unset INT_SERVICE_BUS_CONNECTION
unset INT_SERVICE_BUS_SAS_TOKENS_TABLE
unset INT_SERVICE_BUS_TOPIC
unset INT_SERVICE_BUS_TOPIC_SAS_POLICY
unset INVITATION_EMAIL_TEMPLATE_ID
unset IS_DEMO_RESERVATION_ENABLED
unset IS_LOCAL_DEBUG_ENVIRONMENT
unset Identity__Audience
unset Identity__BaseUrl
unset Identity__Connections
unset Identity__ManagementApiClientId
unset Identity__ManagementApiClientSecret
unset Identity__MyRockwellUserPattern
unset MetricsApi__Swagger__ClientId
unset NTF_SERVICE_BUS_CONNECTION
unset NTF_SERVICE_BUS_TOPIC
unset NotificationsApi__Audience
unset NotificationsApi__BaseUrl
unset NotificationsApi__ClientId
unset NotificationsApi__ClientSecret
unset NotificationsApi__Enabled
unset NotificationsApi__Scope
unset OPA_AGENT_URL
unset PROJECT_FILES_STORAGE_ACCOUNT_CONNECTION
unset QuoteService__BaseUrl
unset QuoteService__ClientId
unset QuoteService__ClientSecret
unset REDIS_CONNECTION
unset RUSTUP_HOME
unset RUSTUP_TOOLCHAIN
unset SERVICE_BUS_CONNECTION
unset SERVICE_BUS_TOPIC
unset SESSION_BASED
unset Sendgrid__ApiKey
unset Sendgrid__EmailIsLive
unset Sendgrid__FromAddress
unset Sendgrid__FromName
unset Sendgrid__Retries
unset Swagger__ClientId
unset TIME_IN_MINUTES_BETWEEN_INVITATION_REISSUE
unset TRANSACTIONAL_EMAIL_TEMPLATE_ID
unset USER_NOTIFICATIONS_AZURE_COSMOS_COLLECTION
unset USER_NOTIFICATION_TTL_IN_SECONDS
unset USER_PREFERENCES_TABLE
unset UTILITY_TOKEN_SERVICE_DISCOUNTS
export PATH='/home/raghu/.local/share/pnpm:/opt/homebrew/opt/sqlite/bin:/opt/homebrew/opt/sqlite/bin:/home/raghu/.local/bin:/usr/local/bin:/usr/bin:/var/lib/snapd/snap/bin:/usr/local/sbin:/opt/cuda/bin:/var/lib/flatpak/exports/bin:/usr/lib/jvm/default/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl:/opt/rocm/bin:/home/raghu/bin:/home/raghu/.local/bin:/home/raghu/bin:/home/raghu/.local/bin:~/.fzf/bin'
precmd_functions=( ${precmd_functions:#_mise_hook_precmd} )
chpwd_functions=( ${chpwd_functions:#_mise_hook_chpwd} )
(( $+functions[_mise_hook_precmd] )) && unset -f _mise_hook_precmd
(( $+functions[_mise_hook_chpwd] )) && unset -f _mise_hook_chpwd
(( $+functions[_mise_hook] )) && unset -f _mise_hook
(( $+functions[mise] )) && unset -f mise
unset MISE_SHELL
unset __MISE_DIFF
unset __MISE_SESSION
unset __MISE_ZSH_PRECMD_RUN
export MISE_SHELL=zsh
if [ -z "${__MISE_ORIG_PATH:-}" ]; then
  export __MISE_ORIG_PATH="$PATH"
fi
export __MISE_ZSH_PRECMD_RUN=0

mise() {
  local command
  command="${1:-}"
  if [ "$#" = 0 ]; then
    command mise
    return
  fi
  shift

  case "$command" in
  deactivate|shell|sh)
    # if argv doesn't contains -h,--help
    if [[ ! " $@ " =~ " --help " ]] && [[ ! " $@ " =~ " -h " ]]; then
      eval "$(command mise "$command" "$@")"
      return $?
    fi
    ;;
  esac
  command mise "$command" "$@"
}

_mise_hook() {
  eval "$(mise hook-env -s zsh)";
}
_mise_hook_precmd() {
  eval "$(mise hook-env -s zsh --reason precmd)";
}
_mise_hook_chpwd() {
  eval "$(mise hook-env -s zsh --reason chpwd)";
}
typeset -ag precmd_functions;
if [[ -z "${precmd_functions[(r)_mise_hook_precmd]+1}" ]]; then
  precmd_functions=( _mise_hook_precmd ${precmd_functions[@]} )
fi
typeset -ag chpwd_functions;
if [[ -z "${chpwd_functions[(r)_mise_hook_chpwd]+1}" ]]; then
  chpwd_functions=( _mise_hook_chpwd ${chpwd_functions[@]} )
fi

_mise_hook
if [ -z "${_mise_cmd_not_found:-}" ]; then
    _mise_cmd_not_found=1
    [ -n "$(declare -f command_not_found_handler)" ] && eval "${$(declare -f command_not_found_handler)/command_not_found_handler/_command_not_found_handler}"

    function command_not_found_handler() {
        if [[ "$1" != "mise" && "$1" != "mise-"* ]] && mise hook-not-found -s zsh -- "$1"; then
          _mise_hook
          "$@"
        elif [ -n "$(declare -f _command_not_found_handler)" ]; then
            _command_not_found_handler "$@"
        else
            echo "zsh: command not found: $1" >&2
            return 127
        fi
    }
fi
