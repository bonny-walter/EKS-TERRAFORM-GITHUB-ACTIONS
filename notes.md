###                                                  GIT
to verify the remote repositoryy url : git remote -v
to add a remote repository: git remote add origin https://github.com/<user name>/<repository-name>.git
to verify if the branch exists in the remote repo: git ls-remote --heads origin
to push a branch if missing remotely: git push -u origin <branch name>
to ensure your local main branch is tracking the remote main branch: git branch --set-upstream-to=origin/main main