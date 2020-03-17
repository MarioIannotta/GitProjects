# GitStats
A Swift script to extract stats from multiple git repositories.
For every user a `contribution` value is calculated based on the additions and deletions of each commit.

## Usage:

`path/to/git-stats <base-path> [<date>] [--skip-fetch <skip-fetch>]`

**Arguments**
* `<base-path>` 
    > The absolute path that contains all your repositories. eg: `/Users/mario/Documents/Apps`
* `<date>` 
    > The date from which you want to get the stats. Format: YYYY-MM-dd. (default: <Today>)

**Options**
* `-s, --skip-fetch` 
    > If the true, the remote fetch will be skipped. (default: false)
* `-h, --help`
    > Show help information.

**Output**
```
Listing git repositories in Documents/Apps
3 repositories found: RepoOne, RepoTwo, RepoThree

Fetching commit history for RepoOne...
Fetching commit history for RepoTwo...
Fetching commit history for RepoThree...

10 commit found since 2020-03-17

Contributions:
[
  {
    "date" : "2020-03-17",
    "authors" : [
      {
        "email" : "User One <user@one.com>",
        "apps" : [
          {
            "name" : "RepoOne",
            "contribution" : 940
          },
          {
            "name" : "RepoTwo",
            "contribution" : 120
          }
        ]
      },
      {
      "email" : "User Two <user@two.com>",
        "apps" : [
          {
            "name" : "RepoOne",
            "contribution" : 152478
          },
          {
            "name" : "RepoTwo",
            "contribution" : 83
          },
          {
            "name" : "RepoThree",
            "contribution" : 19
          }
        ]
      }
    ]
  }
]
```
