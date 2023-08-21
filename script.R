library(tidyverse)
library(rvest)
library(glue)
library(stringr)
library(jsonlite)
library(lubridate)

sites <- c("https://www.publico.pt/", 
           "https://expresso.pt/", 
           "https://rr.sapo.pt/",
           "https://www.dn.pt/",
           "https://www.cmjornal.pt/",
           "https://www.tsf.pt/",
           "https://www.rtp.pt/noticias/",
           "https://sicnoticias.pt/",
           "https://cnnportugal.iol.pt/",
           "https://observador.pt/",
           "https://www.noticiasaominuto.com/",
           "https://sol.sapo.pt/",
           "https://ionline.sapo.pt/")



publico <- read_html(sites[1]) %>% 
  html_element("section") %>% 
  html_element("h2") %>% 
  html_element("a") %>% 
  html_attr("href")

publico <- glue("https://www.publico.pt{publico}")

manchete_publico <- tibble(
  time = Sys.time(),
  titulo = publico %>% read_html() %>% html_nodes(xpath = '//meta[@property="og:title"]') %>% html_attr("content"),
  thumb = publico %>% read_html() %>% html_nodes(xpath = '//meta[@property="og:image"]') %>% html_attr("content"),
  desc = publico %>% read_html() %>% html_nodes(xpath = '//meta[@property="og:description"]') %>% html_attr("content"),
  link = publico
)

cat(glue("getting {sites[1]}"))
cat("/n")



expresso <- read_html(sites[2]) %>%
  html_element(".bloco-manchetes") %>%
  html_element("article") %>%
  html_element("a") %>%
  html_attr("href")

expresso <- glue("https://expresso.pt{expresso}")

manchete_expresso <- tibble(
  time = Sys.time(),
  titulo = expresso %>% read_html() %>% html_nodes(xpath = '//meta[@property="og:title"]') %>% html_attr("content"),
  thumb = expresso %>% read_html() %>% html_nodes(xpath = '//meta[@property="og:image"]') %>% html_attr("content"),
  desc = expresso %>% read_html() %>% html_nodes(xpath = '//meta[@property="og:description"]') %>% html_attr("content"),
  link = expresso
)

cat(glue("getting {sites[2]}"))
cat("/n")



rr <- read_html(sites[3]) %>%
  html_element(".highlight") %>%
  html_element("a") %>%
  html_attr("href")

rr <- glue("https://rr.sapo.pt/{rr}")

manchete_rr <- tibble(
  time = Sys.time(),
  titulo = rr %>% read_html() %>% html_nodes(xpath = '//meta[@property="og:title"]') %>% html_attr("content"),
  thumb = rr %>% read_html() %>% html_nodes(xpath = '//meta[@property="og:image"]') %>% html_attr("content"),
  desc = rr %>% read_html() %>% html_nodes(xpath = '//meta[@property="og:description"]') %>% html_attr("content"),
  link = rr
)

cat(glue("getting {sites[3]}"))
cat("/n")



dn <- read_html(sites[4]) %>%
  html_element("article") %>%
  html_element("a") %>%
  html_attr("href")

dn <- glue("https://www.dn.pt{dn}")

manchete_dn <- tibble(
  time = Sys.time(),
  titulo = dn %>% read_html() %>% html_nodes(xpath = '//meta[@property="og:title"]') %>% html_attr("content"),
  thumb = dn %>% read_html() %>% html_nodes(xpath = '//meta[@property="og:image"]') %>% html_attr("content"),
  desc = dn %>% read_html() %>% html_nodes(xpath = '//meta[@property="og:description"]') %>% html_attr("content"),
  link = dn
)

cat(glue("getting {sites[4]}"))
cat("/n")


cm <- read_html(sites[5]) %>%
  html_element(".manchetes_container") %>%
  html_element(".manchete_maior") %>%
  html_element("article") %>%
  html_element("h1") %>%
  html_element("a") %>%
  html_attr("href")

cm <- glue("https://www.cmjornal.pt{cm}")

manchete_cm <- tibble(
  time = Sys.time(),
  titulo = cm %>% read_html() %>% html_nodes(xpath = '//meta[@property="og:title"]') %>% html_attr("content"),
  thumb = cm %>% read_html() %>% html_nodes(xpath = '//meta[@property="og:image"]') %>% html_attr("content"),
  desc = cm %>% read_html() %>% html_nodes('meta[name="description"]') %>% html_attr("content"),
  link = cm
)

cat(glue("getting {sites[5]}"))
cat("/n")


tsf <- read_html(sites[6]) %>%
  html_element(".t-section-4") %>%
  html_element("article") %>%
  html_element("a") %>%
  html_attr("href")

tsf <- glue("https://www.tsf.pt{tsf}")

manchete_tsf <- tibble(
  time = Sys.time(),
  titulo = tsf %>% read_html() %>% html_nodes(xpath = '//meta[@property="og:title"]') %>% html_attr("content"),
  thumb = tsf %>% read_html() %>% html_nodes(xpath = '//meta[@property="og:image"]') %>% html_attr("content"),
  desc = tsf %>% read_html() %>% html_nodes('meta[name="description"]') %>% html_attr("content"),
  link = tsf
)

cat(glue("getting {sites[6]}"))
cat("/n")


