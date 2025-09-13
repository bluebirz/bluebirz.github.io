is_passed=1

echo ">> Checking relative path of media..."
{
  rg -i --pcre2 "(?<!lqip):\s*\.+\/" _posts/ --sort-files && is_passed=0
} || {
  echo "no relative path found. :)"
}

echo ">> Checking front-matter fields..."
for i in $(find _posts/*.md); do
  title=$(yq --front-matter=extract '.title' "$i")
  if [ "$title" == null ]; then
    echo "$i : Title is missing"
    is_passed=0
  fi

  description=$(yq --front-matter=extract '.description' "$i")
  if [ "$description" == null ]; then
    echo "$i : Description is missing"
    is_passed=0
  fi

  date=$(yq --front-matter=extract '.date' "$i")
  if [ "$date" == null ]; then
    echo "$i : Date is missing"
    is_passed=0
  fi

  categories=$(yq --front-matter=extract '.categories' "$i")
  if [ "$categories" == null ]; then
    echo "$i : Categories is missing"
    is_passed=0
  elif [[ $(echo "$categories" | yq '. | length') -lt 1 ]]; then
    echo "$i : Categories should have at least one category"
    is_passed=0
  fi

  tags=$(yq --front-matter=extract '.tags' "$i")
  if [ "$tags" == null ]; then
    echo "$i : Tags is missing"
    is_passed=0
  elif [[ $(echo "$tags" | yq '. | length') -lt 1 ]]; then
    echo "$i : Tags should have at least one tag"
    is_passed=0
  fi

  image_path=$(yq --front-matter=extract '.image.path' "$i")
  if [ "$image_path" == null ]; then
    echo "$i : Image path is missing"
    is_passed=0
  fi

  image_lqip=$(yq --front-matter=extract '.image.lqip' "$i")
  if [ "$image_lqip" == null ]; then
    echo "$i : Image lqip is missing"
    is_passed=0
  elif [[ "$image_lqip" =~ "unsplash.com" && ("$image_lqip" != *"q=10"* || "$image_lqip" != *"w=490"*) ]]; then
    echo "$i : Image lqip doesn't have param q=10 or w=490"
    is_passed=0
  elif [[ "$image_lqip" =~ "/assets/" && ("$image_lqip" != *".webp" && "$image_lqip" != *".svg") ]]; then
    echo "$i : Image lqip is not webp format"
    is_passed=0
  fi

  image_alt=$(yq --front-matter=extract '.image.alt' "$i")
  if [ "$image_alt" == null ]; then
    echo "$i : Image alt is missing"
    is_passed=0
  fi

  image_caption=$(yq --front-matter=extract '.image.caption' "$i")
  if [ "$image_caption" == null ]; then
    echo "$i : Image caption is missing"
    is_passed=0
  fi
done

if [ $is_passed -eq 0 ]; then exit 1; fi
echo "passed :)"
