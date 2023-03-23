# PokeMMO Mac Account Switcher

Just a simple Mac-specific script that swaps which `savedcredentials.properties` document is currently active in your PokeMMO folder. This allows the user to have multiple accounts saved on a machine and to easily swap between them without logging in and out.

## Installation
1. Download the `swap.sh` file and put it in the directory you'd like it to live
2. Open the `terminal` app on your computer
3. Drag and drop the `swap.sh` file into the terminal window OR `cd` to the file
4. Run the command `chmod +x swap_files.sh` in order to make it executable


## Set-Up
1. Make note of your PokeMMO directory on your computer
   - You can find it by opening PokeMMO,
   - Click the "Client Management button",
   - Click "Open ROMs Folder" which will open Finder,
   - Finally use Finder to go up 2 levels until you are in the `/com.pokeemu.macos/` folder.
     - Most likely here: `/Users/{YOUR COMPUTER USER HERE}/Library/Application Support/com.pokeemu.macos`
   - Copy this directory's path by right clicking the folder, clicking "Show Info" and copying the text in the "Where:" section
2. From the `com.pokeemu.macos` folder, open the `pokemmo-client-live` folder, then open the `config` folder
   - There you will find your `savedcredentials.properties` file
3. Rename your `savedcredentials.properties` file to `savedcredentials-{YOUR USERNAME}.properties`
4. Open PokeMMO and click "Forget Saved Password"
5. Log into your other account which will generate a new `savedcredentials.properties` file with that account's information in it
6. Repeat steps 3-5 with as many accounts as you'd like


## Running the Script
![Screenshot of Script Interface](/assets/screenshot.png)

1. Run the `swap.sh` script by double clicking it or drag it into your Dock and click it once
2. You will see a list of your PokeMMO account usernames and a number to the right of them
3.  Type in the number of the account you want to use and hit enter. You may quit terminal if it didn't close automatically
4. Relaunch PokeMMO and you will be logged into your selected account
