# !/bin/sh

mkdir -p ~/Desktop/docs
mkdir -p ~/Desktop/pics

# search the desktop for links (shortcuts to applications) and move them to a specific folder
find ~/Desktop/ -maxdepth 0 -type f -name "*.desktop" -exec rm -rf {} \+

# search for documents that were accessed more than 10 days ago and move them to a folder
find ~/Desktop/ -maxdepth 0 -type f -regextype egrep -regex '.*.(txt|doc|docx|xls|xlsx|pdf)' -atime +10 -exec mv -t ~/Desktop/docs {} \+

# search for image files that were accessed more than 10 days ago and move them accordingly
find ~/Desktop/ -maxdepth 0 -type f -regextype egrep -regex '.*.(jpg|jpeg|png)' -atime +10 -exec mv -t ~/Desktop/pics {} \+

# search for files that were modified more than 30 days ago and delete them
find ~/Desktop/ -maxdepth 1 -type f -mtime +30 -exec rm -rf {} \;

# remove empty directories
find ~/Desktop/ -empty -type d -delete
