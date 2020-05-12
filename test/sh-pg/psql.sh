while read line; do
  echo $(psql -p 5333 -d postgres -c "$line")
done <$1
