while read line; do
  echo $(psql -p 5432 -d postgres -c "$line")
done <$1
