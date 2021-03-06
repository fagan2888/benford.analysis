#### Package benford.analysis ####

##' Benford Analysis for data validation and forensic analytics
##' 
##' The Benford Analysis package provides tools that make it easier to
##' validate data using Benford's Law. The main purpose of the package is
##' to identify suspicious data that need further verification.
##' 
##' More information can be found on its help documentation.
##' 
##' The main function is \code{\link{benford}}. It generates a \code{Benford} S3 object.
##' 
##' The package defines S3 methods for plotting and printing Benford type objects.
##' 
##' After running \code{benford} you can easily get the "suspicious" data by using the 
##' functions: \code{\link{suspectsTable}}, \code{\link{getSuspects}}, \code{\link{duplicatesTable}} and
##' \code{\link{getDuplicates}}. See help documentation and examples for further details.
##' 
##' The package also includes 6 real datasets for illustration purposes.
##' 
##' @examples
##' data(corporate.payment) #gets data
##' cp <- benford(corporate.payment$Amount, 2, sign="both") #generates benford object
##' cp #prints 
##' plot(cp) #plots
##' 
##' head(suspectsTable(cp),10) #prints the digits by decreasing order of discrepancies
##' 
##' #gets observations of the 2 most suspicious groups
##' suspects <- getSuspects(cp, corporate.payment, how.many=2) 
##' 
##' duplicatesTable(cp) #prints the duplicates by decreasing order
##' 
##' #gets the observations of the 2 values with most duplicates
##' duplicates <- getDuplicates(cp, corporate.payment,how.many=2) 
##' 
##' MAD(cp) #gets the Mean Absolute Deviation
##' 
##' chisq(cp) #gets the Chi-squared test
##' 
##' #gets observations starting with 50 or 99
##' digits_50_and_99 <- getDigits(cp, corporate.payment, digits=c(50, 99)) 
##' 
##' @references Alexander, J. (2009). Remarks on the use of Benford's Law. Working Paper, Case Western Reserve University, Department of Mathematics and Cognitive Science.
##' \cr\cr Berger, A. and Hill, T. (2011). A basic theory of Benford's Law. Probability Surveys, 8, 1-126.
##' \cr\cr Hill, T. (1995). A statistical derivation of the significant-digit law. Statistical Science, 10(4), 354-363.
##' \cr\cr Nigrini, M. J. (2012). Benford's Law: Application for Forensic Accounting, Auditing and Fraud Detection. Wiley and Sons: New Jersey.
##' \cr\cr Nigrini, M. J. (2011). Forensic Analytics: Methods and Techniques for Forensic Accounting Investigations.Wiley and Sons: New Jersey.
##' \cr\cr 
##' 
##' @docType package
##' @aliases benford.analysis-package
##' @name benford.analysis
##' 
NULL

