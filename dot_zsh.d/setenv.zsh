setenv() {
  local env_name="$1"
  local project_root=$(
    while [[ "$PWD" != "/" ]]; do
      if [[ -f ".env" || -d ".git" ]]; then
        echo "$PWD"
        return
      fi
      cd ".."
    done
    echo ""
  )

  if [[ -z "$project_root" ]]; then
    echo "Error: Project root not found (no .env or .git folder found in parent directories)."
    return 1
  fi

  if [[ "$env_name" == "-l" ]] || [[ -z "$env_name" ]]; then
      # List available environments
      local current_env=$(readlink "$project_root/.env")
      if [[ -z "$current_env" ]]; then
          if [[ -f "$project_root/.env" ]]; then
              current_env=".env (file)"
          else
              current_env="None"
          fi
      else
          current_env=$(basename "$current_env")
      fi

      echo "Available environments:"
      for file in "$project_root"/*.env "$project_root/envs/"*.env; do
          if [[ -f "$file" ]]; then
              local env_base=$(basename "$file")
              echo "  ${env_base%.env}"
          fi
      done
      echo "Current environment: $current_env"
      return 0
  fi
  local env_file="$project_root/$env_name.env"
  local envs_file="$project_root/envs/$env_name.env"
  local current_env=".env"

  local target_file=""
  if [[ -f "$env_file" ]]; then
    target_file="$env_file"
  elif [[ -f "$envs_file" ]]; then
    target_file="$envs_file"
  else
    echo "Error: Environment file '$env_name.env' not found in root or envs/ directory."
    return 1
  fi

  if [[ -L "$current_env" ]]; then
    unlink "$current_env"
  elif [[ -f "$current_env" ]]; then
    rm "$current_env"
  fi

  local relative_path=""
  if [[ "$(dirname "$target_file")" == "$project_root" ]]; then
      relative_path="$(basename "$target_file")"
  else
      echo $target_file
      # Calculate relative path without realpath if possible.
      relative_path=$(echo "$target_file" | sed "s|^$project_root/||")
  fi
  echo $relative_path

  ln -s "$relative_path" "$current_env"

  if [[ $? -eq 0 ]]; then
    echo "Environment set to '$relative_path'."
  else
    echo "Error: Failed to create relative symlink."
    return 1
  fi
}
