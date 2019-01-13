for device in $(cat $(gettop)/vendor/fred/fred.devices | sed -e 's/#.*$//' | awk '{printf "fred_%s-userdebug\n", $1}'); do
    add_lunch_combo $device;
done;

# SDClang Environment Variables
export SDCLANG_AE_CONFIG=vendor/fred/sdclang/sdclangAE.json
export SDCLANG_CONFIG=vendor/fred/sdclang/sdclang.json
export SDCLANG_SA_ENABLED=false
