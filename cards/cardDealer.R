# 0. Setup inicial ########
## Carrega as bibliotecas
library(rmarkdown)
library(dplyr)
library(glue)
library(stringr)
library(stringi)

## Carrega as informações sobre as páginas
allData <- read.csv("cards/links_externos.csv")
allData <- read.csv("cards/links_seplag.csv") |> 
  dplyr::bind_rows(allData) |> 
  dplyr::rename("PAGE" = "NOME.DO.PAINEL",
                "DESC" = "DESCRIÇÃO") |> 
  dplyr::mutate(PAGE = stringi::stri_trans_general(PAGE, "latin-ascii; upper"),
                PAGE = stringr::str_replace_all(PAGE, "[:space:]", "_"),
                HEADER = glue::glue("images/TITLE_{PAGE}.png")) |> 
  dplyr::select(PAGE, HEADER, LINK, DESC) 

# 1. Produção dos cards ########
## Cria os cards em loop
for (iter in seq_len(nrow(allData))) {
  data = allData[iter,]
  rmarkdown::render(
    input = "cards/deck.Rmd",
    output_dir = "cards/pages",
    output_file = glue::glue("{data$PAGE}.html"),
    params = list(data = data)
  )
}
