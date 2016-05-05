# Get_colleges
# Scrape webpages to get colleges of active players

# Getting Player Stats by College

library(rvest)
library(stringr)

page = read_html("http://www.basketball-reference.com/friv/colleges.cgi?college=nillinois")

links = page %>% html_nodes("option") %>% html_attr("value") %>% paste0("http://www.basketball-reference.com", .)
subpages = lapply(links, read_html)

get_df = function(page){
  data.frame(
    player = page %>% html_nodes("td+ td , #stats a") %>% html_nodes("a") %>% html_text(),
    start = page %>% html_nodes("td:nth-child(3)") %>% html_text(),
    end = page %>% html_nodes("td:nth-child(4)") %>% html_text(),
    games = page %>% html_nodes("td:nth-child(5)") %>% html_text(),
    MP_tot = page %>% html_nodes("td:nth-child(6)") %>% html_text(),
    FG_tot = page %>% html_nodes("td:nth-child(7)") %>% html_text(),
    FGA_tot = page %>% html_nodes("td:nth-child(8)") %>% html_text(),
    TP_tot = page %>% html_nodes("td:nth-child(9)") %>% html_text(),
    TPA_tot = page %>% html_nodes("td:nth-child(10)") %>% html_text(),
    FT_tot = page %>% html_nodes("td:nth-child(11)") %>% html_text(),
    FTA_tot = page %>% html_nodes("td:nth-child(12)") %>% html_text(),
    ORB_tot = page %>% html_nodes("td:nth-child(13)") %>% html_text(),
    TRB_tot = page %>% html_nodes("td:nth-child(14)") %>% html_text(),
    AST_tot = page %>% html_nodes("td:nth-child(15)") %>% html_text(),
    STL_tot = page %>% html_nodes("td:nth-child(16)") %>% html_text(),
    BLK_tot = page %>% html_nodes("td:nth-child(17)") %>% html_text(),
    TOV_tot = page %>% html_nodes("td:nth-child(18)") %>% html_text(),
    PF_tot = page %>% html_nodes("td:nth-child(19)") %>% html_text(),
    PTS_tot = page %>% html_nodes("td:nth-child(20)") %>% html_text(),
    FG_per = page %>% html_nodes("td:nth-child(21)") %>% html_text(),
    TP_per = page %>% html_nodes("td:nth-child(22)") %>% html_text(),
    FT_per = page %>% html_nodes("td:nth-child(23)") %>% html_text(),
    MP_pg = page %>% html_nodes("td:nth-child(24)") %>% html_text(),
    PTSpg = page %>% html_nodes("td:nth-child(25)") %>% html_text(),
    TRB_pg = page %>% html_nodes("td:nth-child(26)") %>% html_text(),
    AST_pg = page %>% html_nodes("td:nth-child(27)") %>% html_text(),
    school = page %>% html_nodes("head") %>% html_nodes("title") %>% html_text() %>% str_extract(., "(?<=Attended\\s).*(?=\\s\\|)"),
    stringsAsFactors = FALSE
  )}

playercolleges = lapply(subpages, get_df) %>% rbind_all()

