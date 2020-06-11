# Core script to include in all dev scripts
# Exports :
#   $pb_repo : Remote pb repo
#   $pb_branch : Branch to pull from on $pb_repo

# Load the local config file
if [ -f "./dev-scripts/pb-config.sh" ]; then
    . "./dev-scripts/pb-config.sh"
else
    echo "Error: pb must be run from the project root."
    exit 1;
fi

# Get pb repo from git pb.repo config or ask the user if not set

if [ -z "$(git config pb.repo)" ]; then

    read -p "Enter core git repository (default: '$default_pb_repo'): " pb_repo; \

    if [[ -z "$pb_repo" ]]; then
        pb_repo="$default_pb_repo"
    fi

    git ls-remote --exit-code "$pb_repo" &> /dev/null

    exit_code="$?"

    if [ "$exit_code" -ne 0 ]; then
        echo "Error $exit_code: Unable to join the repo '$pb_repo'"
        exit 1;
    fi

    # Save the repo
    git config --add pb.repo "$pb_repo"

else
    pb_repo=$(git config pb.repo)
fi
