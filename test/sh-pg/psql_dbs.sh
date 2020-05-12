while read line; do
  echo $(psql -p 5333 -d $2 -c "$line")
done <$1
