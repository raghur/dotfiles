colselect() {
    # Function to print specific columns from input using awk
    # Usage: colselect [separator] start_field [end_field]
    
    local sep=" "  # Default separator is space
    local start_field
    local end_field
    
    # Check if first argument contains non-digit characters (assuming it's the separator)
    if [[ $1 =~ [^0-9] ]]; then
        sep=$1
        shift
    fi
    
    # Check if we have at least one more argument for start field
    if [[ $# -lt 1 ]]; then
        echo "Error: At least one field number must be specified" >&2
        echo "Usage: colselect [separator] start_field [end_field]" >&2
        return 1
    fi
    
    start_field=$1
    end_field=${2:-$start_field}  # If end_field not provided, use start_field
    
    # Validate that fields are positive numbers
    if ! [[ $start_field =~ ^[1-9][0-9]*$ ]] || ! [[ $end_field =~ ^[1-9][0-9]*$ ]]; then
        echo "Error: Field numbers must be positive integers" >&2
        return 1
    fi
    
    # Handle the case where start_field is greater than end_field
    if (( start_field > end_field )); then
        local temp=$start_field
        start_field=$end_field
        end_field=$temp
    fi
    
    # Use awk to print the specified fields
    awk -F"$sep" -v start="$start_field" -v end="$end_field" \
        '{for(i=start;i<=end;i++) printf "%s%s", $i, (i==end?"\n":OFS)}' 
}
