# `lightr`: import spectral data in R

[![CRAN version](https://www.r-pkg.org/badges/version-ago/lightr)](https://cran.r-project.org/package=lightr)
[![Dependencies](https://tinyverse.netlify.com/badge/lightr)](https://cran.r-project.org/package=lightr)
[![Travis build status](https://travis-ci.org/ropensci/lightr.svg?branch=master)](https://travis-ci.org/ropensci/lightr)
[![AppVeyor build status](https://ci.appveyor.com/api/projects/status/github/bisaloo/lightr?branch=master&svg=true)](https://ci.appveyor.com/project/bisaloo/lightr)
[![Coverage status](https://codecov.io/gh/ropensci/lightr/branch/master/graph/badge.svg)](https://codecov.io/github/ropensci/lightr?branch=master)
[![Reviewed by rOpenSci](https://badges.ropensci.org/267_status.svg)](https://github.com/ropensci/software-review/issues/267)
[![JOSS paper](https://joss.theoj.org/papers/7f76d78642d3dc72ea9d8c2597ef0e27/status.svg)](https://joss.theoj.org/papers/7f76d78642d3dc72ea9d8c2597ef0e27)


There is no standard file format for spectrometry data and different scientific
instrumentation companies use wildly different formats to store spectral data.
Vendor proprietary software sometimes has an option but convert those formats
instead human readable files such as `csv` but in the process, most metadata
are lost. However, those metadata are critical to ensure reproducibility ([White
*et al*, 2015](https://doi.org/10.1016/j.anbehav.2015.05.007)).

This package aims at offering a unified user-friendly interface for users to 
read UV-VIS reflectance/transmittance/absorbance spectra files from various
formats in a single line of code.

Additionally, it provides for the first time a fully free and open source 
solution to read proprietary spectra file formats on all systems.

## 🔧 Installation

```r
install.packages("lightr")
```

You can also install the development version from GitHub:

```r
# install.packages("remotes")
remotes::install_github("ropensci/lightr")
```

## 💻 Usage

A thorough documentation is available with the package, using R usual syntax
`?function` or `help(function)`. However, users will probably mainly use two 
functions:

```r
# Get a data.frame containing all useful metadata from spectra in a folder
lr_get_metadata(where = system.file("testdata/procspec_files", 
                                    package = "lightr"), 
                ext = "ProcSpec")
```

and

```r
# Get a single dataframe where the first column contains the wavelengths and 
# the next columns contain a spectra each (pavo's rspec class)
lr_get_spec(where = system.file("testdata/procspec_files", package = "lightr"),
            ext = "ProcSpec")
```

`lr_get_spec()` returns a dataframe that is compatible with [`pavo`] custom S3
class (`rspec`) and can be used for further analyses using colour vision models.

All supported file formats can also be parsed using the `lr_parse_$extension()` 
function where `$extension` is the lowercase extension of your file. This
family of functions return a list where the first element is the data dataframe
and the second element is a vector with relevant metadata.

Only exceptions are `.txt` and `.Transmission` files because those extensions
are too generic. Users will need to figure out which parser is appropriate in 
this case. `lr_get_metadata()` and `lr_get_spec()` automatically try generic 
parsers in this case.

Alternatively, you may simply want to convert your spectra in a readable 
standard format and carry on with your analysis with another software.

In this case, you can run:

```r
# Convert every single ProcSpec file to a csv file with the same name and 
# location
lr_convert_tocsv(where = system.file("testdata/procspec_files", 
                                      package = "lightr"),
                 ext = "ProcSpec")
```

## ✔ Supported file formats

This package is still under development but currently supports (you can click
on the extension in the tables to see an example of this file format):

### [OceanInsight (formerly OceanOptics)](https://www.oceaninsight.com/)

  | Extension        | Parser                |
  |:-----------------|:----------------------|
  | [`jdx`]          | `lr_parse_jdx()`      |
  | [`ProcSpec`]     | `lr_parse_procspec()` |
  | [`spc`][spc1]    | `lr_parse_spc()`      |
  | [`jaz`]          | `lr_parse_jaz()`      |
  | [`JazIrrad`]     | `lr_parse_jazirrad()` |
  | [`Transmission`] | `lr_parse_jaz()`      |
  | [`txt`](https://raw.githubusercontent.com/ropensci/lightr/master/inst/testdata/OceanView.txt) | `lr_parse_jaz()` |

[`jdx`]: https://raw.githubusercontent.com/ropensci/lightr/master/inst/testdata/OceanOptics_period.jdx
[`ProcSpec`]: https://github.com/ropensci/lightr/raw/master/inst/testdata/procspec_files/whiteref.ProcSpec
[spc1]: https://github.com/ropensci/lightr/raw/master/inst/testdata/OceanOptics.spc
[`jaz`]: https://raw.githubusercontent.com/ropensci/lightr/master/inst/testdata/jazspec.jaz
[`JazIrrad`]: https://raw.githubusercontent.com/ropensci/lightr/master/inst/testdata/irrad.JazIrrad
[`Transmission`]: https://raw.githubusercontent.com/ropensci/lightr/master/inst/testdata/FMNH6834.00000001.Master.Transmission

### [Avantes](https://www.avantes.com/)

  | Extension        | Parser                |
  |:---------------  |:----------------------|
  | `ABS`            | `lr_parse_abs()`      |
  | [`ROH`]          | `lr_parse_roh()`      |
  | [`TRM`]          | `lr_parse_trm()`      |
  | [`trt`]          | `lr_parse_trt()`      |
  | [`ttt`]          | `lr_parse_ttt()`      |
  | [`txt`](https://raw.githubusercontent.com/ropensci/lightr/master/inst/testdata/avasoft8.txt) | `lr_parse_generic()` |
  | [`DRK`]          | `lr_parse_trm()`      |
  | [`REF`]          | `lr_parse_trm()`      |
  | [`RFL8`]         | `lr_parse_rfl8()`     |
  | [`Raw8`]         | `lr_parse_raw8()`     |
  
[`TRM`]: https://github.com/ropensci/lightr/raw/master/inst/testdata/avantes2.TRM
[`ROH`]: https://github.com/ropensci/lightr/raw/master/inst/testdata/avantes_reflect.ROH
[`trt`]: https://github.com/ropensci/lightr/raw/master/inst/testdata/avantes_export2.trt
[`ttt`]: https://github.com/ropensci/lightr/raw/master/inst/testdata/avantes_export.ttt
[`DRK`]: https://github.com/ropensci/lightr/raw/master/inst/testdata/1305084U1.DRK
[`REF`]: https://github.com/ropensci/lightr/raw/master/inst/testdata/1305084U1.REF
[`RFL8`]: https://github.com/ropensci/lightr/raw/master/inst/testdata/compare/Avantes/feather.RFL8
[`Raw8`]: https://github.com/ropensci/lightr/raw/master/inst/testdata/1904090M1_0003.Raw8

### [CRAIC](http://www.microspectra.com/)

  | Extension | Parser               |
  |:----------|:---------------------|
  | [`txt`](https://raw.githubusercontent.com/ropensci/lightr/master/inst/testdata/CRAIC_export.txt) | `lr_parse_generic()` |
  | [`spc`]   | `lr_parse_spc()`     |
  
[`spc`]: https://github.com/ropensci/lightr/raw/master/inst/testdata/compare/CRAIC/CRAIC.spc
  
### Others

  | Extension | Parser                        |
  |:----------|:------------------------------|
  | [`csv`]   | `lr_parse_generic(sep = ",")` |
  | [`dpt`]   | `lr_parse_generic(sep = ",")` |

#  
[`csv`]: https://raw.githubusercontent.com/ropensci/lightr/master/inst/testdata/spec.csv
[`dpt`]: https://raw.githubusercontent.com/ropensci/lightr/master/inst/testdata/RS-1.dpt
## Others

As a fallback, you should always try `lr_parse_generic()` which offers a
flexible and general algorithm that manages to extract data from most files.

If you can't find the best parser for your specific file or if you believe you
are using an unsupported format, please 
[open an issue](https://github.com/ropensci/lightr/issues) or send me an email. 

## 🌐 Similar projects

* `lightr` itself contains some code that has been initially forked from 
  [`pavo`], namely the `lr_get_spec()` function. The code has since then been 
  refactored and optimised for speed. [`pavo`] differs from `lightr` in its
  focus and core functionalities. The main strength of [`pavo`] is the 
  comprehensive and user-friendly set of functions to analyse spectral data
  using [colour vision models](https://en.wikipedia.org/wiki/Color_model), while
  `lightr` focuses on the data import step.
* [`photobiologyInOut`] also provides functions to import spectral data. 
  The goal of the author is to provide a complete pipeline of spectral data 
  import and analysis using a 
  [set of tightly integrated R packages](https://www.r4photobiology.info/). 
  This however makes it more difficult to use a different tool for a given step
  of the process. On the contrary, `lightr` aims at proposing a light package 
  with limited dependencies that focuses on the data import step of the process
  and let the user pick their favourite tool for the analysis step ([`pavo`],
  [`colourvision`](https://cran.r-project.org/package=colourvision),
  [`Avicol`](https://sites.google.com/site/avicolprogram/), etc.).
* [`spectrolab`](https://github.com/meireles/spectrolab)

To our knowledge, `lightr` is the only gratis tool to import some complex file
formats such as Avantes (`ABS`, `ROH`, `TRM`, `RFL8`) or CRAIC (`spc`) binary 
files, or OceanOptics `.ProcSpec`. Because of its user-friendly high-levels
functions and low dependency philosophy, `lightr` may also hopefully prove
useful for people working with other languages than R.


[`pavo`]: https://cran.r-project.org/package=pavo

[`photobiologyInOut`]: https://cran.r-project.org/package=photobiologyInOut

[![ropensci_footer](https://ropensci.org/public_images/ropensci_footer.png)](https://ropensci.org)
