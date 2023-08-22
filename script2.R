library(tidyverse)
library(rvest)
library(glue)
library(stringr)
library(jsonlite)
library(lubridate)
library(curl)
library(xml2)
library(httr)

sites <- c("https://www.publico.pt/" ,
           "https://expresso.pt/",
           "https://rr.sapo.pt/",
           "https://www.dn.pt/",
           "https://www.cmjornal.pt/",
           "https://www.tsf.pt/",
           "https://24.sapo.pt/",
           "https://sicnoticias.pt/",
           "https://cnnportugal.iol.pt/",
           "https://observador.pt/",
           "https://www.noticiasaominuto.com/",
           "https://sol.sapo.pt/",
           "https://ionline.sapo.pt/"
           )

links <- data.frame(
  sites = sites,
  links = NA
)

while (is.na(links[1,2])) {
  links[1,2] <- read_html(sites[1]) %>% 
    html_element("section") %>% 
    html_element("h2") %>% 
    html_element("a") %>% 
    html_attr("href") %>% 
    url_absolute(links[1,1])
  
  cat(links[1,2])
  cat("\n")
  cat("\n")
}

while (is.na(links[2,2])) {

  links[2,2] <- read_html(sites[2]) %>%
    html_element(".bloco-manchetes") %>%
    html_element("article") %>%
    html_element("a") %>%
    html_attr("href") %>%
    url_absolute(links[2,1])
  
  cat(links[2,2])
  cat("\n")
  cat("\n")
}


while (is.na(links[3,2])) {

  links[3,2] <- read_html(sites[3]) %>%
    html_element(".highlight") %>%
    html_element("a") %>%
    html_attr("href") %>%
    url_absolute(links[3,1])
  
  cat(links[3,2])
  cat("\n")
  cat("\n")
}

while (is.na(links[4,2])) {

  links[4,2] <- read_html(sites[4]) %>%
    html_element("article") %>%
    html_element("a") %>%
    html_attr("href") %>%
    url_absolute(links[4,1])
  
  cat(links[4,2])
  cat("\n")
  cat("\n")
}

while (is.na(links[5,2])) {

  links[5,2] <- read_html(sites[5]) %>%
    html_element(".manchetes_container") %>%
    html_element(".manchete_maior") %>%
    html_element("article") %>%
    html_element("h1") %>%
    html_element("a") %>%
    html_attr("href") %>%
    url_absolute(links[5,1])
  
  cat(links[5,2])
  cat("\n")
  cat("\n")

}


while (is.na(links[6,2])) {

  links[6,2] <- read_html(sites[6]) %>%
    html_element(xpath = "/html/body/ngx-body/main/section[2]") %>% 
    html_element("a") %>%
    html_attr("href") %>%
    url_absolute(links[6,1])
  
  cat(links[6,2])
  cat("\n")
  cat("\n")
}

while (is.na(links[7,2])) {

  links[7,2] <- read_html(sites[7]) %>%
    html_element(".main") %>%
    html_element("a") %>%
    html_attr("href")  %>%
    url_absolute(links[7,1])
  
  cat(links[7,2])
  cat("\n")
  cat("\n")
}


while (is.na(links[8,2])) {

  links[8,2] <- read_html(sites[8]) %>%
    html_element(".wrapper") %>%
    html_element("section") %>%
    html_element("a") %>%
    html_attr("href") %>%
    url_absolute(links[8,1])
  
  cat(links[8,2])
  cat("\n")
  cat("\n")
}


while (is.na(links[9,2])) {

  links[9,2] <- read_html(sites[9]) %>%
    html_element(".manchetes") %>%
    html_element("a") %>%
    html_attr("href")
  
  cat(links[9,2])
  cat("\n")
  cat("\n")

}


while (is.na(links[10,2])) {

  links[10,2] <- read_html(sites[10]) %>%
    html_element(".editorial-grid") %>%
    html_element("a") %>%
    html_attr("href")

  
  cat(links[10,2])
  cat("\n")
  cat("\n")
}


while (is.na(links[11,2])) {

  links[11,2] <- read_html(sites[11]) %>%
    html_element(".swiper-wrapper") %>%
    html_element("a") %>%
    html_attr("href")

  cat(links[11,2])
  cat("\n")
  cat("\n")
}

while (is.na(links[12,2])) {

  links[12,2] <- read_html(sites[12]) %>%
    html_element("#block1") %>%
    html_element("a") %>%
    html_attr("href") %>%
    url_absolute(links[12,1])
  
  cat(links[12,2])
  cat("\n")
  cat("\n")

}


while (is.na(links[13,2])) {
  links[13,2] <- read_html(sites[13]) %>%
    html_element("#manchete") %>%
    html_element("a") %>%
    html_attr("href") %>%
    url_absolute(links[13,1])
  
  cat(links[13,2])
  cat("\n")
  cat("\n")
}


to_publish <- data.frame()

clean_link <- function(text) {
  link <- str_trim(text)
  
  link <- sub("\\?ref=.*", "", link)

  return(link)  
}



for (i in 1:length(links$sites)) {
  
  
  link <- clean_link(links$links[i])
  page <- read_html(GET(link))
  
    cat(link)
    cat("\n")
    cat("\n")
  
  manchete <- tibble(
    time = Sys.time(),
    titulo = page %>% html_nodes(xpath = '//meta[@property="og:title"]') %>% html_attr("content"),
    thumb = page %>% html_nodes(xpath = '//meta[@property="og:image"]') %>% html_attr("content"),
    desc = page %>% html_nodes('meta[name="description"]') %>% html_attr("content"),
    link = link
  )
  
  to_publish <-  to_publish %>% bind_rows(manchete)
  
}


df <- read_rds("por_publicar.rds") %>%
  bind_rows(to_publish) %>%
  distinct(link, .keep_all = T)

noticias_publicadas <- read_rds("noticias_pubicadas.rds") %>% 
  distinct(link, .keep_all = T)

df <- df %>%
  anti_join(noticias_publicadas) %>%
  filter(time >= (Sys.time() - hours(1))) %>% 
  distinct(link, .keep_all = T)

if(nrow(df) == 0) {
  toJSON(df) %>% write("apublicar.json")
} else {
  random_index <- sample(1:nrow(to_publish), 1)
  noticia_a_publicar <- df[random_index,]
  toJSON(noticia_a_publicar) %>% write("apublicar.json")
}


noticias_publicadas <- noticias_publicadas %>% 
  bind_rows(noticia_a_publicar)

noticias_publicadas %>% write_rds("noticias_pubicadas.rds")

df <- df %>% anti_join(noticias_publicadas) %>% write_rds("por_publicar.rds")


