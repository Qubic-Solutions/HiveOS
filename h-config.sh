#!/usr/bin/env bash
#conf="$CUSTOM_USER_CONFIG"

#
# Doing some magic here
#
# Example configuration
##CUSTOM_USER_CONFIG='-arch -t $(nvtool) -i ZOXXIDCZIMGCECCFAXDDCMBBXCDAQJIHGOOATAFPSBFIOFOYECFKUFPBEMWC --label rig1'

# Extract the dynamic part (assuming 'nproc' command is your dynamic part)
DYNAMIC_PART=$(echo "$CUSTOM_USER_CONFIG" | grep -oP '\$\((nvtool.*)\)')

# Check if the dynamic part was successfully extracted
if [ ! -z "$DYNAMIC_PART" ]; then
    # Evaluate the dynamic part to get its actual value
    #EVALUATED_DYNAMIC_PART=$(eval echo "$DYNAMIC_PART")
    eval echo "$DYNAMIC_PART" > /dev/null 2>&1

    # If you still need to remove the dynamic command from the config, not just execute it
    if [ $? -eq 0 ]; then  # Checks if the command was successful
        # Prepare a version of DYNAMIC_PART that is safe for use in sed
        SAFE_DYNAMIC_PART=$(printf '%s\n' "$DYNAMIC_PART" | sed 's:[][\/.^$*]:\\&:g')

        # Now, remove the dynamic part from the config (assuming you don't want it after execution)
        MODIFIED_CONFIG=$(echo "$CUSTOM_USER_CONFIG" | sed "s/$SAFE_DYNAMIC_PART//")

        # Output the modified configuration without the executed command
        echo "Modified config after removing executed command: $MODIFIED_CONFIG"
        conf="$MODIFIED_CONFIG"
	conf2="-t ${CUSTOM_PASS} $MODIFIED_CONFIG"
	conf2+="_cpu"
    else
        echo "Error in executing dynamic part. No modifications made."
        conf="$CUSTOM_USER_CONFIG"
	conf2="-t ${CUSTOM_PASS} $CUSTOM_USER_CONFIG"
	conf2+="_cpu"
    fi
else
    echo "No dynamic part found. No modifications made."
    conf="$CUSTOM_USER_CONFIG"
    conf2="-t ${CUSTOM_PASS} $CUSTOM_USER_CONFIG"
    conf2+="_cpu"
fi

echo "conf cpu : $conf2"
echo "$conf2" > $CUSTOM2_CONFIG_FILENAME
echo "$conf" > $CUSTOM_CONFIG_FILENAME


