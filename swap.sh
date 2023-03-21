#!/bin/zsh

# Define the saveFileDirectory
saveFileDirectory='pokemmo-client-live/config/'

# Check if POKEMMO_DIR is set in the .zshrc file
if grep -q "export POKEMMO_DIR=" ~/.zshrc; then
  :
else
  # Prompt the user for the PokeMMO directory
  echo "What is the path to your PokeMMO Directory? The folder name will be called com.pokeemu.macos"
  read pokeDirectory

  # Add the POKEMMO_DIR variable to .zshrc
  echo "export POKEMMO_DIR=\"$pokeDirectory\"" >> ~/.zshrc

  # Source .zshrc to update the environment variable
  source ~/.zshrc

  # Inform the user that POKEMMO_DIR has been added to .zshrc
  echo "Variable added to .zshrc: POKEMMO_DIR=$POKEMMO_DIR"
fi

# Create the full path to the PokeMMO configuration directory
pokemmoConfig="${POKEMMO_DIR}${saveFileDirectory}"

# Find all saved credentials files and the active credentials file
files=("${(@f)$(find "${pokemmoConfig}" -regex ".*savedcredentials.*\.properties$" -type f)}")
activeFile=("${(@f)$(find "${pokemmoConfig}" -regex ".*savedcredentials\.properties$" -type f)}")

# Extract the active account's username
activeAccountName=("$(grep -o 'client\.saved_credentials\.lastusername=[^[:space:]]*' "${activeFile}" | cut -d= -f2)")

# Initialize the accounts array
accounts=()

# Iterate through all found saved credentials files and extract account usernames
for item in "${files[@]}"
do
  accounts+=("$(grep -o 'client\.saved_credentials\.lastusername=[^[:space:]]*' "${item}" | cut -d= -f2)")
done

# Prompt the user to select an account
echo "Select an account:"
selectedFileIndex=0
selectedAccountName="WILL CHANGE"
select choice in "${accounts[@]}"
do
  if [[ -n $choice ]]; then
    # Find the selected account's index and username
    for index in $(seq 1 ${#accounts[@]})
    do
      if [[ "${accounts[index]}" == "$choice" ]]
      then
        echo "You chose ${accounts[index]}"
        selectedFileIndex=$index
        selectedAccountName=${accounts[index]}
        break 2
      fi
    done
  fi
done

# Define the filenames for the active and selected credentials files
activeFileName="savedcredentials.properties"
selectedFileName=$(basename "${files[selectedFileIndex]}")

# Check if the selected account is already active
if [[ $selectedFileName == $activeFileName ]]; then
  echo "The selected account is already active."
else
  # Rename the currently active credentials file to include the active account's username
  mv "${pokemmoConfig}/${activeFileName}" "${pokemmoConfig}/savedcredentials-${activeAccountName}.properties"

  # Rename the selected credentials file to the active credentials file name
  mv "${files[selectedFileIndex]}" "${pokemmoConfig}/${activeFileName}"

  # Inform the user that the selected account is now active
  echo "The selected account is now active."
  echo "Please reload PokeMMO."
fi
