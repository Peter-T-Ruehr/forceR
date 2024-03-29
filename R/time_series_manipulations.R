#' Reduce Sampling Frequency
#'
#' Reduces the sampling frequency to a certain Hz value. If the desired frequency is smaller than the
#'   original frequency, the data remains unchanged.
#' @details
#' The input data frame or tibble should have the following format:
#'
#' | **`t`** | **`y`** |
#' | :----: | :----: |
#' | `t.1` |  `y.1` |
#' | `...` | `...` |
#' | `t.n` |  `y.n` |
#'
#' or, if `measurement.col` is not `NULL`, then
#'
#' | **`t`** | **`y`** | **`measurement.col`**|
#' | :----: | :----: | :----: |
#' | `t.1` |  `y.1` |  `...`  |
#' | `...` | `...` | `...`  |
#' | `t.n` |  `y.n` |  `...`  |
#'
#' Since, when not `NULL`, the `measurement.col` is called by its character string, the position of the column does not matter, except it
#'   must not be among the first two columns which are reserved for `t` and `y`.
#'
#' All columns except the first two are removed. Values in `t` are expected to be in m.secs.
#'
#' @param df Data frame or tibble in the below mentioned format.
#' @param Hz Numeric value of desired frequency. Default `200`
#' @param measurement.col Character string. If `measurement.col` is not defined, the whole input data frames will be
#'   treated as if it was just one single time series. This is okay for data frames like that indeed only contain one
#'   time series, but for data frames
#'   with multiple time series, a grouping column needs to be defined. Default: `NULL`
#' @return Returns a tibble reduced to the desired frequency in the following format:
#'
#' | **`t`** | **`y`** |
#' | :----: |:----: |
#' | `t.1` | `y.1` |
#' | `...` | `...` |
#' | `t.n` | `y.n` |
#'
#' or, if `measurement.col` is not `NULL`, then
#'
#' | **`t`** | **`y`** | **`measurement.col`**|
#' | :----: | :----: | :----: |
#' | `t.1` |  `y.1` |  `...`  |
#' | `...` | `...` | `...`  |
#' | `t.n` |  `y.n` |  `...`  |
#'
#' @examples
#' require(dplyr)
#' # Using the forceR::df.all dataset that was
#' # simulated with forceR::simulate_bites()
#'
#' # reduce sampling frequency to 200 Hz
#' df.all.200 <- reduce_frq(df = df.all,
#'                          Hz = 200,
#'                          measurement.col = "measurement")
#'
#' plot(df.all.200 %>%
#'        filter(measurement == "m_02") %>%
#'        select(t, y),
#'      type = "l", col = "black")
#' lines(df.all.200 %>%
#'        filter(measurement == "m_01") %>%
#'        select(t, y),
#'      type = "l", col = "blue")
#' @export
reduce_frq <- function (df,
                        Hz = 200,
                        measurement.col = NULL){

  if(sum(colnames(df) %in% c("t", "y")) != 2){
    stop ("column names of 'df' must contain 't', 'y'.")
  }

  if(!is.numeric(Hz)) stop ("'Hz' must be numeric.")

  if(!is.character(measurement.col) & !is.null(measurement.col)){
    stop ("'measurement.col' must be NULL or a character string.")
  }

  if(!is.null(measurement.col) & sum(colnames(df) %in% measurement.col) != 1){
    stop (paste0("column names of 'df' must contain '", measurement.col, "' as defined in 'measurement.col'."))
  }

  y <- t.frq <- y.frq <- measurement <- NULL

  # sample.rate <- diff(df$t[1:2])
  t.red.factor = 1000/Hz # [Hz]
  if(is.null(measurement.col)){
    warning("You chose no \'measurement.col\', so the measurement should only contain a single time series.")
    df <- df[,c(1:2)]
    colnames(df) <- c("t", "y")

    df.frq <- df %>%
      dplyr::group_by(t.frq = t.red.factor * round(t/t.red.factor)) %>%
      dplyr::summarize(y.frq = mean(y)) %>%
      dplyr::arrange(t.frq) %>%
      dplyr::rename(t = t.frq, y = y.frq)

  } else {
    # print(paste0("The column \'", measurement.col, "\' will be used to group the separate time series."))
    measurement.col.no <- which(colnames(df) == measurement.col)

    df <- df[,c(1:2, measurement.col.no)]
    colnames(df) <- c("t", "y", "measurement")

    df.frq <- df %>%
      dplyr::group_by(t.frq = t.red.factor * round(t/t.red.factor), measurement) %>%
      dplyr::summarize(y.frq = mean(y)) %>%
      dplyr::arrange(measurement, t.frq) %>%
      dplyr::rename(t = t.frq, y = y.frq) %>%
      dplyr::select(t, y, measurement)
    colnames(df.frq)[3] <- measurement.col
  }

  return(df.frq)
}


