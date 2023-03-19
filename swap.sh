#!/bin/zsh
saveFileDirectory='pokemmo-client-live/config/'

if grep -q "export POKEMMO_DIR=" ~/.zshrc; then
  :
else
  echo "What is the path to your PokeMMO Directory? The folder name will be called com.pokeemu.macos"
  read pokeDirectory

  echo "export POKEMMO_DIR=\"$pokeDirectory\"" >> ~/.zshrc

  source ~/.zshrc

  echo "Variable added to .zshrc: POKEMMO_DIR=$POKEMMO_DIR"
fi

pokemmoConfig="${POKEMMO_DIR}${saveFileDirectory}"

files=("${(@f)$(find "${pokemmoConfig}" -regex ".*savedcredentials.*\.properties$" -type f)}")
activeFile=("${(@f)$(find "${pokemmoConfig}" -regex ".*savedcredentials\.properties$" -type f)}")
activeAccountName=("$(grep -o 'client\.saved_credentials\.lastusername=[^[:space:]]*' "${activeFile}" | cut -d= -f2)")
accounts=()
for item in "${files[@]}"
do
  accounts+=("$(grep -o 'client\.saved_credentials\.lastusername=[^[:space:]]*' "${item}" | cut -d= -f2)")
done


echo "Select an account:"
selectedFileIndex=0
selectedAccountName="WILL CHANGE"
select choice in "${accounts[@]}"
do
  if [[ -n $choice ]]; then
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


activeFileName="savedcredentials.properties"
selectedFileName=$(basename "${files[selectedFileIndex]}")

if [[ $selectedFileName == $activeFileName ]]; then
  echo "The selected account is already active."
else
  # give currently active file a new name, so the selected file can be active
  mv "${pokemmoConfig}/${activeFileName}" "${pokemmoConfig}/savedcredentials-${activeAccountName}.properties"
  # rename the selected file with the active file name
  mv "${files[selectedFileIndex]}" "${pokemmoConfig}/${activeFileName}"
  echo "The selected account is now active."
  echo "Please reload PokeMMO."
fi
