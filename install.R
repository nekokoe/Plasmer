r = getOption("repos")
r["CRAN"] = "http://cran.us.r-project.org"
options(repos = r)
install.packages("hash", dependencies = T)
install.packages("randomForest", dependencies = T)