##' @title Benford Analysis of a dataset
##' @description This function validates a dataset using Benford's Law.
##' Its main purposes are to find out where the dataset deviates from Benford's Law and 
##' to identify suspicious data that need further verification. 
##' 
##' For a more complete example, see the package help at \link{benford.analysis}.
##' @param data a numeric vector.
##' @param number.of.digits how many first digits to analyze.
##' @param sign  The default value for sign is "positive" and it analyzes only data greater than zero. 
##' There are also the options "negative" and "both" that will analyze only negative values or both positive and negative values of the data,
##' respectively. For large datasets with both positive and negative numbers, 
##' it is usually recommended to perform a separate analysis for each group,
##' for the incentives to manipulate the numbers are usually different.
##' @param discrete most real data - like population numbers or accounting data - are discrete, so 
##' the default is TRUE. This parameter sets rounding to the differences of the ordered data to avoid floating point number
##' errors in the second order distribution, that usually occurs when data is discrete
##' and the ordered numbers are very close to each other. If your data is continuous
##' (like a simulated lognormal) you should run with discrete = FALSE. 
##' @param round it defines the number of digits that the rounding will use if discrete = TRUE.
##' @param data.name the name of your data to show. If \code{NULL} (the default), the name of the passed object will be used.
##' @return An object of class Benford containing the results of the analysis. It is a list of 
##' eight objects, namely:
##' 
##' \item{info}{general information, including \itemize{
##' \item data.name: the name of the data used.
##' \item n: the number of observations used.
##' \item n.second.order: the number of observations used for second order analysis.
##' \item number.of.digits: the number of first digits analyzed.
##' }}
##' 
##' \item{data}{a data frame with: \itemize{
##' \item lines.used: the original lines of the dataset.
##' \item data.used: the data used.
##' \item data.mantissa: the log data's mantissa.
##' \item data.digits: the first digits of the data.
##' }}
##' 
##' \item{s.o.data}{a data frame with: \itemize{
##' \item data.second.order: the differences of the ordered data.
##' \item data.second.order.digits: the first digits of the second order analysis.
##' }}
##' 
##' \item{bfd}{a data frame with: \itemize{
##' \item digits: the groups of digits analyzed.
##' \item data.dist: the distribution of the first digits of the data.
##' \item data.second.order.dist: the distribution of the first digits of the second order analysis.
##' \item benford.dist: the theoretical benford distribution.
##' \item data.second.order.dist.freq: the frequency distribution of the first digits of the second order analysis.
##' \item data.dist.freq: the frequency distribution of the first digits of the data.
##' \item benford.dist.freq: the theoretical benford frequency distribution.
##' \item benford.so.dist.freq: the theoretical benford frequency distribution of the second order analysis.
##' \item data.summation: the summation of the data values grouped by first digits.
##' \item abs.excess.summation: the absolute excess summation of the data values grouped by first digits.
##' \item difference: the difference between the data and benford frequencies.
##' \item squared.diff: the chi-squared difference between data and benford frequencies.
##' \item absolute.diff: the absolute difference between data and benford frequencies.
##' \item z.statistic: the z-statistic difference between data and benford relative frequencies.
##' }}
##' 
##' \item{mantissa}{a data frame with: \itemize{
##' \item mean.mantissa: the mean of the mantissa.
##' \item var.mantissa: the variance of the mantissa.
##' \item ek.mantissa: the excess kurtosis of the mantissa.
##' \item sk.mantissa: the skewness of the mantissa.
##' }}
##' 
##' \item{MAD}{the mean absolute deviation.}
##' \item{distortion.factor}{the distortion factor} 
##' 
##' \item{stats}{list of "htest" class statistics: \itemize{
##' \item chisq: Pearson's Chi-squared test.
##' \item mantissa.arc.test: Mantissa Arc Test.
##' \item ks.test: Kolmogorov-Smirnov Test.
##' }}
##' @examples 
##' data(corporate.payment) #loads data
##' bfd.cp <- benford(corporate.payment$Amount) #generates benford object
##' bfd.cp #prints
##' plot(bfd.cp) #plots
##' 
##' @export
benford <- function(data, number.of.digits = 2, 
                    sign = "positive", 
                    discrete=TRUE, round=3, 
                    data.name = NULL){
  
  if (is.null(data.name)) {
    data.name <- as.character(deparse(substitute(data)))
  }
  
  benford.digits <- generate.benford.digits(number.of.digits)
    
  benford.dist <- generate.benford.distribution(benford.digits)
  
  empirical.distribution <- generate.empirical.distribution(data, number.of.digits,sign, second.order = FALSE, benford.digits)
  
  n <- length(empirical.distribution$data)
  
  second.order <- generate.empirical.distribution(data, number.of.digits,sign, second.order = TRUE, benford.digits, discrete = discrete, round = round)
  
  n.second.order <- length(second.order$data)
  
  benford.dist.freq <- benford.dist*n
  
  ## calculating useful summaries and differences
  difference <- empirical.distribution$dist.freq - benford.dist.freq
  
  squared.diff <- ((empirical.distribution$dist.freq - benford.dist.freq)^2)/benford.dist.freq
  
  absolute.diff <- abs(empirical.distribution$dist.freq - benford.dist.freq)
  
  ### z-statistic
  z.stat <- z.stat.bfd(benford.dist, empirical.distribution$dist, n)
  
  ### chi-squared test
  chisq.bfd <- chisq.test.bfd(squared.diff, data.name)
  
  ### MAD
  mean.abs.dev <- sum(abs(empirical.distribution$dist - benford.dist)/(length(benford.dist)))
  
  if (number.of.digits > 3) {
    MAD.conformity <- NA
  } else {
    digits.used <- c("First Digit", "First-Two Digits", "First-Three Digits")[number.of.digits]  
    MAD.conformity <- MAD.conformity(MAD = mean.abs.dev, digits.used)$conformity
  }
  
  
    
  
  
  ### Summation
  summation <- generate.summation(benford.digits,empirical.distribution$data, empirical.distribution$data.digits)
  abs.excess.summation <- abs(summation - mean(summation))
  
  ### Mantissa
  mantissa <- extract.mantissa(empirical.distribution$data)
  mean.mantissa <- mean(mantissa)
  var.mantissa <- var(mantissa)
  ek.mantissa <- excess.kurtosis(mantissa)
  sk.mantissa <- skewness(mantissa)
  
  ### Mantissa Arc Test
  mat.bfd <- mantissa.arc.test(mantissa, data.name)
  
  ### Distortion Factor
  distortion.factor <- DF(empirical.distribution$data)  
  
  ### Kolmogorov-Smirnov test
  ks.test <- ks.test.bfd(benford.dist, empirical.distribution$dist, n, data.name)
  
  ## recovering the lines of the numbers
  if (sign == "positive") lines <- which(data > 0 & !is.na(data))
  if (sign == "negative") lines <- which(data < 0 & !is.na(data))
  if (sign == "both")     lines <- which(data != 0 & !is.na(data))
  #lines <- which(data %in% empirical.distribution$data)
  
  ## output
  output <- list(info = list(data.name = data.name,
                             n = n,
                             n.second.order = n.second.order,
                             number.of.digits = number.of.digits),
                 
                 data = data.table(lines.used = lines,
                                   data.used = empirical.distribution$data,
                                   data.mantissa = mantissa,
                                   data.digits = empirical.distribution$data.digits),
                 
                 s.o.data = data.table(second.order = second.order$data,
                                       data.second.order.digits = second.order$data.digits),
                 
                 bfd = data.table(digits = benford.digits,
                                  data.dist = empirical.distribution$dist,
                                  data.second.order.dist = second.order$dist,
                                  benford.dist = benford.dist,
                                  data.second.order.dist.freq = second.order$dist.freq,
                                  data.dist.freq = empirical.distribution$dist.freq,
                                  benford.dist.freq = benford.dist.freq,
                                  benford.so.dist.freq = benford.dist*n.second.order,
                                  data.summation = summation,
                                  abs.excess.summation = abs.excess.summation,
                                  difference = difference,
                                  squared.diff = squared.diff,
                                  absolute.diff = absolute.diff,
                                  z.statistic = z.stat),
                 
                 mantissa = data.table(statistic = c("Mean Mantissa", 
                                                     "Var Mantissa", 
                                                     "Ex. Kurtosis Mantissa",
                                                     "Skewness Mantissa"),
                                       values = c(mean.mantissa = mean.mantissa,
                                                  var.mantissa = var.mantissa,
                                                  ek.mantissa = ek.mantissa,
                                                  sk.mantissa = sk.mantissa)),
                 MAD = mean.abs.dev,
                 
                 MAD.conformity = MAD.conformity,
                 
                 distortion.factor = distortion.factor,
                 
                 stats = list(chisq = chisq.bfd,
                              mantissa.arc.test = mat.bfd,
                              ks.test = ks.test)
  )
  
  class(output) <- "Benford"
  
  return(output)
  
}