# 
# rtp <- read_html(sites[7]) %>%
#   html_element("section") %>%
#   html_element("a") %>%
#   html_attr("href") %>%
#   str_trim()
# 
# 
# manchete_rtp <- tibble(
#   time = Sys.time(),
#   titulo = rtp %>% read_html() %>% html_nodes(xpath = '//meta[@property="og:title"]') %>% html_attr("content"),
#   thumb = rtp %>% read_html() %>% html_nodes(xpath = '//meta[@property="og:image"]') %>% html_attr("content"),
#   desc = rtp %>% read_html() %>% html_nodes('meta[name="description"]') %>% html_attr("content"),
#   link = rtp
# )
# 
# 

sic <- read_html(sites[8]) %>%
  html_element(".wrapper") %>%
  html_element("section") %>%
  html_element("a") %>%
  html_attr("href") %>%
  str_trim()

sic <- glue("https://sicnoticias.pt/{sic}")


manchete_sic <- tibble(
  time = Sys.time(),
  titulo = sic %>% read_html() %>% html_nodes(xpath = '//meta[@property="og:title"]') %>% html_attr("content"),
  thumb = sic %>% read_html() %>% html_nodes(xpath = '//meta[@property="og:image"]') %>% html_attr("content"),
  desc = sic %>% read_html() %>% html_nodes('meta[name="description"]') %>% html_attr("content"),
  link = sic
)

cat(glue("getting {sites[8]}"))
cat("/n")



cnn <- read_html(sites[9]) %>%
  html_element(".manchetes") %>%
  html_element("a") %>%
  html_attr("href") %>%
  str_trim()


manchete_cnn <- tibble(
  time = Sys.time(),
  titulo = cnn %>% read_html() %>% html_nodes(xpath = '//meta[@property="og:title"]') %>% html_attr("content"),
  thumb = cnn %>% read_html() %>% html_nodes(xpath = '//meta[@property="og:image"]') %>% html_attr("content"),
  desc = cnn %>% read_html() %>% html_nodes('meta[name="description"]') %>% html_attr("content"),
  link = cnn
)


cat(glue("getting {sites[9]}"))
cat("/n")


obs <- read_html(sites[10]) %>%
  html_element(".editorial-grid") %>%
  html_element("a") %>%
  html_attr("href") %>%
  str_trim()


manchete_obs <- tibble(
  time = Sys.time(),
  titulo = obs %>% read_html() %>% html_nodes(xpath = '//meta[@property="og:title"]') %>% html_attr("content"),
  thumb = obs %>% read_html() %>% html_nodes(xpath = '//meta[@property="og:image"]') %>% html_attr("content"),
  desc = obs %>% read_html() %>% html_nodes('meta[name="description"]') %>% html_attr("content"),
  link = obs
)

cat(glue("getting {sites[10]}"))
cat("/n")


nam <- read_html(sites[11]) %>%
  html_element(".swiper-wrapper") %>%
  html_element("a") %>%
  html_attr("href") %>%
  str_trim()


manchete_nam <- tibble(
  time = Sys.time(),
  titulo = nam %>% read_html() %>% html_nodes(xpath = '//meta[@property="og:title"]') %>% html_attr("content"),
  thumb = nam %>% read_html() %>% html_nodes(xpath = '//meta[@property="og:image"]') %>% html_attr("content"),
  desc = nam %>% read_html() %>% html_nodes('meta[name="description"]') %>% html_attr("content"),
  link = nam
)

cat(glue("getting {sites[11]}"))
cat("/n")


sol <- read_html(sites[12]) %>%
  html_element("#block1") %>%
  html_element("a") %>%
  html_attr("href") %>%
  str_trim()

sol <- glue("https://sol.sapo.pt{sol}")


manchete_sol <- tibble(
  time = Sys.time(),
  titulo = sol %>% read_html() %>% html_nodes(xpath = '//meta[@property="og:title"]') %>% html_attr("content"),
  thumb = sol %>% read_html() %>% html_nodes(xpath = '//meta[@property="og:image"]') %>% html_attr("content"),
  desc = sol %>% read_html() %>% html_nodes('meta[name="description"]') %>% html_attr("content"),
  link = sol
)

cat(glue("getting {sites[12]}"))
cat("/n")



ji <- read_html(sites[13]) %>%
  html_element("#manchete") %>%
  html_element("a") %>%
  html_attr("href") %>%
  str_trim()

ji <- glue("https://ionline.sapo.pt{ji}")


manchete_ji <- tibble(
  time = Sys.time(),
  titulo = ji %>% read_html() %>% html_nodes(xpath = '//meta[@property="og:title"]') %>% html_attr("content"),
  thumb = ji %>% read_html() %>% html_nodes(xpath = '//meta[@property="og:image"]') %>% html_attr("content"),
  desc = ji %>% read_html() %>% html_nodes('meta[name="description"]') %>% html_attr("content"),
  link = ji
)

cat(glue("getting {sites[13]}"))
cat("/n")



to_publish <- manchete_publico %>%
  bind_rows(manchete_expresso) %>%
  bind_rows(manchete_rr) %>%
  bind_rows(manchete_dn) %>%
  bind_rows(manchete_cm) %>%
  bind_rows(manchete_tsf) %>%
  bind_rows(manchete_sic) %>%
  bind_rows(manchete_cnn) %>%
  bind_rows(manchete_obs) %>%
  bind_rows(manchete_nam) %>%
  bind_rows(manchete_sol) %>%
  bind_rows(manchete_ji)


df <- read_rds("por_publicar.rds") %>%
  bind_rows(to_publish) %>%
  distinct(link, .keep_all = T)

noticias_publicadas <- read_rds("noticias_pubicadas.rds") %>% 
  distinct(link, .keep_all = T)

df <- df %>%
  anti_join(noticias_publicadas) %>%
  filter(time >= (Sys.time() - hours(3)))

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




