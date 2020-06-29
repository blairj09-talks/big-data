# Big Data with R

> Big data takes many forms. Sometimes it’s large CSV files on your computer.
Sometimes it’s data in an external database. Sometimes it’s data in a corporate
data lake. Here, we will look at how to use the power of dplyr and other R
packages to work with big data in various formats to arrive at meaningful
insight using a familiar and consistent set of tools.

---

![title slide](slides/big-data-slides.pdf)

---

### About
This repository contains a collection of slides and example code used for talks
and workshops given about working with Big Data in R.

### Usage
This repository uses the
[`renv`](https://rstudio.github.io/renv/articles/renv.html) package for
dependency management. The necessary R dependencies can be installed by running
`renv::restore()`.

### Topics
* [dplyr](https://dplyr.tidyverse.org/)
* [data.table](https://rdatatable.gitlab.io/data.table/)
* [dtplyr](https://dtplyr.tidyverse.org/)
* [DBI](https://dbi.r-dbi.org/)
* [odbc](https://github.com/r-dbi/odbc)
* [dbplyr](https://dbplyr.tidyverse.org/)
* [connections](https://github.com/rstudio/connections)
* [sparklyr](https://spark.rstudio.com/)