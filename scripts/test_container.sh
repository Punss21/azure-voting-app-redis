# Add the -f option to curl if server errors like HTTP 404 should fail too
TARGET=http://localhost:8000
if curl -I "http://$TARGET"; then
  echo "$TARGET alive and web site is up"
else
  echo "$TARGET offline or web server problem"
fi