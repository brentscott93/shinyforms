#' Creates an AdminLTE like Box w/ colored top
#' @noRd
titleBox <- function(title, description){
  div(class = 'quickform-title',
      div(class = 'header', title),
      div(class = "body", description)
  )
}

#' Creates a plain AdminLTE like box
#' @noRd
questionBox <- function(question, ui){
  div(class = 'quickform',
      div(class = 'header', question),
      div(class = "body", ui)
  )
}

#' Generates UI for quickform
#' @description This is the 'muscle' behind the UI building and taken from the UI of shinyforms. It takes a list(id, type, etc.) and decides what to make. Used with lapply in main quickform() function over questions arguments.
#' @param question A list containing id, type, required, and (optionally) choices
#' @noRd
createQuestion <- function(question){

  checkmate::assertString(question[["id"]])
  checkmate::assertString(question[["type"]])
  checkmate::assertString(question[["question"]])
  #decide what widget to make
  #all the shiny widgets have been renamed with wrappers to mimic the google form options
  if(question[["type"]] == "numeric"){
    input <- shiny::numericInput(question[["id"]], NULL, 0, width = "100%")
  } else if(question[["type"]] == "checkbox"){
    input <- shiny::checkboxInput(question[["id"]], question[["choices"]])
  } else if(question[["type"]] == 'multiplechoice'){
    input <- multipleChoice(question[["id"]], question[["choices"]])
  } else if(question[["type"]] == 'dropdown'){
    input < dropdown(question[["id"]], choices)
  } else if(question[["type"]] == 'shortanswer'){
    input <- shortAnswer(question[["id"]])
  } else if(question[["type"]] == 'paragraph'){
    input <- paragraph(question[["id"]])
  } else {
    stop('Not a valid question type')
  }
  #if questions is marked as required add a 'Required *' tag before widget
  if(!is.null(question[["required"]])){
    if (question[["required"]]){
      ui <- shiny::tagList(shiny::h5('Required *', style = 'color:#fd0800;'), input)
    } else {
      ui <- input
    }
  } else {
    ui <- input
  }
  #put everything in a box to make it look like a Google Form
  #one widget to a box
  questionBox(question[["question"]], ui)
  
}

#' Convenient wrappers for shiny widgets using the googleForm lingo
#' @param id an inputId
#' @param choices a list
#' @noRd
multipleChoice <- function(id, choices){
  shiny::radioButtons(inputId = id,
                      label = NULL,
                      choices = choices,
                      inline = FALSE)
}


#' Convenient wrappers for shiny widgets using the googleForm lingo
#' @param id an inputId
#' @param choices a list
#' @noRd
checkbox <- function(id, choices){
  shiny::checkboxInput(inputId =  id,
                       label = NULL,
                       value= FALSE)
}

#' Convenient wrappers for shiny widgets using the googleForm lingo
#' @param id an inputId
#' @param choices a list
#' @noRd
dropdown <- function(id, choices){
  shiny::selectInput(inputId = id,
                     label = NULL,
                     choices = choices,
                     width = "100%")
}


#' Convenient wrappers for shiny widgets using the googleForm lingo
#' @param id an inputId
#' @noRd
shortAnswer <- function(id){
  shiny::textInput(inputId = id,
                   label = NULL,
                   width = "100%")

}

#' Convenient wrappers for shiny widgets using the googleForm lingo
#' @param id an inputId
#' @noRd
paragraph <- function(id){
  shiny::tagAppendAttributes(shiny::textAreaInput(inputId = id,
                                                  label = NULL),
                             style = 'width: 100%;')
}

#' Check for NULL required inputs
#' @param question a question list 
#' @param input the input reatcive list created by shiny
#' @noRd
checkRequired <- function(question, input){
  if(!is.null(question[["required"]])){
    if(question[["required"]]){
      if(is.null(input[[question[["id"]]]])) showNotification('Please answer all required questions', type = 'error')
      req(!is.null(input[[question[["id"]]]]))
      if(nchar(input[[question[["id"]]]]) == 0) showNotification('Please answer all required questions', type = 'error')
      req(nchar(input[[question[["id"]]]]) != 0)
    }
  }
}

#' Save data to google drive
#' @description Currently not able to create a google sheet in a specific folder (see: https://github.com/tidyverse/googlesheets4/issues/111).
#' Current approach is to make a sheet and move it. 
#' Alternative would be to write to temp file locally and upload to specific folder.
#' @noRd
saveToDrive <- function(data, filename, folder){
  googlesheets4::gs4_create(name = filename, sheets = data)
  setProgress(0.75, detail = 'Please wait...')
  googledrive::drive_mv(filename, path = file.path(folder, filename))
}

#' Save reactive values
#' @noRd
getUserInput <- function(question, input){
  x <- data.frame(value = input[[question[["id"]]]])
  names(x) <- question[["id"]]
  x
}
