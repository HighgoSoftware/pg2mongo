while read line; do
  echo $(psql -p 5432 -d $2 -c "$line")
done <$1
