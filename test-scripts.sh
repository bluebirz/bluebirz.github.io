bundle exec htmlproofer _site \
  \-\-disable-external \
  \-\-ignore-urls "/^http:\/\/127.0.0.1/,/^http:\/\/0.0.0.0/,/^http:\/\/localhost/"
{
  echo "Checking relative path of media..."
  rg -li ":\s*\.+\/" _posts/
} || {
  echo "no relative path found. :)"
}
