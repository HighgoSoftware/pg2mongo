mongo <$1

if [ "$2" == "teardown" ]; then 
  /teardown.sh
fi
