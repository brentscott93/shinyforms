% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/quickform.R
\name{quickform}
\alias{quickform}
\title{Quickly create a Google Form look-a-like Shiny app}
\usage{
quickform(
  title = NULL,
  description = NULL,
  questions = NULL,
  gmail = FALSE,
  folder = "shinyforms",
  returningUser = FALSE,
  emailId = FALSE,
  subject = "Your survey ID",
  color = "#2e77ff"
)
}
\arguments{
\item{title}{a character string. Title of the form/survey.}

\item{description}{a character string. A description providing more information about the form/survey.}

\item{questions}{a nested list of questions. Must contain 'id', 'type', 'question', and 'choices' (depending on the type of input) in each list element. The widget types are based on the naming from Google Forms and must be one of the following: 
"numeric", "checkbox", "multiplechoice", "dropdown", "paragraph", "shortanswer".  See example.}

\item{gmail}{either FALSE to save data locally or your gmail account to store data in Google Drive and optionally to email IDs to users. 
Each response is saved as an individual Google Sheet and is saved in the folder specified in the 'folder' argument. 
Google Drive/Sheets authorization is cached in the shiny app directory in '.secrets'. Make sure to upload this file when deploying to a server (like shinyapps.io).
Similarily, gmailr authorization is stored in '.gm-secrets'.}

\item{folder}{a character string specifying the folder on desktop/Google Drive to store results in.}

\item{returningUser}{logical. Do you want provide users an ID# in order to return and edit/update their survey? Default is FALSE.}

\item{emailId}{logical.  Do you want to email ID to users?  Only implemented if "returningUser=T" and valid email is given to "gmail" argument.
Default is FALSE.
If TRUE, need to setup gmail credentials and move the json file into quickform/shiny app directory as 'credentials.json'.
\href{https://github.com/r-lib/gmailr}{More info on gmailr package and setup}.}

\item{subject}{a character string. For the subject of your email. Default is 'Your survey ID'. Only used if "emailId=T".}

\item{color}{a character string specifying a hex color or to theme the app. Default is blue ("#2e77ff"). Header of title box and submit button are the actual color and background is made semi-transparent `with scales::alpha(color, 0.5)`.}
}
\value{
A Shiny App
}
\description{
Create a shiny app with minimal code that mimicks the look of a Google Form. 
 Currently only stores data in Google Drive (or locally) and has the option to allow survey participants to return and edit their survey by providing a unique ID.
 The IDs can also be emailed to the user (see "emailId").
 Use of remote storage with Google Drive or emailing IDs requires one-time interactive setup of {googledrive}, {googlesheets4}, and {gmailr} (if applicable). 
 This function has little flexibility/customize-ability, but offers quick and easy setup that reduces the time needed between developing and deploying a survey.
 \href{https://brentscott93.shinyapps.io/quickform/}{Live Demo}
 
 This is basically a wrapper around the usual shinyApp(ui, server) workflow that exists in an app.R file so there is no need to write any Shiny code or even explicitly call library(shiny). 
 quickform() will handle all of that.. 
 As a result, a quickform() app can only exist as a standalone app.R file.
}
\examples{
if(interactive()){
library(shinyforms)
quickform(
title = "My Survey",
description = "Describe your survey here",
questions = list(
  list(id = "name",
       type = "shortanswer",
       question = "What is your name?"),
  list(id = "age",
       type = "numeric",
       question = "Age (yrs)",
       required = TRUE),
  list(id = "ethnicity",
       type = "multiplechoice",
       question = "Are you of Hispanic, Latino, or of Spanish origin?" ,
       choices = list("No", "Yes"),
       required = TRUE),
  list(id = "shortanswer",
       type = "shortanswer",
       question = "One word to describe this app",
       required = TRUE),
  list(id = "user_opinion",
       type = "paragraph",
       question= "Please provide any feedback")
),
gmail = FALSE,
folder = "shinyforms"
)
}
}
