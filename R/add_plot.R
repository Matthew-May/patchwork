#' @importFrom ggplot2 ggplot_add
#' @export
ggplot_add.ggplot <- function(object, plot, object_name) {
  assemble <- get_assemble(plot)
  as.ggassemble(object, assemble)
}

get_assemble <- function(plot) {
  if (is.ggassemble(plot)) {
    assemble <- plot$assemble
    plot$assemble <- NULL
    class(plot) <- c('gg', 'ggplot')
  } else {
    assemble <- new_assemble()
  }
  assemble$plots[vapply(assemble$plots, is.filler, logical(1))] <- NULL
  assemble$plots <- c(assemble$plots, list(plot))
  assemble
}
is.ggassemble <- function(x) inherits(x, 'ggassemble')
as.ggassemble <- function(plot, assemble) {
  UseMethod('as.ggassemble')
}
as.ggassemble.ggplot <- function(plot, assemble) {
  class(plot) <- c('ggassemble', class(plot))
  plot$assemble <- assemble
  plot
}
#' @importFrom ggplot2 ggplot
as.ggassemble.ggassemble <- function(plot, assemble) {
  assembles <- list(assemble, get_assemble(plot))
  assemble <- new_assemble()
  assemble$plots <- assembles
  plot <- plot_filler()
  as.ggassemble(plot, assemble)
}
new_assemble <- function() {
  list(
    plots = list(),
    layout = plot_layout()
  )
}

plot_filler <- function() {
  p <- ggplot()
  class(p) <- c('filler', class(p))
  p
}
is.filler <- function(x) inherits(x, 'filler')