##' @title Plot method for Benford Analysis
##' @description The \code{plot} method for "Benford" objects.
##' 
##' @param  x a "Benford" object
##' @param select it specifies the order and which plots are going to be plotted. If NULL, the parameter except is used.
##' @param except it specifies which plots are not going to be plotted. If NULL, the parameter select is used.
##' Currently, you can choose from 9 plots: "digits", "rootogram digits", "second order", "rootogram second order", "summation",
##' "mantissa", "chi square", "abs diff", "ex summation". If you want to plot all, just
##' put except = "none". The default is not to plot the "mantissa" and "abs diff". If you want to plot all, just
##' put except = "all"
##' @param multiple if TRUE, all plots are grouped in the same window.
##' @param col.bar a color to be used to fill the bars. The default is lightblue.
##' @param err.bounds if TRUE, the upper and lower error bounds are draw. The error bounds indicate the binomial root mean square error.
##' @param alpha it specifies level of confidence interval. The defaults to 95 percent confidence interval,i.e., the error bounds will represent 1.96 standard error from the expected count by Benford's Law.
##' @param grid if TRUE, adds an rectangular grid to plot.
##' @param ... arguments to be passed to generic plot functions,
##' @return Plots the Benford object.
##' @export
##' @importFrom graphics abline axis barplot legend lines par plot
##' @importFrom stats pchisq var
##' @importFrom utils head
##' @importFrom stats setNames qnorm
plot.Benford <- function(x, 
                         select = c("digits", "second order", "summation", "chi squared", "ex summation"), 
                         except = NULL, 
                         multiple = TRUE,  
                         col.bar = "lightblue", 
                         err.bounds = FALSE, 
                         alpha = 0.05, 
                         grid = TRUE, ...){
  
  
  if (class(x) != "Benford") stop("Class(x) must be 'Benford'")
  
  available.plots <- c("digits", "rootogram digits", "second order", "rootogram second order", "summation", "mantissa", "chi squared", "ex summation", "abs diff", "none", "all")
  
  if (!is.null(select)) {
    
    select <- tolower(select)
    
    if (!all(select %in% available.plots)) {
      idx <- which(!select %in% available.plots)
      stop("Invalid plot name:", select[idx], "\nType ?plot.Benford for help.")
    }
    
    if (all(select == "all")) {
      plots <- available.plots[1:9]
    }else{
      plots <- select
    }
    
  } else {
    if (!is.null(except)) {
      if (!all(except %in% available.plots)) {
        idx <- which(!except %in% available.plots)
        stop("Invalid plot name: ", except[idx], "\nType ?plot.Benford for help.")
      }
      except <- tolower(except)
      if (all(except == "none")) {
        plots <- available.plots[1:9]
      }else{
        ap <- available.plots[1:9]
        plots <- ap[!(ap %in% except)]
      }
    }
  }
  
  nGraphics <- length(plots)
  
  if (multiple | (nGraphics == 1)) {
    old.par <- par(no.readonly = TRUE)
    on.exit(par(old.par))
    
    if (nGraphics < 4) {
      rows = 1; 
      cols = nGraphics
    }
    
    if (nGraphics >= 4 & nGraphics <= 6) {
      rows = 2; 
      cols = 3
    }
    if (nGraphics > 6) {
      rows = 3; 
      cols = 3
    }
    
    nslots <- rows*cols
    plot_this <- c(rep("blank", nslots), "legend")
    plot_this[1:nGraphics] <- plots
    m <- matrix(c(1:nslots, rep(nslots + 1, cols)), nrow = rows + 1, ncol = cols,byrow = TRUE)
    layout(mat = m, heights = c(rep(0.9/rows, rows), 0.1)) 
    lg_size <- ifelse(rows > 1, 1, ifelse(err.bounds, 0.6, 0.7))
  }else{
    old.par <- par(no.readonly = TRUE)
    on.exit(par(old.par))
    plot_this <- vector("character", nGraphics*2)
    plot_this[seq(1, nGraphics*2, 2)] <- plots
    plot_this[seq(2, nGraphics*2, 2)] <- "legend"
    m <- matrix(c(1,2), nrow = 2, ncol = 1,byrow = TRUE)
    layout(mat = m, heights = c(0.9, 0.1)) 
    lg_size <- ifelse(err.bounds, 0.6, 0.7)
  }
  
  for (i in 1:length(plot_this)) {
    switch(plot_this[i],
            "digits" = plotting.data.vs.benford(x, col.bar, grid, err.bounds, alpha, ...),
            "rootogram digits" = plotting.rootogram.data.vs.benford(x, col.bar, grid, err.bounds, alpha, ...),
            "second order" = plotting.second.order(x, col.bar, grid, ...),
            "rootogram second order" = plotting.rootogram.second.order(x, col.bar, grid, ...),
            "summation" = plotting.summation(x, col.bar, grid, ...),
            "mantissa" = plotting.ordered.mantissa(x, grid, ...),
            "chi squared" = plotting.chi_squared(x, grid, ...),
            "abs diff" = plotting.abs.diff(x, grid, ...),
            "ex summation" = plotting.ex.summation(x, grid, ...),
            "legend" = plotting.legend(x, err.bounds, lg_size),
            "blank" = plot.new()
    ) 
  }
  
}

