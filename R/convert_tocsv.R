#' Convert spectral data files to csv files
#'
#' @param overwrite logical. Should the function overwrite existing files with
#' the same name? (defaults to `FALSE`).
#'
#' @inheritParams lr_get_spec
#'
#' @return Convert input files to csv and invisibly return the list of created
#' file paths
#'
#' @section Warning:
#'
#' This step loses all metadata associated to the spectra. This metadata is
#' critical to ensure reproducibility. We recommended you use
#' [lr_get_metadata()] to extract this information from your raw data.
#'
#' @importFrom tools file_path_sans_ext
#' @importFrom utils write.csv
#'
#' @export
lr_convert_tocsv <- function(where = NULL, ext = "txt", decimal = ".",
                             sep = NULL, subdir = FALSE,
                             cores = getOption("mc.cores", 2L),
                             ignore.case = TRUE, overwrite = FALSE) {

  if (is.null(where)) {
    warning("Please provide a valid location to read and write the files.",
            call. = FALSE)
    return(NULL)
  }

  extension <- paste0("\\.", ext, "$", collapse = "|")

  file_names <- list.files(where,
                           pattern = extension, ignore.case = ignore.case,
                           recursive = subdir, include.dirs = subdir
  )
  nb_files <- length(file_names)

  if (nb_files == 0) {
    warning('No files found. Try a different value for argument "ext".',
            call. = FALSE)
    return(NULL)
  }

  files <- file.path(where, file_names)

  if (cores > 1 && .Platform$OS.type == "windows") {
    cores <- 1L
    message('Parallel processing not available in Windows; "cores" set to 1.\n')
  }

  message(nb_files, " files found")

  tmp <- pbmclapply(files, function(x)
    tryCatch(spec2csv_single(x, decimal = decimal, sep = sep,
                             overwrite = overwrite),
             error = function(e) NULL),
    mc.cores = cores)

  whichfailed <- which(vapply(tmp, is.null, logical(1)))

  if (length(whichfailed) == nb_files) {
    warning("File import failed.\n",
            "Check input files and function arguments.", call. = FALSE)
    return(NULL)
  } else if (length(whichfailed) > 0) {

    warning("Could not import one or more files:\n",
            paste0(files[whichfailed], "\n"),
            call. = FALSE
    )
  }

  invisible(unlist(tmp))
}

#' @noRd
spec2csv_single <- function(filename, decimal, sep, overwrite = FALSE) {

  data <- dispatch_parser(filename, decimal = decimal, sep = sep)[[1]]

  csv_name <- paste0(file_path_sans_ext(filename), ".csv")

  if (file.exists(csv_name) && !overwrite) {
    stop(csv_name, " already exists. Select `overwrite = TRUE` to overwrite.")
  }

  write.csv(data, csv_name, row.names = FALSE)

  invisible(csv_name)

}