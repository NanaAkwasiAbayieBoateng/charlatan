safe_colors = c(
  'black', 'maroon', 'green', 'navy', 'olive',
  'purple', 'teal', 'lime', 'blue', 'silver',
  'gray', 'yellow', 'fuchsia', 'aqua', 'white'
)

#' ColorProvider
#'
#' @export
#' @keywords internal
#' @details
#' \strong{Methods}
#'   \describe{
#'    \item{\code{color_name}}{
#'      color name
#'    }
#'    \item{\code{safe_color_name}}{
#'      safe color name
#'    }
#'    \item{\code{hex_color}}{
#'      hex color
#'    }
#'    \item{\code{safe_hex_color}}{
#'      safe hex color
#'    }
#'    \item{\code{rgb_color}}{
#'      RGB color
#'    }
#'    \item{\code{rgb_css_color}}{
#'      RGB CSS color
#'    }
#'  }
#' @format NULL
#' @usage NULL
#' @examples
#' x <- ColorProvider$new()
#' x$locale
#' x$color_name()
#' x$safe_color_name()
#' x$hex_color()
#' x$safe_hex_color()
#' x$rgb_color()
#' x$rgb_css_color()
#'
#' x <- ColorProvider$new(locale = "uk_UA")
#' x$locale
#' x$color_name()
ColorProvider <- R6::R6Class(
  inherit = BaseProvider,
  'ColorProvider',
  public = list(
    locale = NULL,
    all_colors = NULL,
    safe_colors = safe_colors,

    initialize = function(locale = NULL) {
      if (!is.null(locale)) {
        # check global locales
        super$check_locale(locale)
        # check person provider locales
        check_locale_(tolower(locale), color_provider_locales)
        self$locale <- locale
      } else {
        self$locale <- 'en_US'
      }
      self$all_colors <- parse_eval("all_colors_", self$locale)
    },

    color_name = function() {
      super$random_element(names(self$all_colors))
    },

    safe_color_name = function() {
      super$random_element(self$safe_colors)
    },

    hex_color = function() {
      grDevices::rgb(private$sample_col(), private$sample_col(),
                     private$sample_col(), maxColorValue = 255)
    },

    safe_hex_color = function() {
      x <- sprintf("%x", super$random_int(0, 255))
      x <- if (nchar(x) < 3) paste0(x, rep("0", 3 - nchar(x))) else x
      paste0(
        "#",
        private$ind(x, 1), private$ind(x, 1),
        private$ind(x, 2), private$ind(x, 2),
        private$ind(x, 3), private$ind(x, 3),
        collapse = ""
      )
    },

    rgb_color = function() {
      as.vector(grDevices::col2rgb(self$hex_color()))
    },

    rgb_css_color = function() {
      sprintf("rgb(%s)", paste0(self$rgb_color(), collapse = ", "))
    }
  ),

  private = list(
    ind = function(x, y) {
      substring(x, y, y)
    },

    rgb_color_list = function() {
      color <- self$rgb_color()
      sprintf("(%s)", paste0(color, collapse = ", "))
    },

    sample_col = function() sample(0:255, 1)

  )
)

#' @export
#' @rdname ColorProvider
color_provider_locales <- c("uk_ua", "en_us")
