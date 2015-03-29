#/bin/bash
#
# set repository directory
deployDir=/path/to/existing/local/git/checkout

# checkout and postcheckout comands
function checkout {
cd $deployDir;
git checkout HEAD^ >/dev/null 2>&1;
git checkout -f $option;
git pull;
# optional post checkout examples
#grunt sass:dev;
#grunt sass:sdk;
#php init --env=Staging --overwrite=y;
#php yii asset frontend/config/build/build.php frontend/config/assets_compressed.php;
#grunt buildjs;
}

# creates menu with all elements passed in array
createmenu ()
{
  echo "You can pass branch name as a parameter to this script:"
  echo -e "\t $(basename "$0") [BRANCH NAME]\n"
  echo "Select branch which you want to checkout:"
  select option; do # in "$@" is the default
    if [ 1 -le "$REPLY" ] && [ "$REPLY" -le $(($#)) ];
    then
      echo "You selected: $option"
        checkout;
      break;
    else
      echo "Incorrect Input: Select a number 1-$#"
    fi
  done
}

###
### Program starts here.
###

# if script run with parameter use this paramater as branch to checkout
if [ $# -ne 0 ]; then
    option=$1;
    checkout;
    exit 1
# if script run without parameter show menu with all available branches
else
	# list of available branches
	array=( $(cd $deployDir && git ls-remote --heads 2>/dev/null | sed 's/.*\///'));
	# run createmenu function
	createmenu "${array[@]}"
fi