#' Convert Time Series to Force
#'
#' Converts a time series, e.g. a continuous voltage measurement from a sensor to force data
#'   according to an amplification value and, depending on the measurement setup, the lever ratio of the
#'   rocker forwarding the force from the point the force acts on to the sensor.
#'
#'  These values should be stored in a `classifier` (s. below).
#'
#' @details
#' The `classifier` should have at leaste the following columns:
#'
#' | **`measurement`** | **`amp`** | **`lever.ratio`** |
#' | :----: |:----: | :----: |
#' | `measurement.1` | `amp.1` | `lever.ratio.1` |
#' | `...` | `...` | `...` | `...` | `...`  |
#' | `measurement.n` | `amp.n` | `lever.ratio.n` |
#'
#' It must contain one row per unique measurement number that is present in the
#' df.
#'
#'   The force (`F`) in Newton is calculated *via* the following formula:
#'
#'   `F = y * lever.ratio * (1 / amp)`
#'
#'   where `y` is the measurement series, e.g. in `V`, \cr
#'   `amp` is the amplification value, e.g. in `V/N`, \cr
#'   and `lever.ratio` is the mechanical lever ratio of the measurement setup.
#'
#' `df` should have the following format:
#'
#' | **`t`** | **`y`** | **`measurement`** |
#' | :----: | :----: | :----: |
#' | `t.1` | `y.1` | `measurement.1` |
#' | `t.2` | `y.2` | `measurement.1` |
#' | `...` | `...` | `...` |
#' | `t.n` | `y.n` | `measurement.1` |
#' | `t.1` | `y.1` | `measurement.2` |
#' | `t.2` | `y.2` | `measurement.2` |
#' | `...` | `...` | `...` |
#' | `t.m` | `y.m` | `measurement.2` |
#' | `...` | `...` | `...` |
#' | `t.o` | `y.o` | `measurement.o` |
#'
#' @param df Data frame or tibble in the below mentioned format. This should contain the time series, with
#' one line per time step and measurement.
#' @param classifier Classifier in the below mentioned format.
#' @param measurement.col Character string. If `measurement.col` is not defined, the whole input data frames will be
#'   treated as if it was just one single time series. This is okay for data frames like that indeed only contain one
#'   time series, but for data frames
#'   with multiple time series, a grouping column needs to be defined. Default: `NULL`
#' @return Returns a tibble in the same format as the input tibble with an additional column called '"'`force`'.
#' @examples
#' # convert y column of df.all to force column and add taxonomic data
#' # using info from classifier
#' df.all.tax <- y_to_force(df = forceR::df.all.200,
#'                       classifier = forceR::classifier,
#'                       measurement.col = "measurement")
#'
#' df.all.tax
#'
#' @export
y_to_force <- function (df,
                        classifier,
                        measurement.col){

  if(sum(colnames(df) %in% c("t", "y")) != 2){
    stop ("column names of 'df' must contain 't', 'y'.")
  }
  if(sum(colnames(classifier) %in% c("amp", "lever.ratio")) != 2){
    stop ("column names of 'classifier' must contain 'specimen', 'amp', 'lever.ratio'.")
  }
  if(!is.character(measurement.col) & !is.null(measurement.col)){
    stop ("'measurement.col' must be NULL or a character string.")
  }
  if(!is.null(measurement.col) & sum(colnames(df) %in% measurement.col) != 1){
    stop (paste0("column names of 'df' must contain '", measurement.col, "' as defined in 'measurement.col'."))
  }
  if(!is.null(measurement.col) & sum(colnames(classifier) %in% measurement.col) != 1){
    stop (paste0("column names of 'classifier' must contain '", measurement.col, "' as defined in 'measurement.col'."))
  }
  if(length(setdiff(classifier %>%
                    pull(measurement.col),
                    unique(df %>%
                           pull(measurement.col)))) != 0){
    stop ("The following measuremnt numbers are missing from the df:\n",
          setdiff(classifier %>%
                    pull(measurement.col),
                  unique(df %>%
                           pull(measurement.col))))
  }
  if(length(setdiff(df %>%
                    pull(measurement.col),
                    unique(classifier %>%
                           pull(measurement.col)))) != 0){
    stop ("The following measuremnt numbers are missing from the classifier:\n",
          setdiff(df %>%
                    pull(measurement.col),
                  unique(classifier %>%
                           pull(measurement.col))))
  }
  amp <- lever.ratio <- y <- specimen <- NULL

  # df <- df.all.200
  if(!("lever.ratio" %in% colnames(classifier))){
    classifier <- classifier %>% mutate(lever.ratio = 1)
  }
  if(!("amp" %in% colnames(classifier))){
    classifier <- classifier %>% mutate(amp = 1)
  }
  df <- df %>%
    left_join(classifier %>%
                select(all_of(measurement.col), amp, lever.ratio),
              by=measurement.col) %>%
    mutate(force = y * lever.ratio / amp) %>%
    select(all_of(measurement.col), t, force)
  return(df)
}
