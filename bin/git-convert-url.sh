#!/bin/bash
# From comments: https://gist.github.com/m14t/3056747 by @shivams

# The if condition is for checking your remote HTTPS URL has `.git` at the end or not
if git config --get remote.origin.url | grep -P '\.git$' >/dev/null; then
    newURL=`git config --get remote.origin.url | sed -r 's#(http.*://)([^/]+)/(.+)$#git@\2:\3#g'`
else
    newURL=`git config --get remote.origin.url | sed -r 's#(http.*://)([^/]+)/(.+)$#git@\2:\3.git#g'`
fi

echo $newURL
read -p "Does this new url look fine? (y/N): " response
if [[ "$response" == "y" ]]; then 
    git remote set-url origin $newURL
    echo "Git remote updated."
else
    echo "Git remote unchanged."
fi