##' @title Print method for Benford Analysis
##' @description The \code{print} method for "Benford" objects.
##' @usage 
##' 
##' \method{print}{Benford}(x, how.many=5, ...)
##' @param  x a "Benford" object.
##' @param how.many a number that defines how many of the biggest absolute differences to show.
##' @param ... arguments to be passed to generic print functions.
##' @return Prints the Benford object.
##' @export
print.Benford <- function(x,how.many=5,...){
  
  if(class(x)!="Benford") stop("Class(x) must be 'Benford'")
  cat("\nBenford object:\n",
      "\nData:", x[["info"]]$data.name,
      "\nNumber of observations used =", x[["info"]]$n,
      "\nNumber of obs. for second order =", x[["info"]]$n.second.order,
      "\nFirst digits analysed =", x[["info"]]$number.of.digits)    
  
  cat("\n\nMantissa: \n")
  cat("\n")
  pretty_print <- x$mantissa
  pretty_print$statistic <- gsub("Mantissa|\\s", "", pretty_print$statistic)
  pretty_print <- setNames(pretty_print, c("Statistic", "Value"))
  print.data.frame(pretty_print, row.names = FALSE, digits = 2)
  cat("\n")
  
  cat("\nThe", how.many, "largest deviations: \n")
  cat("\n")
  print.data.frame(round(head(x[["bfd"]][order(absolute.diff, decreasing=TRUE)][,list(digits, absolute.diff)], how.many), 2))
  cat("\n")
  
  cat("Stats:\n")
  print(x[["stats"]]$chisq)
  print(x[["stats"]]$mantissa.arc.test)
  print(x[["stats"]]$ks.test)
  cat("Mean Absolute Deviation (MAD):",x[["MAD"]])
  if (!is.na(x[["MAD.conformity"]])) 
    cat("\nMAD Conformity - Nigrini (2012):", x[["MAD.conformity"]])
  cat("\nDistortion Factor:", x[["distortion.factor"]])
  cat("\n\nRemember: Real data will never conform perfectly to Benford's Law. You should not focus on p-values!")
  values <- NULL
  absolute.diff <- NULL
  digits <- NULL
}