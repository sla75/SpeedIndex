# Dashboard
<a href="https://apps.garmin.com/cs-CZ/developer/dashboard" target="_blank">Dashboard developer</a>

# Publish Garmin App
https://developer.garmin.com/connect-iq/core-topics/publishing-to-the-store/

# Convert HEX
https://www.rapidtables.com/convert/number/hex-to-decimal.html

# GIT Branching
https://git-scm.com/book/en/v2/Git-Branching-Basic-Branching-and-Merging

## Create branch
```
git checkout -b iss5
```
***
```
git fetch origin
git checkout <new_branch>
```
## Edits
```
vim index.html
git commit -a -m 'Create new footer [issue 53]'
```

## Pushing to new branch
```
git push --set-upstream origin iss5
```

## Create local branch from existing remote
git checkout -b <new_branch_name> --track <remote_name>/<remote_branch_name>

## Merge
```
git checkout master
```
Switched to branch 'master'
```
git merge iss53
```
Merge made by the 'recursive' strategy.
index.html |    1 +
1 file changed, 1 insertion(+)
## List of branchs
```
git branch -a
```

## Deleting branch
```
git branch -d iss53
```

# Device support
|Device|Screen|Api|Launch Icon|Size XTINY|Size TINY|Group Font
|:---|:---:|:---:|:---:|:---|:---|:---:|
|Edge540|246x322|6.0|35x35|11|14|A|
|Edge840|246x322|6.0|35x35|11|14|A|
|EdgeMTB|240x320|6.0|36x36|11|14|A|
|EdgeExplore2|240x400|5.1|36x36|12|16|B|
|Edge1040|282x470|6.0|40x40|13|17|C|
|Edge550|420x600|6.0|56x56|21|28|F|
|Edge850|420x600|6.0|56x56|21|28|F|
|Edge1050|480x800|6.0|68x68|21|28|F|

## Group Fonts
### GFA - Group Font A
|Device|PartNumber|Screen|
|:---|:---:|:---:|
|Edge840|006-B4062-00|246x322|
|Edge540||246x322|
|EdgeMTB|006-B4655-00|240x320|

|Font|Height|Ascent|Descent|
|---:|---:|---:|---:|
|FONT_XTINY|11|8|3|
|FONT_TINY|14|10|4|
|FONT_SMALL|17|12|5|
|FONT_MEDIUM|19|14|5|
|FONT_LARGE|31|22|9|

### *GFC - Group Font B*(A)
|Device|PartNumber|Screen|
|:---|:---:|:---:|
|EdgeExplorer2|006-B4169-00|240x400|

|Font|Height|Ascent|Descent|
|---:|---:|---:|---:|
|FONT_XTINY|12|10|2|
|FONT_TINY|16|14|2|
|FONT_SMALL|19|16|3|
|FONT_MEDIUM|22|18|4|
|FONT_LARGE|36|30|6|

### *GFC - Group Font C*(A)
|Device|PartNumber|Screen|
|:---|:---:|:---:|
|Edge1040|006-B3843-00|282x470|

|Font|Height|Ascent|Descent|
|---:|---:|---:|---:|
|FONT_XTINY|13|9|4|
|FONT_TINY|17|12|5|
|FONT_SMALL|19|14|5|
|FONT_MEDIUM|22|16|6|
|FONT_LARGE|36|26|10|

### GFF - Group Font F
|Device|PartNumber|Screen|
|:---|:---:|:---:|
|Edge1050|006-B4440-00|480x800|
|Edge850|006-B4634-00|420x600|
|Edge550||420x600|

|Font|Height|Ascent|Descent|
|---:|---:|---:|---:|
|FONT_XTINY|21|15|6|
|FONT_TINY|28|20|8|
|FONT_SMALL|33|24|9|
|FONT_MEDIUM|38|27|11|
|FONT_LARGE|61|44|17|
